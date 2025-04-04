import 'package:injectable/injectable.dart';
import 'package:vibechan/features/lobsters/data/datasources/lobsters_api_client.dart';
import 'package:vibechan/features/lobsters/data/models/lobsters_story.dart';
import 'package:vibechan/features/lobsters/domain/repositories/lobsters_repository.dart';
import 'dart:async';
import 'package:vibechan/features/fourchan/domain/models/media.dart';

// Define story types for caching
enum LobstersStoryListType { hottest, newest }

@LazySingleton(as: LobstersRepository)
class LobstersRepositoryImpl implements LobstersRepository {
  final LobstersApiClient _apiClient;

  // Cache storage
  final Map<LobstersStoryListType, List<LobstersStory>> _storiesCache = {};
  final Map<String, LobstersStory> _storyDetailCache = {};
  final Map<String, DateTime> _cacheExpiry = {};

  // Cache durations
  static const Duration _storyListCacheDuration = Duration(minutes: 5);
  static const Duration _storyDetailCacheDuration = Duration(minutes: 30);

  LobstersRepositoryImpl(this._apiClient);

  Future<List<LobstersStory>> _fetchStories(
    Future<List<dynamic>> Function() fetcher,
    int count,
    LobstersStoryListType type,
  ) async {
    try {
      // Check cache first
      final cachedStories = _getCachedStories(type);
      if (cachedStories != null) {
        return cachedStories;
      }

      final dynamicList = await fetcher();
      final stories = <LobstersStory>[];
      for (final item in dynamicList) {
        if (item is Map<String, dynamic>) {
          try {
            final story = LobstersStory.fromJson(item);
            stories.add(story);

            // Also cache individual stories while we're at it
            _cacheStoryDetail(story.shortId, story);
          } catch (e) {
            // Skip errors silently
          }
        }
        if (stories.length >= count) break;
      }

      // Cache the stories
      _cacheStories(type, stories);

      return stories;
    } catch (e) {
      // Return empty list to avoid spinner
      return [];
    }
  }

  @override
  Future<List<LobstersStory>> getHottestStories({int count = 25}) {
    return _fetchStories(
      _apiClient.getHottestStories,
      count,
      LobstersStoryListType.hottest,
    );
  }

  @override
  Future<List<LobstersStory>> getNewestStories({int count = 25}) {
    return _fetchStories(
      _apiClient.getNewestStories,
      count,
      LobstersStoryListType.newest,
    );
  }

  @override
  Future<LobstersStory> getStory(String shortId) async {
    try {
      // Check cache first, ensuring it includes comments
      final cachedStory = _getCachedStoryDetail(shortId);
      if (cachedStory != null &&
          cachedStory.comments != null &&
          cachedStory.comments!.isNotEmpty) {
        // Return cached story only if it's valid AND has comments
        return cachedStory;
      }

      // Otherwise, fetch fresh data from the API
      final jsonData = await _apiClient.getStory(shortId);
      final story = LobstersStory.fromJson(jsonData);

      // Cache the newly fetched full story
      _cacheStoryDetail(shortId, story);

      return story;
    } catch (e) {
      rethrow;
    }
  }

  // --- Dummy Implementations for Media Carousel ---

  @override
  Future<List<Media>> getAllMediaFromBoard(String boardId) async {
    // Lobsters doesn't have boards, media is story-specific if at all
    return [];
  }

  @override
  Future<List<Media>> getAllMediaFromThreadContext(
    String boardId, // Not applicable
    String threadId, // Corresponds to story short_id
  ) async {
    // Lobsters stories don't typically contain structured media lists
    return [];
  }

  @override
  Future<bool> boardHasMedia(String boardId) async => false;

  @override
  Future<bool> threadHasMedia(String boardId, String threadId) async => false;

  // Cache management methods
  void _cacheStories(LobstersStoryListType type, List<LobstersStory> stories) {
    _storiesCache[type] = List.from(stories);
    _cacheExpiry['stories_${type.name}'] = DateTime.now().add(
      _storyListCacheDuration,
    );
  }

  List<LobstersStory>? _getCachedStories(LobstersStoryListType type) {
    final expiry = _cacheExpiry['stories_${type.name}'];
    if (expiry != null && expiry.isAfter(DateTime.now())) {
      return _storiesCache[type];
    }
    return null;
  }

  void _cacheStoryDetail(String shortId, LobstersStory story) {
    _storyDetailCache[shortId] = story;
    _cacheExpiry['story_$shortId'] = DateTime.now().add(
      _storyDetailCacheDuration,
    );
  }

  LobstersStory? _getCachedStoryDetail(String shortId) {
    final expiry = _cacheExpiry['story_$shortId'];
    if (expiry != null && expiry.isAfter(DateTime.now())) {
      return _storyDetailCache[shortId];
    }
    return null;
  }
}
