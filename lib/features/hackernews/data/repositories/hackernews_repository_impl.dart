import 'package:vibechan/features/hackernews/data/datasources/hackernews_api_client.dart';
import 'package:vibechan/features/hackernews/data/models/hacker_news_item.dart';
import 'package:vibechan/features/hackernews/domain/repositories/hackernews_repository.dart';
import 'package:injectable/injectable.dart';
import 'dart:async';

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
                  return null
                      as HackerNewsItem?; // Explicit cast for type safety
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
    try {
      // Check cache first
      final cachedItem = _getCachedItem(id);
      if (cachedItem != null) {
        return cachedItem;
      }

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

      // Cache the item without comments
      _cacheItem(id, item);

      // Return the item without loading comments - they'll be loaded on demand
      return item;
    } catch (e) {
      rethrow;
    }
  }

  // New method to load comments for a specific item
  @override
  Future<HackerNewsItem> getItemWithComments(int id) async {
    try {
      // First get the basic item
      final item = await getItem(id);

      // If the item has kids and doesn't already have comments loaded
      if (item.kids != null &&
          item.kids!.isNotEmpty &&
          (item.comments == null || item.comments!.isEmpty)) {
        // Limit the number of comments to fetch to avoid excessive API calls
        final commentIds = item.kids!.take(20).toList();

        // Fetch all direct children concurrently with timeouts
        final futureComments =
            commentIds
                .where((kidId) => kidId != null)
                .map(
                  (kidId) => getItem(
                    kidId,
                  ).timeout(const Duration(seconds: 5)).catchError((e) {
                    // Don't log errors to avoid console pollution
                    return null
                        as HackerNewsItem?; // Explicit cast for type safety
                  }),
                )
                .toList();

        final fetchedComments = await Future.wait(futureComments);

        // Filter out nulls/errors and assign to comments field
        final validComments =
            fetchedComments.whereType<HackerNewsItem>().toList();

        // Create a new item with comments
        final itemWithComments = item.copyWith(comments: validComments);

        // Cache the item with comments
        _cacheItem(id, itemWithComments);

        // Return the item with its direct children
        return itemWithComments;
      } else {
        // Return the item as-is (might already have comments loaded)
        return item;
      }
    } catch (e) {
      rethrow;
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
}
