import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:vibechan/features/board/presentation/widgets/catalog/catalog_view_mode.dart';

import '../../../../core/presentation/providers/board_providers.dart';
import '../../../../core/presentation/providers/thread_providers.dart';
import '../../../../core/domain/models/thread.dart';
import '../../../../shared/widgets/app_shell.dart'; // for catalogViewModeProvider
import '../widgets/catalog/catalog_media_feed.dart';
import '../widgets/thread_preview_card.dart';

class BoardCatalogScreen extends ConsumerWidget {
  final String boardId;

  const BoardCatalogScreen({super.key, required this.boardId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final board = ref.watch(
      boardsNotifierProvider.select(
        (value) => value.whenData(
          (boards) => boards.firstWhere((b) => b.id == boardId),
        ),
      ),
    );

    final catalog = ref.watch(catalogNotifierProvider(boardId));
    final viewMode = ref.watch(catalogViewModeProvider);

    return RefreshIndicator(
      onRefresh:
          () => ref.read(catalogNotifierProvider(boardId).notifier).refresh(),
      child: catalog.when(
        data: (threads) {
          if (viewMode == CatalogViewMode.grid) {
            return MasonryGridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate:
                  const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              itemCount: threads.length,
              itemBuilder:
                  (context, index) => ThreadPreviewCard(
                    thread: threads[index],
                    onTap: () => _openThread(context, threads[index]),
                  ),
            );
          } else {
            return CatalogMediaFeed(
              threads: threads,
              onTap: (thread) => _openThread(context, thread),
            );
          }
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  void _openThread(BuildContext context, Thread thread) {
    context.go('/board/$boardId/thread/${thread.id}');
  }
}
