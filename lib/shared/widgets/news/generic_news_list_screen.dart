import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibechan/features/fourchan/domain/models/generic_list_item.dart';
import 'package:vibechan/shared/enums/news_source.dart';
import 'package:vibechan/shared/providers/search_provider.dart';
import 'package:vibechan/shared/providers/tab_manager_provider.dart';
import 'package:vibechan/shared/widgets/generic_list_card.dart';

/// A generic news list screen that works with different news sources
class GenericNewsListScreen extends ConsumerWidget {
  final NewsSource source;
  final String title;
  final AsyncValue<List<GenericListItem>> itemsAsync;
  final void Function()? onRefresh;
  final String detailRouteName;
  final String? sortTypeParameterName;
  final StateProvider<dynamic>? sortTypeProvider;
  final IconData itemIcon;

  const GenericNewsListScreen({
    super.key,
    required this.source,
    required this.title,
    required this.itemsAsync,
    required this.detailRouteName,
    this.onRefresh,
    this.sortTypeParameterName,
    this.sortTypeProvider,
    this.itemIcon = Icons.article,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get search state
    final isSearchActive = ref.watch(searchVisibleProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    // Get current sort type from provider if available
    final currentSortType =
        sortTypeProvider != null ? ref.watch(sortTypeProvider!) : null;

    return itemsAsync.when(
      data: (items) {
        // Apply search filtering
        final filteredItems =
            isSearchActive && searchQuery.isNotEmpty
                ? _filterItemsBySearch(items, searchQuery)
                : items;

        if (items.isEmpty) {
          return _buildEmptyState(context, ref);
        }

        // Show "no results" message when search is active but no matches found
        if (isSearchActive && searchQuery.isNotEmpty && filteredItems.isEmpty) {
          return _buildNoSearchResultsState(context, ref, searchQuery);
        }

        // Display items in a list
        return _buildItemsList(
          context,
          ref,
          filteredItems,
          isSearchActive,
          searchQuery,
        );
      },
      loading: () => _buildLoadingState(context),
      error: (error, stack) => _buildErrorState(context, ref, error),
    );
  }

  // Helper method to filter items based on search query
  List<GenericListItem> _filterItemsBySearch(
    List<GenericListItem> items,
    String query,
  ) {
    if (query.isEmpty) return items;

    final searchTerms = query.toLowerCase();
    return items.where((item) {
      final title = item.title?.toLowerCase() ?? '';
      final body = item.body?.toLowerCase() ?? '';
      final metadata = item.metadata;

      // Check common fields
      bool matchesCommonFields =
          title.contains(searchTerms) || body.contains(searchTerms);

      // Check source-specific fields
      bool matchesSourceSpecific = false;
      switch (source) {
        case NewsSource.hackernews:
          matchesSourceSpecific =
              (metadata['by'] as String?)?.toLowerCase()?.contains(
                searchTerms,
              ) ==
              true;
          break;
        case NewsSource.lobsters:
          matchesSourceSpecific =
              (metadata['submitter_user'] as String?)?.toLowerCase()?.contains(
                searchTerms,
              ) ==
              true;
          break;
        case NewsSource.reddit:
          // Add Reddit-specific search when implemented
          matchesSourceSpecific =
              (metadata['author'] as String?)?.toLowerCase()?.contains(
                searchTerms,
              ) ==
              true;
          break;
      }

      return matchesCommonFields || matchesSourceSpecific;
    }).toList();
  }

  // Widget builders for different states
  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('No items found.'),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
            onPressed: onRefresh ?? () {},
          ),
        ],
      ),
    );
  }

  Widget _buildNoSearchResultsState(
    BuildContext context,
    WidgetRef ref,
    String searchQuery,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 64),
          const SizedBox(height: 16),
          Text(
            'No items match "$searchQuery"',
            style: Theme.of(context).textTheme.titleMedium,
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

  Widget _buildItemsList(
    BuildContext context,
    WidgetRef ref,
    List<GenericListItem> items,
    bool isSearchActive,
    String searchQuery,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        if (onRefresh != null) {
          onRefresh!();
        }

        // If we have a sort type provider, try to refresh based on it
        if (sortTypeProvider != null && sortTypeParameterName != null) {
          // For now, just call onRefresh again which should handle invalidation
          if (onRefresh != null) {
            onRefresh!();
          }
        }
      },
      child: ListView.builder(
        key:
            sortTypeProvider != null
                ? ValueKey(ref.watch(sortTypeProvider!))
                : null,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: GenericListCard(
              item: item,
              onTap: () {
                if (index < items.length) {
                  final tappedItem = items[index];
                  final tabNotifier = ref.read(tabManagerProvider.notifier);

                  // Get a title for the tab
                  final title = tappedItem.title ?? '${source.name} Item';

                  // Determine the path parameter for navigation based on source
                  String paramName;
                  String paramValue;

                  switch (source) {
                    case NewsSource.hackernews:
                      paramName = 'itemId';
                      paramValue = tappedItem.id;
                      break;
                    case NewsSource.lobsters:
                      paramName = 'storyId';
                      paramValue =
                          tappedItem.metadata['short_id'] as String? ??
                          tappedItem.id;
                      break;
                    case NewsSource.reddit:
                      paramName = 'postId';
                      paramValue = tappedItem.id;
                      break;
                  }

                  tabNotifier.navigateToOrReplaceActiveTab(
                    title: title,
                    initialRouteName: detailRouteName,
                    pathParameters: {paramName: paramValue},
                    icon: itemIcon,
                  );
                }
              },
              searchQuery:
                  isSearchActive && searchQuery.isNotEmpty ? searchQuery : null,
              highlightColor: Theme.of(
                context,
              ).colorScheme.primaryContainer.withOpacity(0.5),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Loading items...',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 4),
          Text(
            'This may take a moment',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              'Error loading ${source.name} items',
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
              onPressed: onRefresh ?? () {},
            ),
          ],
        ),
      ),
    );
  }
}
