import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/providers/board_providers.dart';
import '../../../../core/presentation/providers/thread_providers.dart';
import '../widgets/thread_preview_card.dart';

class BoardCatalogScreen extends ConsumerWidget {
  final String boardId;

  const BoardCatalogScreen({
    super.key,
    required this.boardId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final board = ref.watch(boardsNotifierProvider.select(
      (value) => value.whenData((boards) => 
        boards.firstWhere((b) => b.id == boardId))));
        
    final catalog = ref.watch(catalogNotifierProvider(boardId));

    return Scaffold(
      appBar: AppBar(
        title: board.when(
          data: (board) => Text('/${board.id}/ - ${board.title}'),
          loading: () => const Text('Loading...'),
          error: (_, __) => Text('/$boardId/'),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(catalogNotifierProvider(boardId).notifier).refresh(),
        child: catalog.when(
          data: (threads) => MasonryGridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            itemCount: threads.length,
            itemBuilder: (context, index) => ThreadPreviewCard(
              thread: threads[index],
              onTap: () => context.go('/board/$boardId/thread/${threads[index].id}'),
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: $error'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.read(catalogNotifierProvider(boardId).notifier).refresh(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}