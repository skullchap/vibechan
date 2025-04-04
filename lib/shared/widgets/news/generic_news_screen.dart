import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibechan/shared/enums/news_source.dart';
import 'package:vibechan/shared/providers/news_provider.dart';
import 'package:vibechan/shared/widgets/news/generic_news_list_screen.dart';
import 'package:vibechan/shared/widgets/news/generic_news_detail_screen.dart';

/// A wrapper for the generic news list screen that handles provider setup
class GenericNewsScreen extends ConsumerWidget {
  final NewsSource source;

  const GenericNewsScreen({super.key, required this.source});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the sort type provider for this source
    final sortTypeProvider = NewsProviderFactory.getCurrentSortTypeProvider(
      source,
    );

    // Watch the current sort type
    final currentSortType = ref.watch(sortTypeProvider);

    // Get the stories provider for this source and sort type
    final storiesProvider = NewsProviderFactory.getNewsListProvider(
      source,
      currentSortType,
    );

    // Watch the stories data
    final storiesAsync = ref.watch(storiesProvider);

    // Get the detail route name for this source
    final detailRouteName = NewsProviderFactory.getDetailRouteName(source);

    return GenericNewsListScreen(
      source: source,
      title: source.displayName,
      itemsAsync: storiesAsync,
      detailRouteName: detailRouteName,
      onRefresh: () {
        // Invalidate the provider to trigger a refetch
        ref.invalidate(storiesProvider);
      },
      sortTypeProvider: sortTypeProvider,
      itemIcon: source.icon,
    );
  }
}

/// A wrapper for creating news detail screens
class GenericNewsItemScreen extends ConsumerWidget {
  final NewsSource source;
  final String itemId;

  const GenericNewsItemScreen({
    super.key,
    required this.source,
    required this.itemId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the item detail provider
    final itemDetailProvider = NewsProviderFactory.getNewsItemDetailProvider(
      source,
      itemId,
    );

    // Get the refresher provider
    final refresherProvider = NewsProviderFactory.getNewsItemRefresherProvider(
      source,
    );

    // Watch the item detail
    final itemDetailAsync = ref.watch(itemDetailProvider);

    // Watch the refreshing state
    final isRefreshing = ref.watch(refresherProvider);

    // Get a refresher function
    Future<void> refreshItem() async {
      switch (source) {
        case NewsSource.hackernews:
          await ref.read(refresherProvider.notifier).refresh(int.parse(itemId));
          break;
        case NewsSource.lobsters:
          await ref.read(refresherProvider.notifier).refresh(itemId);
          break;
        case NewsSource.reddit:
          // Will be implemented when Reddit support is added
          break;
      }
    }

    return GenericNewsDetailScreen(
      source: source,
      itemDetailAsync: itemDetailAsync,
      onRefresh: refreshItem,
      isRefreshing: isRefreshing,
    );
  }
}
