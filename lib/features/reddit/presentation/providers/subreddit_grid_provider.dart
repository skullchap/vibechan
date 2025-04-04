import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vibechan/core/di/injection.dart';
import 'package:vibechan/features/reddit/domain/models/subreddit_info.dart';
import 'package:vibechan/features/reddit/domain/repositories/reddit_repository.dart';

part 'subreddit_grid_provider.g.dart';

// List of default subreddits to display on the grid
const List<String> _defaultSubreddits = [
  'flutterdev',
  'dartlang',
  'programming',
  'technology',
  'worldnews',
  'science',
  'androiddev',
  'iosprogramming',
  'gamedev',
  'linux',
  'opensource',
  'netsec',
  // Add more or adjust as needed
];

// Provider to fetch info for the default subreddit grid
// KeepAlive might be good here as this data is fairly static
@Riverpod(keepAlive: true)
Future<List<SubredditInfo>> subredditGrid(SubredditGridRef ref) async {
  final repository = getIt<RedditRepository>();

  // Fetch info for all default subreddits concurrently
  final futures = _defaultSubreddits.map(
    (subredditName) => repository.getSubredditInfo(subreddit: subredditName)
    // Add error handling per future to prevent Future.wait from failing completely
    .catchError((e) {
      print("Failed to fetch info for r/$subredditName: $e");
      return null; // Return null on error for this specific subreddit
    }),
  );

  // Wait for all fetches to complete
  final results = await Future.wait(futures);

  // Filter out any nulls that resulted from errors
  return results.whereType<SubredditInfo>().toList();
}
