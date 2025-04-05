import 'package:flutter/material.dart';
import 'package:vibechan/app/app_routes.dart';
import 'package:vibechan/features/hackernews/presentation/providers/hackernews_item_detail_provider.dart'
    hide hackerNewsItemRefresherProvider;
import 'package:vibechan/features/hackernews/presentation/providers/hackernews_stories_provider.dart';
import 'package:vibechan/features/lobsters/presentation/providers/lobsters_stories_provider.dart';
import 'package:vibechan/features/lobsters/presentation/providers/lobsters_story_detail_provider.dart';
import 'package:vibechan/features/reddit/presentation/providers/reddit_sort_provider.dart';
import 'package:vibechan/features/reddit/presentation/providers/subreddit_posts_provider.dart';
import 'package:vibechan/features/reddit/presentation/providers/post_detail_provider.dart';
import 'package:vibechan/shared/enums/news_source.dart';
import 'package:vibechan/features/hackernews/presentation/providers/hackernews_item_refresher_provider.dart';
import 'package:vibechan/features/lobsters/presentation/providers/lobsters_story_refresher_provider.dart';

/// A generic provider factory that gets the correct providers based on source
class NewsProviderFactory {
  /// Get a provider for list of news items based on source and sort type
  static dynamic getNewsListProvider(
    NewsSource source,
    dynamic sortType, [
    String? contextId,
  ]) {
    switch (source) {
      case NewsSource.hackernews:
        return hackerNewsStoriesProvider(sortType as HackerNewsSortType);
      case NewsSource.lobsters:
        return lobstersStoriesProvider(sortType as LobstersSortType);
      case NewsSource.reddit:
        if (contextId == null) {
          throw ArgumentError('contextId (subreddit) is required for Reddit');
        }
        return subredditPostsProvider(contextId);
    }
  }

  /// Get a provider for news item details based on source and id
  static dynamic getNewsItemDetailProvider(
    NewsSource source,
    String itemId, [
    Map<String, String>? params,
  ]) {
    switch (source) {
      case NewsSource.hackernews:
        return hackerNewsItemDetailProvider(int.parse(itemId));
      case NewsSource.lobsters:
        return lobstersStoryDetailProvider(itemId);
      case NewsSource.reddit:
        final subreddit = params?['subredditName'];
        if (subreddit == null) {
          throw ArgumentError(
            'subredditName is required for Reddit post details',
          );
        }
        return postDetailProvider(
          PostDetailParams(subreddit: subreddit, postId: itemId),
        );
    }
  }

  /// Get a provider for refreshing news item details
  static dynamic getNewsItemRefresherProvider(NewsSource source) {
    switch (source) {
      case NewsSource.hackernews:
        return hackerNewsItemRefresherProvider;
      case NewsSource.lobsters:
        return lobstersStoryRefresherProvider;
      case NewsSource.reddit:
        // Currently Reddit doesn't have a dedicated refresher provider
        // Can be implemented later with proper refresh functionality
        return null;
    }
  }

  /// Get a provider for current sort type based on source
  static dynamic getCurrentSortTypeProvider(NewsSource source) {
    switch (source) {
      case NewsSource.hackernews:
        return currentHackerNewsSortTypeProvider;
      case NewsSource.lobsters:
        return currentLobstersSortTypeProvider;
      case NewsSource.reddit:
        return currentRedditSortTypeProvider;
    }
  }

  /// Get the initial sort type for a source
  static dynamic getDefaultSortType(NewsSource source) {
    switch (source) {
      case NewsSource.hackernews:
        return HackerNewsSortType.top;
      case NewsSource.lobsters:
        return LobstersSortType.hottest;
      case NewsSource.reddit:
        return RedditSortType.hot;
    }
  }

  /// Get route name for item details based on source
  static String getDetailRouteName(NewsSource source) {
    switch (source) {
      case NewsSource.hackernews:
        return AppRoute.hackernewsItem.name;
      case NewsSource.lobsters:
        return AppRoute.lobstersStory.name;
      case NewsSource.reddit:
        return AppRoute.postDetail.name;
    }
  }
}

/// Convenience extension for NewsSource
extension NewsSourceHelper on NewsSource {
  String get displayName {
    switch (this) {
      case NewsSource.hackernews:
        return 'Hacker News';
      case NewsSource.lobsters:
        return 'Lobsters';
      case NewsSource.reddit:
        return 'Reddit';
    }
  }

  IconData get icon {
    switch (this) {
      case NewsSource.hackernews:
        return Icons.science_outlined;
      case NewsSource.lobsters:
        return Icons.catching_pokemon;
      case NewsSource.reddit:
        return Icons.forum_outlined;
    }
  }
}
