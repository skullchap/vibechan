import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/providers/board_providers.dart';
import '../widgets/board_grid_item.dart';

class BoardListScreen extends ConsumerWidget {
  const BoardListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final worksafeBoards = ref.watch(worksafeBoardsNotifierProvider);
    final nsfwBoards = ref.watch(nSFWBoardsNotifierProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Boards'),
          bottom: const TabBar(
            tabs: [Tab(text: 'Worksafe'), Tab(text: 'NSFW')],
          ),
        ),
        body: TabBarView(
          children: [
            _BoardGridView(
              boards: worksafeBoards,
              onBoardTap: (boardId) => context.go('/board/$boardId'),
            ),
            _BoardGridView(
              boards: nsfwBoards,
              onBoardTap: (boardId) => context.go('/board/$boardId'),
            ),
          ],
        ),
      ),
    );
  }
}

class _BoardGridView extends StatelessWidget {
  final AsyncValue<List<dynamic>> boards;
  final Function(String) onBoardTap;

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
                  onTap: () => onBoardTap(boardList[index].id),
                ),
          ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
