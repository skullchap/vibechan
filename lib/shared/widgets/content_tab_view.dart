import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/board/presentation/screens/board_list_screen.dart';
import '../../features/board/presentation/screens/board_catalog_screen.dart';
import '../../features/board/presentation/screens/favorites_screen.dart';
import '../../features/thread/presentation/screens/thread_detail_screen.dart';
import '../models/tab_item.dart';

/// Widget that displays the content of a tab
class ContentTabView extends ConsumerWidget {
  final TabItem tab;
  
  const ContentTabView({
    super.key,
    required this.tab,
  });
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Based on the route, show appropriate content
    switch (tab.route) {
      case '/':
      case '/boards':
        return const BoardListScreen();
        
      case '/favorites':
        return const FavoritesScreen();
        
      default:
        // For routes with parameters, we need to handle them specially
        if (tab.route.startsWith('/board/') && !tab.route.contains('thread')) {
          final boardId = tab.pathParameters['boardId'];
          if (boardId != null) {
            return BoardCatalogScreen(boardId: boardId);
          }
        }
        
        if (tab.route.contains('thread')) {
          final boardId = tab.pathParameters['boardId'];
          final threadId = tab.pathParameters['threadId'];
          if (boardId != null && threadId != null) {
            return ThreadDetailScreen(
              boardId: boardId,
              threadId: threadId,
            );
          }
        }
        
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Unknown route: ${tab.route}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  context.go('/');
                },
                child: const Text('Go to Home'),
              ),
            ],
          ),
        );
    }
  }
}