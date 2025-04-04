// lib/features/reddit/data/repositories/reddit_repository_impl.dart
import 'package:injectable/injectable.dart';
import '../../domain/models/models.dart';
import '../../domain/repositories/reddit_repository.dart';
import '../sources/reddit_remote_data_source.dart';

@LazySingleton(as: RedditRepository)
class RedditRepositoryImpl implements RedditRepository {
  final RedditRemoteDataSource _remoteDataSource;

  RedditRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<RedditPost>> getSubredditPosts({
    required String subreddit,
    String? sort,
    String? timeFilter,
    String? after,
    int? limit,
  }) {
    // Basic implementation, could add error handling/mapping here later
    return _remoteDataSource.getSubredditPosts(
      subreddit: subreddit,
      sort: sort,
      timeFilter: timeFilter,
      after: after,
      limit: limit,
    );
  }

  @override
  Future<SubredditInfo> getSubredditInfo({required String subreddit}) {
    return _remoteDataSource.getSubredditInfo(subreddit: subreddit);
  }

  @override
  Future<(RedditPost, List<RedditComment>)> getPostAndComments({
    required String subreddit,
    required String postId,
    String? commentId,
    int? depth,
    String? sort,
  }) {
    return _remoteDataSource.getPostAndComments(
      subreddit: subreddit,
      postId: postId,
      commentId: commentId,
      depth: depth,
      sort: sort,
    );
  }

  @override
  Future<List<SubredditInfo>> searchSubreddits({
    required String query,
    bool includeOver18 = false,
    String? after,
    int? limit,
  }) {
    return _remoteDataSource.searchSubreddits(
      query: query,
      includeOver18: includeOver18,
      after: after,
      limit: limit,
    );
  }
}
