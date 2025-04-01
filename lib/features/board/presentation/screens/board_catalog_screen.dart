import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/providers/board_providers.dart';
import '../../../../core/presentation/providers/thread_providers.dart';
import '../../../../shared/providers/tab_manager_provider.dart';
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

    // Return content without a Scaffold
    return RefreshIndicator(
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
            onTap: () => _openThread(context, ref, threads[index]),
            onLongPress: () {
              // Show options for this thread
              showModalBottomSheet(
                context: context,
                builder: (context) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.open_in_new),
                      title: const Text('Open in new tab'),
                      onTap: () {
                        Navigator.pop(context);
                        _openThreadInNewTab(ref, threads[index]);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.favorite_border),
                      title: const Text('Add to favorites'),
                      onTap: () {
                        Navigator.pop(context);
                        // TODO: Add to favorites
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Added thread #${threads[index].id} to favorites'),
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
    );
  }
  
  void _openThread(BuildContext context, WidgetRef ref, dynamic thread) {
    // Check if we're in the app shell with tabs
    final scaffold = Scaffold.maybeOf(context);
    if (scaffold?.hasDrawer ?? false) {
      // We're in the app shell with tabs, navigate within the current tab
      final tabManager = ref.read(tabManagerProvider.notifier);
      final tabs = ref.read(tabManagerProvider);
      final activeTab = tabs.isNotEmpty 
          ? tabs.firstWhere((tab) => tab.isActive, orElse: () => tabs.first)
          : null;
      
      // Fix: Access subject through originalPost instead of directly on thread
      final threadTitle = thread.originalPost.subject != null && thread.originalPost.subject.isNotEmpty
          ? thread.originalPost.subject
          : 'Thread #${thread.id}';
      
      if (activeTab != null) {
        // Update the current tab's route AND title
        tabManager.updateTabRoute(
          activeTab.id,
          '/board/$boardId/thread/${thread.id}',
          {
            'boardId': boardId,
            'threadId': thread.id.toString(),
          },
          newTitle: threadTitle,
          newIcon: Icons.forum,
        );
      }
    } else {
      // We're not in the app shell, use normal navigation
      context.go('/board/$boardId/thread/${thread.id}');
    }
  }
  
  void _openThreadInNewTab(WidgetRef ref, dynamic thread) {
    // Use the tab manager to open the thread in a new tab
    final tabManager = ref.read(tabManagerProvider.notifier);
    
    // Fix: Access subject through originalPost instead of directly on thread
    final title = thread.originalPost.subject != null && thread.originalPost.subject.isNotEmpty
        ? thread.originalPost.subject
        : 'Thread #${thread.id}';
    
    tabManager.addTab(
      title: title,
      route: '/board/$boardId/thread/${thread.id}',
      pathParameters: {
        'boardId': boardId,
        'threadId': thread.id.toString(),
      },
    );
  }
}