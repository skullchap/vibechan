import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vibechan/core/di/injection.dart';
import 'package:vibechan/features/reddit/domain/models/subreddit_info.dart';
import 'package:vibechan/features/reddit/domain/repositories/reddit_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

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
Future<List<SubredditInfo>> subredditGrid(Ref ref) async {
  final repository = getIt<RedditRepository>();

  // Fetch info for all default subreddits concurrently
  final futures = _defaultSubreddits.map(
    (subredditName) => repository.getSubredditInfo(subreddit: subredditName)
    // Add error handling per future to prevent Future.wait from failing completely
    .catchError((e) {
      final logger = GetIt.instance<Logger>(instanceName: "AppLogger");
      logger.e("Failed to fetch info for r/$subredditName", error: e);
      // Return a placeholder SubredditInfo instead of null
      return SubredditInfo(
        id: 'error_$subredditName',
        displayName: subredditName,
        displayNamePrefixed: 'r/$subredditName',
        title: 'Error loading r/$subredditName',
        subscriberCount: 0,
      );
    }),
  );

  // Wait for all fetches to complete
  final results = await Future.wait(futures);

  // Filter out any nulls that resulted from errors
  return results.whereType<SubredditInfo>().toList();
}
