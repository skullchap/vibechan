import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibechan/core/domain/models/generic_list_item.dart';
import 'package:vibechan/core/presentation/widgets/common/empty_state.dart';
import 'package:vibechan/core/presentation/widgets/common/loading_indicator.dart';
import 'package:vibechan/shared/providers/search_provider.dart';
import 'package:vibechan/shared/providers/tab_manager_provider.dart';
import 'package:vibechan/shared/widgets/generic_list_card.dart';

import '../../providers/hackernews_stories_provider.dart';
import '../../utils/hackernews_filtering.dart';

/// Displays a list of HackerNews stories with loading, error, empty, and search states.
class HackerNewsListView extends ConsumerWidget {
  final HackerNewsSortType sortType;

  const HackerNewsListView({super.key, required this.sortType});

  Future<void> _refresh(WidgetRef ref) async {
    ref.invalidate(hackerNewsStoriesProvider(sortType));
    await ref.read(hackerNewsStoriesProvider(sortType).future);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storiesAsync = ref.watch(hackerNewsStoriesProvider(sortType));
    final isSearchActive = ref.watch(isSearchActiveProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    return storiesAsync.when(
      data: (stories) {
        final filteredStories = filterHackerNewsStories(
          stories,
          isSearchActive ? searchQuery : '',
        );

        if (stories.isEmpty) {
          // Original list is empty
          return _buildEmptyInitialState(context, ref);
        }

        if (isSearchActive &&
            searchQuery.isNotEmpty &&
            filteredStories.isEmpty) {
          // Search yielded no results
          return _buildSearchEmptyState(context, ref, searchQuery);
        }

        // Display the list
        return RefreshIndicator(
          onRefresh: () => _refresh(ref),
          child: ListView.builder(
            key: ValueKey(sortType), // Rebuild list on sort change
            itemCount: filteredStories.length,
            itemBuilder: (context, index) {
              final item = filteredStories[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                child: GenericListCard(
                  item: item,
                  onTap: () => _navigateToItem(ref, item),
                  searchQuery: isSearchActive ? searchQuery : null,
                  highlightColor: Theme.of(
                    context,
                  ).colorScheme.primaryContainer.withOpacity(0.5),
                ),
              );
            },
          ),
        );
      },
      loading: () => const LoadingIndicator(),
      error: (error, stack) => _buildErrorState(context, ref, error, sortType),
    );
  }

  void _navigateToItem(WidgetRef ref, GenericListItem item) {
    final tabNotifier = ref.read(tabManagerProvider.notifier);
    tabNotifier.navigateToOrReplaceActiveTab(
      title: item.title ?? 'HN Item',
      initialRouteName: 'hackernews_item',
      pathParameters: {'itemId': item.id},
      icon: Icons.article,
    );
  }

  Widget _buildEmptyInitialState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const EmptyState(icon: Icons.newspaper, title: 'No stories found.'),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
            onPressed: () => _refresh(ref),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchEmptyState(
    BuildContext context,
    WidgetRef ref,
    String query,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          EmptyState(
            icon: Icons.search_off,
            title: 'No stories match "${query}"',
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => ref.read(searchQueryProvider.notifier).state = '',
            child: const Text('Clear Search'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    WidgetRef ref,
    Object error,
    HackerNewsSortType currentSortType,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              'Error loading stories',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              onPressed: () => _refresh(ref),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                final newSortType =
                    currentSortType == HackerNewsSortType.top
                        ? HackerNewsSortType.best
                        : HackerNewsSortType.top;
                ref.read(currentHackerNewsSortTypeProvider.notifier).state =
                    newSortType;
              },
              child: const Text('Try different stories'),
            ),
          ],
        ),
      ),
    );
  }
}
