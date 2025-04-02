import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibechan/features/hackernews/presentation/providers/hackernews_top_stories_provider.dart';
import 'package:vibechan/shared/widgets/generic_list_card.dart';
import 'package:vibechan/shared/providers/tab_manager_provider.dart'; // For potentially opening links
import 'package:url_launcher/url_launcher.dart'; // To launch URLs

class HackerNewsScreen extends ConsumerWidget {
  const HackerNewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topStoriesAsync = ref.watch(hackerNewsTopStoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hacker News Top Stories'),
        // Potentially add actions like refresh
      ),
      body: topStoriesAsync.when(
        data: (stories) {
          if (stories.isEmpty) {
            return const Center(child: Text('No stories found.'));
          }
          return ListView.builder(
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
                    // Handle tap - maybe open in browser or internal view?
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
                    // Alternatively, navigate to a detail view if implemented
                    // ref.read(tabManagerProvider.notifier).navigateToOrReplaceActiveTab(...);
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stack) => Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Error loading stories: $error'),
              ),
            ),
      ),
    );
  }
}
