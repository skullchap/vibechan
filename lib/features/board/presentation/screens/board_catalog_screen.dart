import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vibechan/core/domain/models/board.dart';
import 'package:vibechan/core/domain/models/thread.dart';
import 'package:vibechan/core/presentation/widgets/common/empty_state.dart';
import 'package:vibechan/core/presentation/widgets/common/loading_indicator.dart';

import '../../../../core/presentation/providers/board_providers.dart';
import '../../../../core/presentation/providers/thread_providers.dart';
import '../../../../shared/providers/search_provider.dart';
import '../../../../shared/providers/tab_manager_provider.dart';
import '../utils/catalog_navigation.dart';
import '../utils/thread_filtering.dart';
import '../widgets/catalog/catalog_grid_view.dart';
import '../widgets/catalog/catalog_media_feed.dart';
import '../widgets/catalog/catalog_view_mode.dart';
import '../widgets/thread_preview_card.dart';

class BoardCatalogScreen extends ConsumerStatefulWidget {
  final String boardId;

  const BoardCatalogScreen({super.key, required this.boardId});

  @override
  ConsumerState<BoardCatalogScreen> createState() => _BoardCatalogScreenState();
}

class _BoardCatalogScreenState extends ConsumerState<BoardCatalogScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger title update after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateTabTitle());
  }

  @override
  void didUpdateWidget(covariant BoardCatalogScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.boardId != widget.boardId) {
      // Update title if boardId changes
      WidgetsBinding.instance.addPostFrameCallback((_) => _updateTabTitle());
    }
  }

  void _updateTabTitle() {
    final boards = ref.read(boardsNotifierProvider);
    final board = boards.maybeWhen(
      data:
          (list) => list.firstWhere(
            (b) => b.id == widget.boardId,
            orElse:
                () => Board(
                  id: widget.boardId,
                  title: 'Loading...',
                  description: '',
                ),
          ),
      orElse:
          () => Board(id: widget.boardId, title: 'Loading...', description: ''),
    );
    final title =
        board != null
            ? '/${widget.boardId}/ ${board.title}'
            : '/${widget.boardId}/';

    final tabNotifier = ref.read(tabManagerProvider.notifier);
    if (tabNotifier.activeTab?.initialRouteName == 'catalog' &&
        tabNotifier.activeTab?.pathParameters['boardId'] == widget.boardId) {
      tabNotifier.updateActiveTabTitle(title);
    }
  }

  Future<void> _refreshCatalog() {
    return ref.read(catalogNotifierProvider(widget.boardId).notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final catalogState = ref.watch(catalogNotifierProvider(widget.boardId));
    final viewMode = ref.watch(catalogViewModeProvider);
    final isSearchActive = ref.watch(isSearchActiveProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    return RefreshIndicator(
      onRefresh: _refreshCatalog,
      child: catalogState.when(
        data: (threads) {
          final filteredThreads = filterThreadsBySearch(
            threads,
            isSearchActive ? searchQuery : '',
          );

          if (filteredThreads.isEmpty) {
            return EmptyState(
              icon: isSearchActive ? Icons.search_off : Icons.forum_outlined,
              title:
                  isSearchActive
                      ? 'No threads match "${searchQuery}"'
                      : 'No threads found in this board',
            );
          }

          return viewMode == CatalogViewMode.grid
              ? CatalogGridView(threads: filteredThreads)
              : CatalogMediaFeed(
                threads: filteredThreads,
                onTap:
                    (thread) => navigateToThread(ref, widget.boardId, thread),
                searchQuery: isSearchActive ? searchQuery : null,
              );
        },
        loading: () => const LoadingIndicator(),
        error: (error, stackTrace) => _buildErrorState(context, error),
      ),
    );
  }

  // Keep old error state for now as ErrorDisplay failed
  Widget _buildErrorState(BuildContext context, Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48),
          const SizedBox(height: 16),
          Text('Error loading threads: $error'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _refreshCatalog,
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}

/// Widget to display a thread preview card with animations
/// Kept here for now as it uses StatefulWidget logic
class ThreadPreviewItem extends StatefulWidget {
  final Thread thread;
  final int index;
  final VoidCallback onTap;
  final String? searchQuery;

  const ThreadPreviewItem({
    super.key,
    required this.thread,
    required this.index,
    required this.onTap,
    this.searchQuery,
  });

  @override
  State<ThreadPreviewItem> createState() => _ThreadPreviewItemState();
}

class _ThreadPreviewItemState extends State<ThreadPreviewItem> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    // Stagger animation based on index
    Future.delayed(Duration(milliseconds: 30 * (widget.index % 10)), () {
      if (mounted) {
        setState(() {
          _isVisible = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: AnimatedScale(
        scale: _isVisible ? 1.0 : 0.95,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutBack,
        child: ThreadPreviewCard(
          thread: widget.thread,
          onTap: widget.onTap,
          searchQuery: widget.searchQuery,
        ),
      ),
    );
  }
}
