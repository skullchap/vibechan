import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/providers/board_providers.dart';
import '../../../../shared/providers/tab_manager_provider.dart';
import '../widgets/board_grid_item.dart';

class BoardListScreen extends ConsumerWidget {
  const BoardListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final worksafeBoards = ref.watch(worksafeBoardsNotifierProvider);
    final nsfwBoards = ref.watch(nSFWBoardsNotifierProvider);

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          // Tab bar
          const TabBar(tabs: [Tab(text: 'Worksafe'), Tab(text: 'NSFW')]),

          // Tab content
          Expanded(
            child: TabBarView(
              children: [
                _BoardGridView(
                  boards: worksafeBoards,
                  onBoardTap: (board) => _openBoard(context, ref, board),
                ),
                _BoardGridView(
                  boards: nsfwBoards,
                  onBoardTap: (board) => _openBoard(context, ref, board),
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

class _BoardGridView extends StatelessWidget {
  final AsyncValue<List<dynamic>> boards;
  final Function(dynamic) onBoardTap;

  const _BoardGridView({required this.boards, required this.onBoardTap});

  @override
  Widget build(BuildContext context) {
    return boards.when(
      data:
          (boardList) => GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: boardList.length,
            itemBuilder:
                (context, index) => BoardGridItem(
                  board: boardList[index],
                  onTap: () => onBoardTap(boardList[index]),
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
                                      content: Text(
                                        'Added /${boardList[index].id}/ to favorites',
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                    );
                  },
                ),
          ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
