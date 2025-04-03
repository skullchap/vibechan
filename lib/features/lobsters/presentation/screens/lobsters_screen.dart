import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibechan/features/lobsters/presentation/providers/lobsters_stories_provider.dart';
import 'package:vibechan/shared/providers/search_provider.dart';
import 'package:vibechan/features/lobsters/presentation/utils/lobsters_filtering.dart';
import 'package:vibechan/features/lobsters/presentation/widgets/lobsters_list_view.dart';
import 'package:vibechan/core/presentation/widgets/common/loading_indicator.dart';
import 'package:vibechan/core/presentation/widgets/common/error_state.dart';

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
        // Apply search filtering using the utility function
        final filteredStories =
            isSearchActive && searchQuery.isNotEmpty
                ? filterLobstersStoriesBySearch(stories, searchQuery)
                : stories;

        // Use the dedicated list view widget
        return LobstersListView(
          stories: filteredStories,
          searchQuery: searchQuery,
        );
      },
      // Use common loading and error widgets
      loading: () => const LoadingIndicator(),
      error:
          (error, stack) => ErrorState(
            message: 'Error loading Lobsters stories: ${error.toString()}',
            onRetry:
                () => ref.invalidate(lobstersStoriesProvider(currentSortType)),
          ),
    );
  }
}
