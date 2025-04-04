import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vibechan/core/di/injection.dart'; // Assuming GetIt setup is here
import 'package:vibechan/features/reddit/domain/models/reddit_post.dart';
import 'package:vibechan/features/reddit/domain/repositories/reddit_repository.dart';

part 'subreddit_posts_provider.g.dart';

// Using KeepAlive because we might want to preserve state when navigating back
// Using Family to pass the subreddit name
@Riverpod(keepAlive: true)
class SubredditPosts extends _$SubredditPosts {
  late final RedditRepository _repository;

  // Keep track of the 'after' token for pagination
  String? _lastAfter;
  bool _isLoadingMore = false;

  @override
  Future<List<RedditPost>> build(String subreddit) async {
    _repository =
        getIt<RedditRepository>(); // Get repository from GetIt/Injectable
    _lastAfter = null; // Reset pagination on initial build/rebuild
    // Initial fetch
    final posts = await _fetchPosts(subreddit);
    return posts;
  }

  Future<List<RedditPost>> _fetchPosts(
    String subreddit, {
    String? after,
  }) async {
    // Hardcoded limit for now, could be configurable
    const int fetchLimit = 25;
    final posts = await _repository.getSubredditPosts(
      subreddit: subreddit,
      after: after,
      limit: fetchLimit,
      // You might want to expose sort/timeFilter as parameters to build() later
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

  Future<void> fetchMorePosts() async {
    // Prevent simultaneous fetches or fetching when there are no more pages
    if (_isLoadingMore ||
        _lastAfter == null ||
        state.isRefreshing ||
        state.isLoading) {
      return;
    }

    _isLoadingMore = true;

    // Get current subreddit directly from the instance property
    // (The generator makes the family parameter available as a property)
    final String subreddit = this.subreddit;

    // Read current state safely
    final currentState = state;
    if (currentState is AsyncData<List<RedditPost>>) {
      final currentPosts = currentState.value;
      try {
        final newPosts = await _fetchPosts(subreddit, after: _lastAfter);
        // Update state with combined list
        state = AsyncData([...currentPosts, ...newPosts]);
      } catch (e, stackTrace) {
        // Handle error, perhaps revert state or show error message
        print("Error fetching more posts for r/$subreddit: $e");
        // Keep existing data but signal error (or could set state to AsyncError)
        // Using copyWithPrevious preserves the previous data while showing the error
        state = AsyncError<List<RedditPost>>(
          e,
          stackTrace,
        ).copyWithPrevious(currentState);
      } finally {
        _isLoadingMore = false;
      }
    } else {
      // If current state is error or loading, don't fetch more
      print(
        "Skipping fetchMorePosts as current state is not AsyncData: $currentState",
      );
      _isLoadingMore = false;
    }
  }
}
