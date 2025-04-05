import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibechan/features/fourchan/domain/models/generic_list_item.dart';
import 'package:vibechan/shared/enums/news_source.dart';
import 'package:vibechan/shared/providers/search_provider.dart';
import 'package:vibechan/shared/providers/tab_manager_provider.dart';
import 'package:vibechan/shared/widgets/generic_list_card.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

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
  final String? listContextId;
  final void Function()? onLoadMore;

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
    this.listContextId,
    this.onLoadMore,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSearchActive = ref.watch(searchVisibleProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    // Get current sort type from provider if available - TODO: Implement if needed

    return itemsAsync.when(
      data: (items) {
        final filteredItems =
            isSearchActive && searchQuery.isNotEmpty
                ? _filterItemsBySearch(items, searchQuery)
                : items;

        if (items.isEmpty) {
          return _buildEmptyState(context, ref);
        }

        if (isSearchActive && searchQuery.isNotEmpty && filteredItems.isEmpty) {
          return _buildNoSearchResultsState(context, ref, searchQuery);
        }

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

      bool matchesCommonFields =
          title.contains(searchTerms) || body.contains(searchTerms);

      bool matchesSourceSpecific = false;
      switch (source) {
        case NewsSource.hackernews:
          matchesSourceSpecific =
              (metadata['by'] as String?)?.toLowerCase().contains(
                searchTerms,
              ) ==
              true;
          break;
        case NewsSource.lobsters:
          matchesSourceSpecific =
              (metadata['submitter_user'] as String?)?.toLowerCase().contains(
                searchTerms,
              ) ==
              true;
          break;
        case NewsSource.reddit:
          // TODO: Add more Reddit-specific search fields if needed
          matchesSourceSpecific =
              (metadata['author'] as String?)?.toLowerCase().contains(
                searchTerms,
              ) ==
              true;
          break;
      }

      return matchesCommonFields || matchesSourceSpecific;
    }).toList();
  }

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
        onRefresh?.call();
      },
      child: ListView.builder(
        key:
            sortTypeProvider != null
                ? ValueKey(ref.watch(sortTypeProvider!))
                : null,
        itemCount: items.length + (onLoadMore != null ? 1 : 0),
        itemBuilder: (context, index) {
          if (onLoadMore != null && index == items.length) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              onLoadMore!();
            });

            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final item = items[index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: GenericListCard(
              item: item,
              onTap: () {
                if (index < items.length) {
                  final tappedItem = items[index];
                  final tabNotifier = ref.read(tabManagerProvider.notifier);

                  final title = tappedItem.title ?? '${source.name} Item';
                  Map<String, String> pathParameters;

                  switch (source) {
                    case NewsSource.hackernews:
                      pathParameters = {'itemId': tappedItem.id};
                      break;
                    case NewsSource.lobsters:
                      final lobstersId =
                          tappedItem.metadata['short_id'] as String? ??
                          tappedItem.id;
                      pathParameters = {'storyId': lobstersId};
                      break;
                    case NewsSource.reddit:
                      pathParameters = {
                        'subredditName': listContextId ?? 'unknown',
                        'postId': tappedItem.id,
                      };
                      break;
                  }

                  // --- Add Logging Here ---
                  final logger = GetIt.instance<Logger>(
                    instanceName: "AppLogger",
                  );
                  logger.d("--- GenericNewsListScreen onTap ---");
                  logger.d("Source: $source");
                  logger.d("Detail Route Name Param: $detailRouteName");
                  logger.d("List Context ID (Subreddit): $listContextId");
                  logger.d("Tapped Item ID (Post ID): ${tappedItem.id}");
                  logger.d("Constructed Path Params: $pathParameters");
                  // --- End Logging ---

                  tabNotifier.navigateToOrReplaceActiveTab(
                    title: title,
                    initialRouteName: detailRouteName,
                    pathParameters: pathParameters,
                    icon: itemIcon,
                  );
                }
              },
              searchQuery:
                  isSearchActive && searchQuery.isNotEmpty ? searchQuery : null,
              highlightColor: Theme.of(
                context,
              ).colorScheme.primaryContainer.withAlpha((0.7 * 255).toInt()),
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
