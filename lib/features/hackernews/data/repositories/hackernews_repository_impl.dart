import 'package:vibechan/features/hackernews/data/datasources/hackernews_api_client.dart';
import 'package:vibechan/features/hackernews/data/models/hacker_news_item.dart';
import 'package:vibechan/features/hackernews/domain/repositories/hackernews_repository.dart';
import 'package:injectable/injectable.dart';
import 'dart:async';
import 'package:vibechan/features/fourchan/domain/models/media.dart';

// Define story types for caching purposes
enum HackerNewsStoryType { top, newest, best }

@LazySingleton(as: HackerNewsRepository)
class HackerNewsRepositoryImpl implements HackerNewsRepository {
  final HackerNewsApiClient _apiClient;

  // Cache for story IDs by type
  final Map<HackerNewsStoryType, List<int>> _storyIdsCache = {};
  // Cache for individual items by ID
  final Map<int, HackerNewsItem> _itemCache = {};
  // Cache expiration timestamps
  final Map<String, DateTime> _cacheExpiry = {};

  // Cache duration - 5 minutes for story lists, 30 minutes for individual items
  static const Duration _storyListCacheDuration = Duration(minutes: 5);
  static const Duration _itemCacheDuration = Duration(minutes: 30);
  // Define max depth for recursive comment fetching
  static const int _maxCommentDepth = 5;

  HackerNewsRepositoryImpl(this._apiClient);

  // Helper function to fetch items for a given list of IDs with improved error handling
  Future<List<HackerNewsItem>> _fetchItemsByIds(
    List<int> ids,
    int count,
  ) async {
    // Take only the requested number of IDs
    final limitedIds = ids.take(count).toList();

    // Use a list to collect successful results
    final results = <HackerNewsItem>[];

    // First get any cached items
    final uncachedIds = <int>[];
    for (final id in limitedIds) {
      final cachedItem = _getCachedItem(id);
      if (cachedItem != null) {
        results.add(cachedItem);
      } else {
        uncachedIds.add(id);
      }
    }

    // Process uncached items in bigger batches
    const batchSize = 20; // Increased from 10 to 20 to speed up loading
    for (var i = 0; i < uncachedIds.length; i += batchSize) {
      final end =
          (i + batchSize < uncachedIds.length)
              ? i + batchSize
              : uncachedIds.length;
      final batchIds = uncachedIds.sublist(i, end);

      // Process each batch with individual error handling
      final batchFutures =
          batchIds
              .map(
                (id) => getItem(id).catchError((e) {
                  // Don't log errors to avoid console pollution
                  return null; // Return null (compatible with Future<HackerNewsItem?>)
                }),
              )
              .toList();

      // Wait for the batch to complete
      final batchResults = await Future.wait(batchFutures);

      // Add only non-null results
      results.addAll(batchResults.whereType<HackerNewsItem>());

      // If we have enough results, we can stop
      if (results.length >= count) {
        break;
      }
    }

    return results;
  }

  // Helper function to fetch story IDs and then their items with improved error handling
  Future<List<HackerNewsItem>> _fetchStoriesByPath(
    Future<List<int>> Function() idFetcher,
    int count,
    HackerNewsStoryType storyType,
  ) async {
    try {
      // Check cache first
      final cachedIds = _getCachedStoryIds(storyType);
      if (cachedIds != null) {
        return await _fetchItemsByIds(cachedIds, count);
      }

      // Add timeout to prevent hanging
      final ids = await idFetcher().timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw TimeoutException('Failed to fetch story IDs within timeout');
        },
      );

      if (ids.isEmpty) {
        return [];
      }

      // Cache the story IDs
      _cacheStoryIds(storyType, ids);

      return await _fetchItemsByIds(ids, count);
    } catch (e) {
      // Return empty list instead of rethrowing to avoid UI hanging on spinner
      return [];
    }
  }

  @override
  Future<List<HackerNewsItem>> getTopStories({int count = 30}) async {
    return _fetchStoriesByPath(
      _apiClient.getTopStoryIds,
      count,
      HackerNewsStoryType.top,
    );
  }

  @override
  Future<List<HackerNewsItem>> getNewStories({int count = 30}) async {
    return _fetchStoriesByPath(
      _apiClient.getNewStoryIds,
      count,
      HackerNewsStoryType.newest,
    );
  }

  @override
  Future<List<HackerNewsItem>> getBestStories({int count = 30}) async {
    return _fetchStoriesByPath(
      _apiClient.getBestStoryIds,
      count,
      HackerNewsStoryType.best,
    );
  }

  @override
  Future<HackerNewsItem> getItem(int id) async {
    // Check cache first (including items possibly cached with comments)
    final cachedItem = _getCachedItem(id);
    if (cachedItem != null) {
      return cachedItem;
    }

    // If not in cache, fetch basic item data
    try {
      final itemJson = await _apiClient
          .getItemById(id)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw TimeoutException('Timed out fetching item $id');
            },
          );

      // Initial parse without nested comments
      final item = HackerNewsItem.fromJson(itemJson);

      // Cache the basic item (without comments) immediately
      // This allows partial data display even if comment fetching fails later
      _cacheItem(id, item);

      return item;
    } catch (e) {
      // Rethrow to allow upstream handling (e.g., in recursive fetch)
      rethrow;
    }
  }

  // Fetches comments recursively up to a max depth
  Future<HackerNewsItem> _fetchCommentsRecursive(
    HackerNewsItem item,
    int currentDepth,
  ) async {
    // Base case: Max depth reached or no kids
    if (currentDepth >= _maxCommentDepth ||
        item.kids == null ||
        item.kids!.isEmpty) {
      // Return the item as is (potentially with comments from previous levels)
      return item;
    }

    // Limit the number of comments to fetch per level
    final commentIds = item.kids!.take(20).toList();

    // Fetch children recursively
    final futureComments =
        commentIds.map((kidId) async {
          try {
            // 1. Fetch the basic child item
            final basicChildItem = await getItem(kidId);
            // 2. Recursively fetch its comments
            return await _fetchCommentsRecursive(
              basicChildItem,
              currentDepth + 1,
            );
          } catch (e) {
            // Don't log errors to avoid console pollution
            return null; // Return null on error
          }
        }).toList();

    final fetchedComments = await Future.wait(futureComments);

    // Filter out nulls (errors during fetch) and assign to comments field
    final validComments = fetchedComments.whereType<HackerNewsItem>().toList();

    // Create a new item with the resolved comments
    final itemWithComments = item.copyWith(comments: validComments);

    // Update the cache with the item including its fetched comments
    _cacheItem(item.id, itemWithComments);

    return itemWithComments;
  }

  // Updated method to load comments for a specific item using recursion
  @override
  Future<HackerNewsItem> getItemWithComments(int id) async {
    try {
      // Check cache first. If it exists and has comments, return it.
      final cachedItem = _getCachedItem(id);
      if (cachedItem != null &&
          (cachedItem.comments != null && cachedItem.comments!.isNotEmpty ||
              cachedItem.kids == null ||
              cachedItem.kids!.isEmpty)) {
        return cachedItem;
      }

      // Fetch the basic item (might come from cache if fetched recently)
      final basicItem = await getItem(id);

      // Start recursive fetching from depth 0
      final itemWithFetchedComments = await _fetchCommentsRecursive(
        basicItem,
        0,
      );

      return itemWithFetchedComments;
    } catch (e) {
      // If any error occurs during the process, try returning a cached version
      // or rethrow if no cache exists.
      final cachedItem = _getCachedItem(id);
      if (cachedItem != null) {
        return cachedItem; // Return potentially stale cache on error
      }
      rethrow; // Rethrow if no cache available at all
    }
  }

  // Cache management methods
  void _cacheStoryIds(HackerNewsStoryType type, List<int> ids) {
    _storyIdsCache[type] = ids;
    _cacheExpiry['stories_${type.name}'] = DateTime.now().add(
      _storyListCacheDuration,
    );
  }

  List<int>? _getCachedStoryIds(HackerNewsStoryType type) {
    final expiry = _cacheExpiry['stories_${type.name}'];
    if (expiry != null && expiry.isAfter(DateTime.now())) {
      return _storyIdsCache[type];
    }
    return null;
  }

  void _cacheItem(int id, HackerNewsItem item) {
    _itemCache[id] = item;
    _cacheExpiry['item_$id'] = DateTime.now().add(_itemCacheDuration);
  }

  HackerNewsItem? _getCachedItem(int id) {
    final expiry = _cacheExpiry['item_$id'];
    if (expiry != null && expiry.isAfter(DateTime.now())) {
      return _itemCache[id];
    }
    return null;
  }

  // --- Dummy Implementations for Media Carousel ---

  @override
  Future<List<Media>> getAllMediaFromBoard(String boardId) async {
    // Hacker News doesn't have a concept of boards with media in this sense
    return [];
  }

  @override
  Future<List<Media>> getAllMediaFromThreadContext(
    String boardId, // Not applicable, but required by interface
    String threadId, // Corresponds to HN item ID
  ) async {
    // Hacker News items (threads) don't typically contain media directly
    return [];
  }

  @override
  Future<bool> boardHasMedia(String boardId) async => false;

  @override
  Future<bool> threadHasMedia(String boardId, String threadId) async => false;
}
