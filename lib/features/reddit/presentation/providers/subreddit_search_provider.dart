import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vibechan/core/di/injection.dart';
import 'package:vibechan/features/reddit/domain/models/subreddit_info.dart';
import 'package:vibechan/features/reddit/domain/repositories/reddit_repository.dart';

part 'subreddit_search_provider.g.dart';

// Simple provider that takes a query string
// AutoDispose is likely suitable here as search results aren't usually needed long-term
@riverpod
Future<List<SubredditInfo>> subredditSearch(
  SubredditSearchRef ref,
  String query,
) async {
  // Don't search for empty strings
  if (query.trim().isEmpty) {
    return [];
  }

  final repository = getIt<RedditRepository>();
  final results = await repository.searchSubreddits(
    query: query,
    // Optionally add includeOver18, pagination later
  );
  return results;
}
