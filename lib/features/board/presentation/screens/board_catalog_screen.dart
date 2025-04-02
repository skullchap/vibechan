import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/providers/board_providers.dart';
import '../../../../core/presentation/providers/thread_providers.dart';
import '../../../../shared/providers/tab_manager_provider.dart';
import '../../../../core/domain/models/thread.dart';
import '../widgets/catalog/catalog_view_mode.dart';
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

    final threads = ref.watch(catalogNotifierProvider(boardId));
    final viewMode = ref.watch(catalogViewModeProvider);

    return RefreshIndicator(
      onRefresh:
          () => ref.read(catalogNotifierProvider(boardId).notifier).refresh(),
      child: threads.when(
        data:
            (threads) =>
                viewMode == CatalogViewMode.grid
                    ? MasonryGridView.builder(
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
                            onTap:
                                () => _openThread(context, ref, threads[index]),
                          ),
                    )
                    : CatalogMediaFeed(
                      threads: threads,
                      onTap: (thread) => _openThread(context, ref, thread),
                    ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  void _openThread(BuildContext context, WidgetRef ref, Thread thread) {
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
}
