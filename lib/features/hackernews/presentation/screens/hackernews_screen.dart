import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibechan/features/hackernews/presentation/providers/hackernews_stories_provider.dart';
import 'package:vibechan/shared/widgets/generic_list_card.dart';
import 'package:vibechan/shared/providers/tab_manager_provider.dart'; // For potentially opening links
import 'package:url_launcher/url_launcher.dart'; // To launch URLs
import '../../data/models/hacker_news_item.dart'; // Import the item model

class HackerNewsScreen extends ConsumerWidget {
  const HackerNewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Read the sort type from the public provider
    final currentSortType = ref.watch(currentHackerNewsSortTypeProvider);
    // Watch the main data provider, passing the current sort type
    final storiesAsync = ref.watch(hackerNewsStoriesProvider(currentSortType));

    return storiesAsync.when(
      data: (stories) {
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
            itemCount: stories.length,
            itemBuilder: (context, index) {
              final item = stories[index];
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
                      pathParameters: {
                        'itemId': item.id.toString(),
                      }, // Pass item ID
                      icon: Icons.article, // Suggest an icon
                    );
                  },
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
}
