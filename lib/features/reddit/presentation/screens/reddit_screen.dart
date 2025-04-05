import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibechan/shared/enums/news_source.dart';
import 'package:vibechan/shared/providers/news_provider.dart';
import 'package:vibechan/shared/widgets/news/generic_news_list_screen.dart';

/// A generic Reddit listing screen for a specific subreddit
class RedditScreen extends ConsumerWidget {
  final String subredditName;

  const RedditScreen({super.key, required this.subredditName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _SubredditNewsScreen(
      source: NewsSource.reddit,
      contextId: subredditName,
    );
  }
}

/// Extension of GenericNewsScreen that supports context ID for subreddits
class _SubredditNewsScreen extends ConsumerWidget {
  final NewsSource source;
  final String contextId;

  const _SubredditNewsScreen({required this.source, required this.contextId});

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
      contextId, // Pass the subreddit name
    );

    // Watch the stories data
    final storiesAsync = ref.watch(storiesProvider);

    // Get the detail route name for this source
    final detailRouteName = NewsProviderFactory.getDetailRouteName(source);

    return GenericNewsListScreen(
      source: source,
      title: "r/$contextId",
      itemsAsync: storiesAsync,
      detailRouteName: detailRouteName,
      listContextId: contextId,
      onRefresh: () {
        // Invalidate the provider to trigger a refetch
        ref.invalidate(storiesProvider);
      },
      onLoadMore:
          storiesAsync.valueOrNull != null
              ? () {
                // Access the provider notifier to load more
                final notifier = ref.read(storiesProvider.notifier);
                notifier.loadMore();
              }
              : null,
      sortTypeProvider: sortTypeProvider,
      itemIcon: source.icon,
    );
  }
}
