import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibechan/features/lobsters/presentation/providers/lobsters_stories_provider.dart';
import 'package:vibechan/shared/widgets/generic_list_card.dart';
import 'package:vibechan/shared/providers/tab_manager_provider.dart';
import 'package:vibechan/core/domain/models/generic_list_item.dart';

class LobstersScreen extends ConsumerWidget {
  const LobstersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSortType = ref.watch(currentLobstersSortTypeProvider);
    final storiesAsync = ref.watch(lobstersStoriesProvider(currentSortType));

    return storiesAsync.when(
      data: (stories) {
        if (stories.isEmpty) {
          return const Center(child: Text('No stories found.'));
        }
        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(lobstersStoriesProvider(currentSortType));
            await ref.read(lobstersStoriesProvider(currentSortType).future);
          },
          child: ListView.builder(
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
                    if (index < stories.length) {
                      final tappedItem = stories[index];
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
              child: Text('Error loading Lobsters stories: $error\n$stack'),
            ),
          ),
    );
  }
}
