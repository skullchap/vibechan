import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibechan/app/app_routes.dart';
import 'package:vibechan/features/hackernews/presentation/providers/hackernews_item_detail_provider.dart'
    hide hackerNewsItemRefresherProvider;
import 'package:vibechan/features/hackernews/presentation/providers/hackernews_stories_provider.dart';
import 'package:vibechan/features/lobsters/presentation/providers/lobsters_stories_provider.dart';
import 'package:vibechan/features/lobsters/presentation/providers/lobsters_story_detail_provider.dart';
import 'package:vibechan/shared/enums/news_source.dart';
import 'package:vibechan/features/hackernews/presentation/providers/hackernews_item_refresher_provider.dart';
import 'package:vibechan/features/lobsters/presentation/providers/lobsters_story_refresher_provider.dart';

/// A generic provider factory that gets the correct providers based on source
class NewsProviderFactory {
  /// Get a provider for list of news items based on source and sort type
  static dynamic getNewsListProvider(NewsSource source, dynamic sortType) {
    switch (source) {
      case NewsSource.hackernews:
        return hackerNewsStoriesProvider(sortType as HackerNewsSortType);
      case NewsSource.lobsters:
        return lobstersStoriesProvider(sortType as LobstersSortType);
      case NewsSource.reddit:
        // Will be implemented when Reddit support is added
        throw UnimplementedError('Reddit provider not yet implemented');
    }
  }

  /// Get a provider for news item details based on source and id
  static dynamic getNewsItemDetailProvider(NewsSource source, String itemId) {
    switch (source) {
      case NewsSource.hackernews:
        return hackerNewsItemDetailProvider(int.parse(itemId));
      case NewsSource.lobsters:
        return lobstersStoryDetailProvider(itemId);
      case NewsSource.reddit:
        // Will be implemented when Reddit support is added
        throw UnimplementedError('Reddit provider not yet implemented');
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
        // Will be implemented when Reddit support is added
        throw UnimplementedError('Reddit provider not yet implemented');
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
        // Will be implemented when Reddit support is added
        throw UnimplementedError('Reddit provider not yet implemented');
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
        // Will use hot as default for Reddit when implemented
        return null;
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
