import '../../domain/models/models.dart'; // Barrel file for models

abstract class RedditRemoteDataSource {
  /// Fetches a list of posts from a specific subreddit.
  /// Defaults to 'hot' sorting if not specified.
  Future<List<RedditPost>> getSubredditPosts({
    required String subreddit,
    String? sort, // e.g., hot, new, top, rising
    String?
    timeFilter, // e.g., hour, day, week, month, year, all (for top/controversial)
    String? after, // For pagination
    int? limit,
  });

  /// Fetches details about a specific subreddit.
  Future<SubredditInfo> getSubredditInfo({required String subreddit});

  /// Fetches the details of a specific post and its comments.
  /// Returns a tuple: the post itself and the list of top-level comments.
  Future<(RedditPost, List<RedditComment>)> getPostAndComments({
    required String subreddit,
    required String postId,
    String? commentId, // Optional: focus on a specific comment thread
    int? depth, // Optional: limit comment depth
    String? sort, // e.g., confidence, top, new, controversial, old, qa
  });

  /// Searches for subreddits matching the query.
  Future<List<SubredditInfo>> searchSubreddits({
    required String query,
    bool includeOver18 = false,
    String? after, // For pagination
    int? limit,
  });

  // Optional: Add methods for fetching 'more' comments if needed later
  // Future<List<RedditComment>> getMoreComments({ ... });
}
