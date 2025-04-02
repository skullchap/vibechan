import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibechan/features/lobsters/presentation/providers/lobsters_stories_provider.dart';
import 'package:vibechan/shared/widgets/generic_list_card.dart';
import 'package:vibechan/shared/providers/tab_manager_provider.dart';
import 'package:vibechan/core/domain/models/generic_list_item.dart';
import 'package:vibechan/shared/providers/search_provider.dart';

class LobstersScreen extends ConsumerWidget {
  const LobstersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSortType = ref.watch(currentLobstersSortTypeProvider);
    final storiesAsync = ref.watch(lobstersStoriesProvider(currentSortType));

    // Get search state
    final isSearchActive = ref.watch(searchVisibleProvider);
    final searchQuery = ref.watch(searchQueryProvider);

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
                    ref.invalidate(lobstersStoriesProvider(currentSortType));
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

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(lobstersStoriesProvider(currentSortType));
            await ref.read(lobstersStoriesProvider(currentSortType).future);
          },
          child: ListView.builder(
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
                    if (index < filteredStories.length) {
                      final tappedItem = filteredStories[index];
                      final tabNotifier = ref.read(tabManagerProvider.notifier);

                      final title = tappedItem.title ?? 'Lobsters Story';
                      final storyId =
                          tappedItem.metadata['short_id'] as String?;

                      if (storyId != null) {
                        tabNotifier.navigateToOrReplaceActiveTab(
                          title: title,
                          initialRouteName: 'lobsters_story',
                          pathParameters: {'storyId': storyId},
                          icon: Icons.article,
                        );
                      } else {
                        print(
                          'Error: Lobsters short_id not found in metadata for item ${tappedItem.id}',
                        );
                      }
                    }
                  },
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
      loading: () => const Center(child: CircularProgressIndicator()),
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
                    'Error loading Lobsters stories',
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
                      ref.invalidate(lobstersStoriesProvider(currentSortType));
                    },
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
          (metadata['submitter_user']?.toString().toLowerCase().contains(
                searchTerms,
              ) ==
              true);
    }).toList();
  }
}
