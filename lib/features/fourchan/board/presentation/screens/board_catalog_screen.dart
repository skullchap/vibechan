import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

// Corrected Package Imports
import 'package:vibechan/features/fourchan/presentation/providers/board_providers.dart'; // Assuming this exists
import 'package:vibechan/features/fourchan/presentation/providers/thread_providers.dart'; // Assuming this exists
import 'package:vibechan/shared/providers/tab_manager_provider.dart';
import 'package:vibechan/shared/providers/search_provider.dart';
import 'package:vibechan/features/fourchan/domain/models/board.dart';
import 'package:vibechan/features/fourchan/domain/models/thread.dart';
import 'package:vibechan/core/services/layout_service.dart';
import 'package:vibechan/shared/enums/catalog_view_mode.dart';
import 'package:vibechan/features/fourchan/board/presentation/widgets/catalog/catalog_media_feed.dart';
import 'package:vibechan/shared/widgets/preview_card.dart'; // Use generic card
import 'package:vibechan/features/fourchan/board/domain/adapters/thread_preview_adapter.dart'; // Import adapter
// import '../../../../../shared/models/fourchan/thread.dart'; // Duplicate or old?
// import 'package:vibechan/shared/widgets/post/post_view.dart'; // Assuming this exists - Commented out
// import 'package:vibechan/features/fourchan/board/providers/fourchan_catalog_provider.dart'; // Commented out
import 'package:vibechan/features/fourchan/presentation/widgets/responsive_widgets.dart';

class BoardCatalogScreen extends ConsumerWidget {
  final String boardId;

  const BoardCatalogScreen({super.key, required this.boardId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boards = ref.watch(boardsNotifierProvider);
    final catalogState = ref.watch(catalogNotifierProvider(boardId));
    final layoutState = ref.watch(layoutStateNotifierProvider);
    final viewMode = ref.watch(catalogViewModeProvider);
    final layoutService = ref.read(layoutServiceProvider);

    final isSearchActive = ref.watch(isSearchActiveProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    // Filter threads based on search query
    final threads = catalogState.maybeWhen(
      data: (threads) {
        if (isSearchActive && searchQuery.isNotEmpty) {
          return _filterThreadsBySearch(threads, searchQuery);
        }
        return threads;
      },
      orElse: () => <Thread>[],
    );

    // Get board name for display purposes and tab title updates
    final boardName = boards.maybeWhen(
      data: (boards) {
        final currentBoard = boards.firstWhere(
          (board) => board.id == boardId,
          orElse:
              () => Board(
                id: boardId,
                title: boardId,
                description: 'Loading board...',
              ),
        );

        // Update tab title if needed
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final tabNotifier = ref.read(tabManagerProvider.notifier);
          if (tabNotifier.activeTab?.initialRouteName == 'catalog') {
            tabNotifier.updateActiveTabTitle(
              '/${boardId}/ ${currentBoard.title}',
            );
          }
        });

        return currentBoard.title;
      },
      orElse: () => boardId,
    );

    final currentLayout = layoutState.currentLayout;

    return RefreshIndicator(
      onRefresh: () => _refreshCatalog(ref),
      child: catalogState.when(
        data: (originalThreads) {
          if (isSearchActive && searchQuery.isNotEmpty && threads.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    'No threads match "${searchQuery}"',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            );
          }

          return viewMode == CatalogViewMode.grid
              ? _buildGridView(
                context,
                threads,
                currentLayout,
                ref,
                layoutService,
              )
              : _buildMediaFeed(
                context,
                threads,
                currentLayout,
                searchQuery,
                ref,
              );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stackTrace) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48),
                  const SizedBox(height: 16),
                  Text('Error loading threads: $error'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _refreshCatalog(ref),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            ),
      ),
    );
  }

  List<Thread> _filterThreadsBySearch(List<Thread> threads, String query) {
    if (query.isEmpty) return threads;

    final searchTerms = query.toLowerCase();
    return threads.where((thread) {
      final post = thread.originalPost;
      final subject = post.subject?.toLowerCase() ?? '';
      final comment = post.comment?.toLowerCase() ?? '';
      final name = post.name?.toLowerCase() ?? '';

      return subject.contains(searchTerms) ||
          comment.contains(searchTerms) ||
          name.contains(searchTerms);
    }).toList();
  }

  Widget _buildGridView(
    BuildContext context,
    List<Thread> threads,
    AppLayout layoutType,
    WidgetRef ref,
    LayoutService layoutService,
  ) {
    return MasonryGridView.builder(
      padding: layoutService.getPaddingForLayout(layoutType),
      gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: layoutService.getColumnCountForLayout(layoutType),
      ),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      itemCount: threads.length,
      itemBuilder: (context, index) {
        final thread = threads[index];
        final previewItem = thread.toPreviewableItem(); // Use adapter

        // Only use animation on initial load, not for search filtering
        // Use a static key for each thread so it doesn't rebuild on search
        final itemKey = ValueKey(
          'thread-${previewItem.id}',
        ); // Use previewItem.id

        return KeyedSubtree(
          key: itemKey,
          // Update widget name and pass previewItem
          child: GenericPreviewCard(
            item: previewItem, // Pass the adapted item
            // index: index, // index no longer needed by GenericPreviewCard?
            onTap:
                () => _navigateToThread(
                  context,
                  ref,
                  thread,
                ), // Still use original thread for nav
            searchQuery: ref.watch(searchQueryProvider),
          ),
        );
      },
    );
  }

  Widget _buildMediaFeed(
    BuildContext context,
    List<Thread> threads,
    AppLayout layoutType,
    String searchQuery,
    WidgetRef ref,
  ) {
    return CatalogMediaFeed(
      threads: threads,
      onTap: (thread) => _navigateToThread(context, ref, thread),
      layoutType: layoutType,
      searchQuery: searchQuery,
    );
  }

  void _navigateToThread(BuildContext context, WidgetRef ref, Thread thread) {
    final tabNotifier = ref.read(tabManagerProvider.notifier);
    final threadTitle =
        thread.originalPost.subject?.isNotEmpty == true
            ? thread.originalPost.subject!
            : 'Thread #${thread.id}';

    tabNotifier.navigateToOrReplaceActiveTab(
      title: threadTitle,
      initialRouteName: 'thread',
      pathParameters: {'boardId': boardId, 'threadId': thread.id.toString()},
      icon: Icons.comment,
    );
  }

  Future<void> _refreshCatalog(WidgetRef ref) {
    return ref.read(catalogNotifierProvider(boardId).notifier).refresh();
  }
}
