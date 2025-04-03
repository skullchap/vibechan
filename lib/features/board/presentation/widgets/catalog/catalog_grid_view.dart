import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:vibechan/core/domain/models/thread.dart';
import 'package:vibechan/core/services/layout_service.dart';
import 'package:vibechan/shared/providers/search_provider.dart';

import '../../screens/board_catalog_screen.dart'; // Correct path for ThreadPreviewItem
import '../../utils/catalog_navigation.dart'; // Correct path for navigation

/// Builds the catalog grid view using Masonry layout.
class CatalogGridView extends ConsumerWidget {
  final List<Thread> threads;

  const CatalogGridView({super.key, required this.threads});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layoutState = ref.watch(layoutStateNotifierProvider);
    final layoutService = ref.read(layoutServiceProvider);
    final currentLayout = layoutState.currentLayout;
    final boardId = GoRouterState.of(context).pathParameters['boardId'] ?? '';

    return MasonryGridView.builder(
      padding: layoutService.getPaddingForLayout(currentLayout),
      gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: layoutService.getColumnCountForLayout(currentLayout),
      ),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      itemCount: threads.length,
      itemBuilder: (context, index) {
        final thread = threads[index];
        final itemKey = ValueKey('thread-${thread.id}');

        return KeyedSubtree(
          key: itemKey,
          child: ThreadPreviewItem(
            thread: thread,
            index: index,
            onTap: () => navigateToThread(ref, boardId, thread),
            searchQuery: ref.watch(searchQueryProvider),
          ),
        );
      },
    );
  }
}
