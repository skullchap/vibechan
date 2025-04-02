import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibechan/features/hackernews/presentation/providers/hackernews_stories_provider.dart';
import 'package:vibechan/shared/widgets/generic_list_card.dart';
import 'package:vibechan/shared/providers/tab_manager_provider.dart'; // For potentially opening links
import 'package:vibechan/shared/providers/search_provider.dart'; // Import search provider
import 'package:url_launcher/url_launcher.dart'; // To launch URLs
import 'package:vibechan/core/domain/models/generic_list_item.dart';
import '../../data/models/hacker_news_item.dart'; // Import the item model

class HackerNewsScreen extends ConsumerWidget {
  const HackerNewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Read the sort type from the public provider
    final currentSortType = ref.watch(currentHackerNewsSortTypeProvider);
    // Watch the main data provider, passing the current sort type
    final storiesAsync = ref.watch(hackerNewsStoriesProvider(currentSortType));

    // Get search state
    final isSearchActive = ref.watch(searchVisibleProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    // Listen to search query changes to trigger UI updates
    ref.listen(searchQueryProvider, (previous, next) {
      if (previous != next) {
        // Force rebuild when search query changes
        ref.invalidate(currentHackerNewsSortTypeProvider);
      }
    });

    return storiesAsync.when(
      data: (stories) {
        // Apply search filtering
        final filteredStories =
            isSearchActive && searchQuery.isNotEmpty
                ? _filterStoriesBySearch(stories, searchQuery)
                : stories;

        if (stories.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('No stories found.'),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                  onPressed: () {
                    // Invalidate the provider to trigger a refetch
                    ref.invalidate(hackerNewsStoriesProvider(currentSortType));
                  },
                ),
              ],
            ),
          );
        }

        // Show "no results" message when search is active but no matches found
        if (isSearchActive &&
            searchQuery.isNotEmpty &&
            filteredStories.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.search_off, size: 64),
                const SizedBox(height: 16),
                Text(
                  'No stories match "${searchQuery}"',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed:
                      () => ref.read(searchQueryProvider.notifier).state = '',
                  child: const Text('Clear Search'),
                ),
              ],
            ),
          );
        }

        // Add RefreshIndicator here for pull-to-refresh
        return RefreshIndicator(
          onRefresh: () async {
            // Invalidate the provider to trigger a refetch with the current sort type
            ref.invalidate(hackerNewsStoriesProvider(currentSortType));
            // Wait for the provider to rebuild
            await ref.read(hackerNewsStoriesProvider(currentSortType).future);
          },
          child: ListView.builder(
            // Add a key based on sort type to force rebuild on sort change if needed
            key: ValueKey(currentSortType),
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
                  onTap: () {
                    // Get the tab manager
                    final tabNotifier = ref.read(tabManagerProvider.notifier);
                    // Navigate, replacing the current tab's content
                    tabNotifier.navigateToOrReplaceActiveTab(
                      title: item.title ?? 'HN Item', // Use item title
                      initialRouteName: 'hackernews_item', // New route name
                      pathParameters: {'itemId': item.id}, // Pass item ID
                      icon: Icons.article, // Suggest an icon
                    );
                  },
                  // Pass search terms for highlighting
                  searchQuery:
                      isSearchActive && searchQuery.isNotEmpty
                          ? searchQuery
                          : null,
                  highlightColor: Theme.of(
                    context,
                  ).colorScheme.primaryContainer.withOpacity(0.5),
                ),
              );
            },
          ),
        );
      },
      loading:
          () => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  'Loading stories...',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'This may take a moment',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
      error:
          (error, stack) => Center(
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
                    onPressed: () {
                      // Invalidate the provider to trigger a refetch
                      ref.invalidate(
                        hackerNewsStoriesProvider(currentSortType),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      // Try a different sort type as a fallback
                      final newSortType =
                          currentSortType == HackerNewsSortType.top
                              ? HackerNewsSortType.best
                              : HackerNewsSortType.top;
                      ref
                          .read(currentHackerNewsSortTypeProvider.notifier)
                          .state = newSortType;
                    },
                    child: const Text('Try different stories'),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  // Helper method to filter stories based on search query
  List<GenericListItem> _filterStoriesBySearch(
    List<GenericListItem> stories,
    String query,
  ) {
    if (query.isEmpty) return stories;

    final searchTerms = query.toLowerCase();
    return stories.where((item) {
      final title = item.title?.toLowerCase() ?? '';
      final body = item.body?.toLowerCase() ?? '';
      final metadata = item.metadata;

      return title.contains(searchTerms) ||
          body.contains(searchTerms) ||
          (metadata['by'] as String?)?.toLowerCase()?.contains(searchTerms) ==
              true;
    }).toList();
  }
}
