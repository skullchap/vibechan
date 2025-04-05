import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vibechan/core/di/injection.dart'; // Assuming GetIt setup is here
import 'package:vibechan/features/reddit/domain/models/reddit_post.dart';
import 'package:vibechan/features/reddit/domain/repositories/reddit_repository.dart';
import 'package:vibechan/features/reddit/presentation/providers/reddit_sort_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

part 'subreddit_posts_provider.g.dart';

// Using KeepAlive because we might want to preserve state when navigating back
// Using Family to pass the subreddit name
@Riverpod(keepAlive: true)
class SubredditPosts extends _$SubredditPosts {
  // Use nullable and initialize in constructor instead of using 'late'
  RedditRepository? _repository;

  // Keep track of the 'after' token for pagination
  String? _lastAfter;
  bool _isLoadingMore = false;

  @override
  Future<List<RedditPost>> build(String subreddit) async {
    // Initialize repository only once
    _repository ??= getIt<RedditRepository>();

    // Reset pagination on initial build/rebuild
    _lastAfter = null;

    // Watch the sort type provider to rebuild this provider when sort changes
    final sortType = ref.watch(currentRedditSortTypeProvider);

    // Initial fetch
    final posts = await _fetchPosts(subreddit, sortType: sortType);
    return posts;
  }

  Future<List<RedditPost>> _fetchPosts(
    String subreddit, {
    String? after,
    required RedditSortType sortType,
  }) async {
    // Ensure repository is available
    final repository = _repository!;

    // Hardcoded limit for now, could be configurable
    const int fetchLimit = 25;
    final posts = await repository.getSubredditPosts(
      subreddit: subreddit,
      after: after,
      limit: fetchLimit,
      sort: sortType.apiValue,
      // Time filter can be added later (for top/controversial)
    );

    // Update the 'after' token based on the fetched posts
    if (posts.isNotEmpty && posts.length == fetchLimit) {
      // Reddit API uses fullnames (e.g., t3_abc123) for 'after'/'before'
      _lastAfter = 't3_${posts.last.id}';
    } else {
      _lastAfter = null; // Reached the end or fetched less than the limit
    }
    return posts;
  }

  // Method to load more posts
  Future<void> loadMore() async {
    if (_isLoadingMore || _lastAfter == null || state is! AsyncData) {
      return; // Already loading or no more to load or still loading initially
    }

    try {
      _isLoadingMore = true;
      final sortType = ref.read(currentRedditSortTypeProvider);
      final currentPosts = (state as AsyncData<List<RedditPost>>).value;

      // Fetch more posts using the last post as 'after' token
      final newPosts = await _fetchPosts(
        subreddit,
        after: _lastAfter,
        sortType: sortType,
      );

      // Update state with combined list
      state = AsyncData([...currentPosts, ...newPosts]);
    } catch (e, stack) {
      final logger = GetIt.instance<Logger>(instanceName: "AppLogger");
      logger.e(
        "Error loading more posts for r/$subreddit",
        error: e,
        stackTrace: stack,
      );
      // Do not update state on error, keep previous posts
      // Optionally show an error message to the user
    } finally {
      _isLoadingMore = false;
    }
  }
}
