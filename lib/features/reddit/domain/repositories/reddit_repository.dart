import '../models/models.dart';

abstract class RedditRepository {
  Future<List<RedditPost>> getSubredditPosts({
    required String subreddit,
    String? sort,
    String? timeFilter,
    String? after,
    int? limit,
  });

  Future<SubredditInfo> getSubredditInfo({required String subreddit});

  Future<(RedditPost, List<RedditComment>)> getPostAndComments({
    required String subreddit,
    required String postId,
    String? commentId,
    int? depth,
    String? sort,
  });

  Future<List<SubredditInfo>> searchSubreddits({
    required String query,
    bool includeOver18 = false,
    String? after,
    int? limit,
  });
}
