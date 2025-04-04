import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:vibechan/features/reddit/presentation/providers/subreddit_grid_provider.dart';
import 'package:vibechan/features/reddit/presentation/widgets/subreddit_grid_tile.dart';

class SubredditGridScreen extends ConsumerWidget {
  const SubredditGridScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gridState = ref.watch(subredditGridProvider);

    return gridState.when(
      data: (subreddits) {
        if (subreddits.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('No default subreddits found.'),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => ref.refresh(subredditGridProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        // Using MasonryGridView for potentially varied content heights
        return RefreshIndicator(
          onRefresh: () => ref.refresh(subredditGridProvider.future),
          child: MasonryGridView.count(
            padding: const EdgeInsets.all(8.0),
            crossAxisCount: 2, // Adjust cross axis count as needed
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
            itemCount: subreddits.length,
            itemBuilder: (context, index) {
              final subreddit = subreddits[index];
              return SubredditGridTile(subreddit: subreddit);
            },
          ),
        );
      },
      loading:
          () => const Center(
            child: CircularProgressIndicator(),
          ), // USE STANDARD LOADER
      error:
          (error, stackTrace) => Center(
            // USE SIMPLE TEXT FOR ERROR
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error loading subreddits:\n${error.toString()}'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => ref.refresh(subredditGridProvider),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
