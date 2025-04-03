import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibechan/core/domain/models/generic_list_item.dart';
import 'package:vibechan/features/lobsters/presentation/providers/lobsters_stories_provider.dart';
import 'package:vibechan/shared/providers/search_provider.dart';
import 'package:vibechan/shared/providers/tab_manager_provider.dart';
import 'package:vibechan/core/presentation/widgets/common/empty_state.dart';
import 'package:vibechan/shared/widgets/generic_list_card.dart';

class LobstersListView extends ConsumerWidget {
  final List<GenericListItem> stories;
  final String searchQuery;

  const LobstersListView({
    super.key,
    required this.stories,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSortType = ref.watch(currentLobstersSortTypeProvider);
    final isSearchActive = ref.watch(searchVisibleProvider);

    if (isSearchActive && searchQuery.isNotEmpty && stories.isEmpty) {
      return EmptyState(
        icon: Icons.search_off,
        title: 'No stories match "$searchQuery"',
      );
    }

    if (stories.isEmpty) {
      return EmptyState(icon: Icons.inbox_outlined, title: 'No stories found');
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
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: GenericListCard(
              item: item,
              onTap: () {
                final tappedItem = stories[index];
                final tabNotifier = ref.read(tabManagerProvider.notifier);
                final title = tappedItem.title ?? 'Lobsters Story';
                final storyId = tappedItem.metadata['short_id'] as String?;

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
                  // Optionally show a snackbar or dialog to the user
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
}
