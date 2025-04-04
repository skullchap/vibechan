import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibechan/features/fourchan/board/presentation/screens/board_catalog_screen.dart';
import 'package:vibechan/features/fourchan/board/presentation/screens/board_list_screen.dart';
import 'package:vibechan/features/fourchan/board/presentation/screens/favorites_screen.dart';
import 'package:vibechan/features/fourchan/board/presentation/screens/settings_screen.dart';
import 'package:vibechan/features/fourchan/thread/presentation/screens/thread_detail_screen.dart';

import '../../models/content_tab.dart';
import '../../../core/services/layout_service.dart';
import '../../../features/fourchan/presentation/widgets/responsive_widgets.dart';
import '../../../features/hackernews/presentation/screens/hackernews_screen.dart';
import '../../../features/hackernews/presentation/screens/hackernews_item_screen.dart';
import '../../../features/lobsters/presentation/screens/lobsters_screen.dart';
import '../../../features/lobsters/presentation/screens/lobsters_story_screen.dart';

class AppShellContentView extends ConsumerWidget {
  final ContentTab? activeTab;
  final bool isSearchVisible; // Need this to conditionally show content title

  const AppShellContentView({
    super.key,
    required this.activeTab,
    required this.isSearchVisible,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layoutState = ref.watch(layoutStateNotifierProvider);
    final layoutService = ref.read(layoutServiceProvider);
    final padding = layoutService.getPaddingForLayout(
      layoutState.currentLayout,
    );

    Widget content;
    bool addPadding = true;

    if (activeTab == null) {
      content = const Center(
        child: Text('No tabs open. Select a source to start.'),
      );
    } else {
      switch (activeTab!.initialRouteName) {
        case 'boards':
          content = const BoardListScreen();
          break;
        case 'catalog':
          final boardId = activeTab!.pathParameters['boardId'];
          content =
              boardId != null
                  ? BoardCatalogScreen(boardId: boardId)
                  : const Center(child: Text('Error: Missing boardId'));
          addPadding = false;
          break;
        case 'thread':
          final boardId = activeTab!.pathParameters['boardId'];
          final threadId = activeTab!.pathParameters['threadId'];
          content =
              (boardId != null && threadId != null)
                  ? ThreadDetailScreen(boardId: boardId, threadId: threadId)
                  : const Center(child: Text('Error: Missing board/thread ID'));
          addPadding = false;
          break;
        case 'favorites':
          content = const FavoritesScreen();
          break;
        case 'settings':
          content = const SettingsScreen();
          break;
        case 'hackernews':
          content = const HackerNewsScreen();
          break;
        case 'hackernews_item':
          final itemIdStr = activeTab!.pathParameters['itemId'];
          final itemId = int.tryParse(itemIdStr ?? '');
          content =
              itemId != null
                  ? HackerNewsItemScreen(itemId: itemId)
                  : const Center(child: Text('Error: Missing item ID'));
          addPadding = false;
          break;
        case 'lobsters':
          content = const LobstersScreen();
          break;
        case 'lobsters_story':
          final storyId = activeTab!.pathParameters['storyId'];
          content =
              storyId != null
                  ? LobstersStoryScreen(storyId: storyId)
                  : const Center(child: Text('Error: Missing story ID'));
          addPadding = false;
          break;
        default:
          content = Center(child: Text('Content for: ${activeTab!.title}'));
      }
    }

    // Wrap content with padding based on layout
    final mainContent =
        addPadding ? Padding(padding: padding, child: content) : content;

    // Conditionally add the secondary app bar (content title)
    if (activeTab != null && !isSearchVisible) {
      return Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  width: 0.5,
                ),
              ),
              color: Theme.of(context).colorScheme.surface,
            ),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10.0,
            ),
            child: Text(
              activeTab!.title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: mainContent),
        ],
      );
    } else {
      return mainContent; // No secondary title bar needed
    }
  }
}
