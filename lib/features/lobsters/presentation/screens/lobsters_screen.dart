import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibechan/features/lobsters/presentation/providers/lobsters_stories_provider.dart';
import 'package:vibechan/shared/widgets/generic_list_card.dart';
import 'package:url_launcher/url_launcher.dart';

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
                    final urlString = item.metadata['url'] as String?;
                    if (urlString != null) {
                      final uri = Uri.tryParse(urlString);
                      if (uri != null) {
                        canLaunchUrl(uri).then((can) {
                          if (can)
                            launchUrl(
                              uri,
                              mode: LaunchMode.externalApplication,
                            );
                        });
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
              child: Text('Error loading Lobsters stories: $error'),
            ),
          ),
    );
  }
}
