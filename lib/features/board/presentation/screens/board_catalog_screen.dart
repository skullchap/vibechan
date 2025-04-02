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
import '../../../../core/utils/responsive_layout.dart';
import '../../../../core/presentation/widgets/responsive_widgets.dart';
import '../../../../core/services/layout_service.dart';

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

    final layoutState = ref.watch(layoutStateNotifierProvider);
    final currentLayout = layoutState.currentLayout;
    final layoutService = ref.read(layoutServiceProvider);

    final columnCount = layoutService.getColumnCountForLayout(currentLayout);
    final padding = layoutService.getPaddingForLayout(currentLayout);

    return RefreshIndicator(
      onRefresh:
          () => ref.read(catalogNotifierProvider(boardId).notifier).refresh(),
      child: threads.when(
        data:
            (threads) => AnimatedLayoutBuilder(
              child:
                  viewMode == CatalogViewMode.grid
                      ? MasonryGridView.builder(
                        padding: padding,
                        gridDelegate:
                            SliverSimpleGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: columnCount,
                            ),
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        itemCount: threads.length,
                        itemBuilder:
                            (context, index) => _buildThreadCard(
                              context,
                              threads[index],
                              index,
                              () => _openThread(context, ref, threads[index]),
                            ),
                      )
                      : CatalogMediaFeed(
                        threads: threads,
                        onTap: (thread) => _openThread(context, ref, thread),
                        padding: padding,
                        layoutType: currentLayout,
                      ),
            ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildThreadCard(
    BuildContext context,
    Thread thread,
    int index,
    VoidCallback onTap,
  ) {
    final delay = Duration(milliseconds: 30 * (index % 10));

    return FutureBuilder(
      future: Future.delayed(delay),
      builder: (context, snapshot) {
        return AnimatedOpacity(
          opacity: snapshot.connectionState == ConnectionState.done ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: AnimatedScale(
            scale:
                snapshot.connectionState == ConnectionState.done ? 1.0 : 0.95,
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutBack,
            child: ThreadPreviewCard(thread: thread, onTap: onTap),
          ),
        );
      },
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
