import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vibechan/features/fourchan/domain/models/board.dart';
// Corrected package imports
import 'package:vibechan/features/fourchan/presentation/providers/board_providers.dart';
import 'package:vibechan/shared/providers/tab_manager_provider.dart';
import 'package:vibechan/shared/widgets/grid_item_card.dart';
import 'package:vibechan/features/fourchan/board/domain/adapters/board_grid_adapter.dart';
// import '../../../../core/utils/responsive_layout.dart'; // Seems unused or missing
import 'package:vibechan/core/services/layout_service.dart';
import 'package:vibechan/shared/providers/search_provider.dart';

class BoardListScreen extends ConsumerWidget {
  const BoardListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch providers
    final worksafeBoardsState = ref.watch(worksafeBoardsNotifierProvider);
    final nsfwBoardsState = ref.watch(nSFWBoardsNotifierProvider);
    final layoutState = ref.watch(layoutStateNotifierProvider);
    final layoutService = ref.read(layoutServiceProvider);
    final isSearchActive = ref.watch(searchVisibleProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    // Calculate column count based on layout
    final columnCount = layoutService.getColumnCountForLayout(
      layoutState.currentLayout,
    );

    // Combine worksafe and nsfw states for unified display
    // Show loading/error from either if present, otherwise combine data
    Widget buildCombinedGrid(List<Board> worksafe, List<Board> nsfw) {
      final combined = [...worksafe, ...nsfw];
      // Sort the combined list alphabetically by board ID
      combined.sort((a, b) => a.id.compareTo(b.id));

      return _ResponsiveBoardGridView(
        boards: combined, // Pass the sorted combined list
        onBoardTap: (board) => _openBoard(context, ref, board),
        columnCount: columnCount,
        searchActive: isSearchActive,
        searchQuery: searchQuery,
      );
    }

    return SingleChildScrollView(
      child: worksafeBoardsState.when(
        data:
            (wsBoards) => nsfwBoardsState.when(
              data: (nsfwBoards) => buildCombinedGrid(wsBoards, nsfwBoards),
              loading:
                  () => buildCombinedGrid(
                    wsBoards,
                    [],
                  ), // Show worksafe while nsfw loads
              error:
                  (e, s) => buildCombinedGrid(
                    wsBoards,
                    [],
                  ), // Show worksafe on nsfw error
            ),
        loading:
            () => Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: CircularProgressIndicator(),
              ),
            ), // Show loading indicator while worksafe loads
        error:
            (e, s) => Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Error loading boards: $e'),
              ),
            ), // Show error if worksafe fails
      ),
      // Remove the old Column structure with separate sections
      /*
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(...), // Worksafe title
          // Handle worksafe boards state
          worksafeBoardsState.when(...),
          Padding(...), // NSFW title
          // Handle NSFW boards state
          nsfwBoardsState.when(...),
        ],
      ),
      */
    );
  }

  void _openBoard(BuildContext context, WidgetRef ref, Board board) {
    // Use navigateToOrReplaceActiveTab to update the current tab
    final tabNotifier = ref.read(tabManagerProvider.notifier);
    // Change to addTab to open the board in a *new* tab
    tabNotifier.addTab(
      title: '/${board.id}/ - ${board.title}', // Use board info for title
      initialRouteName: 'catalog',
      pathParameters: {'boardId': board.id},
      icon: Icons.view_list, // Example icon for catalog
    );
  }
}

// Helper widget for displaying boards in a responsive grid
// Accepts List<Board> directly now
class _ResponsiveBoardGridView extends ConsumerWidget {
  final List<Board> boards;
  final Function(Board) onBoardTap;
  final int columnCount;
  final bool searchActive;
  final String searchQuery;

  const _ResponsiveBoardGridView({
    required this.boards,
    required this.onBoardTap,
    required this.columnCount,
    required this.searchActive,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Filter boards based on search query
    final filteredBoards =
        searchActive && searchQuery.isNotEmpty
            ? _filterBoards(boards, searchQuery)
            : boards;

    if (filteredBoards.isEmpty && searchActive) {
      return const Center(child: Text('No boards match search'));
    }

    // Replace ResponsiveLayout with LayoutBuilder
    return LayoutBuilder(
      builder: (context, constraints) {
        // The actual grid building logic, assuming it uses columnCount which
        // is already determined based on the responsive layout elsewhere.
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columnCount,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 3 / 2, // Restore original aspect ratio
          ),
          itemCount: filteredBoards.length,
          itemBuilder: (context, index) {
            final board = filteredBoards[index];
            final gridItem = board.toGridItem(); // Use adapter
            return GridItemCard(
              item: gridItem, // Pass adapted item
              onTap:
                  () => onBoardTap(board), // Still use original board for tap
              highlightQuery: searchActive ? searchQuery : null,
            );
          },
        );
      },
    );
  }

  List<Board> _filterBoards(List<Board> boards, String query) {
    query = query.toLowerCase();
    return boards.where((board) {
      final title = board.title.toLowerCase();
      final id = board.id.toLowerCase();
      return title.contains(query) || id.contains(query);
    }).toList();
  }
}
