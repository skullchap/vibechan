import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/providers/board_providers.dart';
import '../../../../shared/providers/tab_manager_provider.dart';
import '../widgets/board_grid_item.dart';
// Import responsive layout components
import '../../../../core/utils/responsive_layout.dart';
import '../../../../core/presentation/widgets/responsive_widgets.dart';
import '../../../../core/services/layout_service.dart';
import '../../../../shared/providers/search_provider.dart'; // Import search provider

class BoardListScreen extends ConsumerWidget {
  const BoardListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final worksafeBoards = ref.watch(worksafeBoardsNotifierProvider);
    final nsfwBoards = ref.watch(nSFWBoardsNotifierProvider);

    // Get current layout state
    final layoutState = ref.watch(layoutStateNotifierProvider);
    final currentLayout = layoutState.currentLayout;
    final layoutService = ref.read(layoutServiceProvider);

    // Get search state
    final isSearchActive = ref.watch(searchVisibleProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    // Determine grid column count based on layout
    final columnCount = layoutService.getColumnCountForLayout(currentLayout);

    // Determine if we should use horizontal tabs for wider layouts
    final useHorizontalTabs = currentLayout != AppLayout.mobile;

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          // Tab bar - adapt based on screen size
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 48,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 0.5,
                ),
              ),
            ),
            child: TabBar(
              isScrollable: useHorizontalTabs,
              tabAlignment:
                  useHorizontalTabs ? TabAlignment.start : TabAlignment.fill,
              tabs: [
                Padding(
                  padding:
                      useHorizontalTabs
                          ? const EdgeInsets.symmetric(horizontal: 16.0)
                          : EdgeInsets.zero,
                  child: const Tab(text: 'Worksafe'),
                ),
                Padding(
                  padding:
                      useHorizontalTabs
                          ? const EdgeInsets.symmetric(horizontal: 16.0)
                          : EdgeInsets.zero,
                  child: const Tab(text: 'NSFW'),
                ),
              ],
            ),
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              children: [
                // Worksafe boards with responsive grid
                _ResponsiveBoardGridView(
                  boards: worksafeBoards,
                  onBoardTap: (board) => _openBoard(context, ref, board),
                  columnCount: columnCount,
                  searchActive: isSearchActive,
                  searchQuery: searchQuery,
                ),
                // NSFW boards with responsive grid
                _ResponsiveBoardGridView(
                  boards: nsfwBoards,
                  onBoardTap: (board) => _openBoard(context, ref, board),
                  columnCount: columnCount,
                  searchActive: isSearchActive,
                  searchQuery: searchQuery,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openBoard(BuildContext context, WidgetRef ref, dynamic board) {
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

class _ResponsiveBoardGridView extends StatelessWidget {
  final AsyncValue<List<dynamic>> boards;
  final Function(dynamic) onBoardTap;
  final int columnCount;
  final bool searchActive;
  final String searchQuery;

  const _ResponsiveBoardGridView({
    required this.boards,
    required this.onBoardTap,
    required this.columnCount,
    this.searchActive = false,
    this.searchQuery = '',
  });

  @override
  Widget build(BuildContext context) {
    return boards.when(
      data: (boardList) {
        // Filter boards based on search query if search is active
        final filteredBoards =
            searchActive && searchQuery.isNotEmpty
                ? _filterBoards(boardList, searchQuery)
                : boardList;

        if (searchActive && searchQuery.isNotEmpty && filteredBoards.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.search_off, size: 64),
                const SizedBox(height: 16),
                Text(
                  'No boards match "${searchQuery}"',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          );
        }

        return AnimatedLayoutBuilder(
          child: GridView.builder(
            padding: ResponsiveLayout.getPadding(context),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columnCount,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: filteredBoards.length,
            itemBuilder:
                (context, index) =>
                    _buildBoardItem(context, filteredBoards[index]),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  // Filter boards based on search query
  List<dynamic> _filterBoards(List<dynamic> boards, String query) {
    final lowercaseQuery = query.toLowerCase().trim();
    return boards.where((board) {
      // Get the board ID and remove any slashes that might be in it
      final rawId = board.id.toString().toLowerCase();
      // Strip any slashes from the ID for pure comparison
      final cleanId = rawId.replaceAll('/', '');

      final title = board.title.toString().toLowerCase();
      final description = board.description.toString().toLowerCase();

      // Check for matches on the clean ID without slashes
      final bool matchesShortName =
          cleanId ==
              lowercaseQuery || // Direct match (e.g., "gif" matches board with ID "/gif/")
          cleanId.startsWith(lowercaseQuery) || // Prefix match
          cleanId.contains(lowercaseQuery); // Substring match

      // Also check if the raw ID with slashes matches
      final bool matchesRawId = rawId.contains(lowercaseQuery);

      // Check if title or description matches
      final bool matchesLongName =
          title.contains(lowercaseQuery) ||
          description.contains(lowercaseQuery);

      return matchesShortName || matchesRawId || matchesLongName;
    }).toList();
  }

  Widget _buildBoardItem(BuildContext context, dynamic board) {
    return AnimatedScale(
      scale: 1.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: AnimatedOpacity(
        opacity: 1.0,
        duration: const Duration(milliseconds: 300),
        child: BoardGridItem(
          board: board,
          onTap: () => onBoardTap(board),
          onLongPress: () {
            // Show context menu with options
            showModalBottomSheet(
              context: context,
              builder:
                  (context) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.favorite_border),
                        title: const Text('Add to favorites'),
                        onTap: () {
                          Navigator.pop(context);
                          // TODO: Add to favorites (use a separate FavoritesProvider)
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Added /${board.id}/ to favorites'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
            );
          },
          // Highlight search term if active
          highlightQuery: searchActive ? searchQuery : null,
        ),
      ),
    );
  }
}
