import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/presentation/widgets/responsive_widgets.dart';
import '../../../features/board/presentation/screens/board_catalog_screen.dart';
import '../../../features/board/presentation/screens/board_list_screen.dart';
import '../../../features/board/presentation/screens/favorites_screen.dart';
import '../../../features/hackernews/presentation/screens/hackernews_item_screen.dart';
import '../../../features/hackernews/presentation/screens/hackernews_screen.dart';
import '../../../features/lobsters/presentation/screens/lobsters_screen.dart';
import '../../../features/lobsters/presentation/screens/lobsters_story_screen.dart';
import '../../../features/thread/presentation/screens/thread_detail_screen.dart';
import '../../models/content_tab.dart';
import '../../providers/search_provider.dart';

/// Widget to display the content based on the active tab
class ContentTabView extends ConsumerWidget {
  final ContentTab tab;

  const ContentTabView({super.key, required this.tab});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Reset search results when changing tabs
    if (ref.watch(searchVisibleProvider)) {
      Future.microtask(() {
        ref.read(searchVisibleProvider.notifier).state = false;
        ref.read(searchQueryProvider.notifier).state = '';
      });
    }

    return AnimatedLayoutBuilder(
      child: _buildContentForRoute(tab.initialRouteName, tab.pathParameters),
    );
  }

  /// Builds the appropriate content widget based on the route
  Widget _buildContentForRoute(String routeName, Map<String, String> params) {
    switch (routeName) {
      // 4chan routes
      case 'boards':
        return const BoardListScreen();
      case 'catalog':
        final boardId = params['boardId'] ?? '';
        return BoardCatalogScreen(boardId: boardId);
      case 'thread':
        final boardId = params['boardId'] ?? '';
        final threadId = params['threadId'] ?? '';
        return ThreadDetailScreen(boardId: boardId, threadId: threadId);
      case 'favorites':
        return const FavoritesScreen();

      // HackerNews routes
      case 'hackernews':
        return const HackerNewsScreen();
      case 'hackernews_item':
        final itemIdStr = params['itemId'] ?? '0';
        final itemId = int.tryParse(itemIdStr) ?? 0;
        return HackerNewsItemScreen(itemId: itemId);

      // Lobsters routes
      case 'lobsters':
        return const LobstersScreen();
      case 'lobsters_story':
        final storyId = params['storyId'] ?? '';
        return LobstersStoryScreen(storyId: storyId);

      // Default / fallback
      default:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64),
              const SizedBox(height: 16),
              Text(
                'Unknown route: $routeName',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text('Parameters: $params'),
            ],
          ),
        );
    }
  }
}
