import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vibechan/core/di/injection.dart';
import 'package:vibechan/features/reddit/domain/models/models.dart'; // Using barrel file
import 'package:vibechan/features/reddit/domain/repositories/reddit_repository.dart';

part 'post_detail_provider.g.dart';

// Define a simple class to hold the parameters
// Freezed could be used here too if desired
class PostDetailParams {
  final String subreddit;
  final String postId;

  PostDetailParams({required this.subreddit, required this.postId});

  // Need equality and hashCode for Riverpod family caching
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostDetailParams &&
          runtimeType == other.runtimeType &&
          subreddit == other.subreddit &&
          postId == other.postId;

  @override
  int get hashCode => subreddit.hashCode ^ postId.hashCode;
}

// Family provider to accept subreddit and postId
// KeepAlive can be useful if users frequently navigate back and forth
@Riverpod(keepAlive: true)
Future<(RedditPost, List<RedditComment>)> postDetail(
  PostDetailRef ref,
  PostDetailParams params,
) async {
  final repository = getIt<RedditRepository>();
  // Fetch both post and comments using the repository method
  final result = await repository.getPostAndComments(
    subreddit: params.subreddit,
    postId: params.postId,
    // Add other parameters like sort, depth later if needed
  );
  return result;
}
