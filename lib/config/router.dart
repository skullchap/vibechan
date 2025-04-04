import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Update imports to new paths using package-relative format
import 'package:vibechan/features/fourchan/board/presentation/screens/board_list_screen.dart';
import 'package:vibechan/features/fourchan/board/presentation/screens/board_catalog_screen.dart';
import 'package:vibechan/features/fourchan/board/presentation/screens/favorites_screen.dart'; // Assuming this moved too
import 'package:vibechan/features/fourchan/board/presentation/screens/settings_screen.dart'; // Assuming this moved too
import 'package:vibechan/features/fourchan/thread/presentation/screens/thread_detail_screen.dart';
import 'package:vibechan/shared/widgets/app_shell.dart';
// Add imports for generic news screens
import 'package:vibechan/shared/widgets/news/generic_news_screen.dart';
import 'package:vibechan/shared/enums/news_source.dart';

// Remove navigator keys unless needed for specific non-shell scenarios
// final _rootNavigatorKey = GlobalKey<NavigatorState>();
// final _shellNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  // navigatorKey: _rootNavigatorKey, // Remove ShellRoute keys
  initialLocation: '/', // Root shows AppShell
  routes: [
    // Root route renders the AppShell, which manages its own content via TabManager
    GoRoute(
      path: '/',
      name: 'home', // Give it a name
      builder: (context, state) => const AppShell(),
      // Note: AppShell itself will handle displaying different screens based on its internal tab state,
      // not directly based on these sub-routes unless we design it that way.
      // These routes *could* potentially be used by the ContentTabView logic if needed,
      // but they are not driving the AppShell structure directly anymore.
      routes: [
        // Keep these nested definitions available if ContentTabView needs them for routing *within* a tab view
        GoRoute(
          path: 'boards', // Relative path now under '/'
          name: 'boards',
          builder: (context, state) => const BoardListScreen(),
          routes: [
            GoRoute(
              path: 'board/:boardId', // Keep path params relative
              name: 'catalog',
              builder:
                  (context, state) => BoardCatalogScreen(
                    boardId: state.pathParameters['boardId']!,
                  ),
              routes: [
                GoRoute(
                  path: 'thread/:threadId',
                  name: 'thread',
                  builder:
                      (context, state) => ThreadDetailScreen(
                        boardId: state.pathParameters['boardId']!,
                        threadId: state.pathParameters['threadId']!,
                      ),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: 'favorites', // Relative path
          name: 'favorites',
          builder: (context, state) => const FavoritesScreen(),
        ),
        GoRoute(
          path: 'settings', // Relative path
          name: 'settings',
          builder: (context, state) => const SettingsScreen(),
        ),

        // Generic news routes
        // HackerNews routes
        GoRoute(
          path: 'hackernews',
          name: 'hackernews',
          builder:
              (context, state) =>
                  const GenericNewsScreen(source: NewsSource.hackernews),
        ),
        GoRoute(
          path: 'hackernews/item/:itemId',
          name: 'hackernews_item',
          builder:
              (context, state) => GenericNewsItemScreen(
                source: NewsSource.hackernews,
                itemId: state.pathParameters['itemId'] ?? '',
              ),
        ),

        // Lobsters routes
        GoRoute(
          path: 'lobsters',
          name: 'lobsters',
          builder:
              (context, state) =>
                  const GenericNewsScreen(source: NewsSource.lobsters),
        ),
        GoRoute(
          path: 'lobsters/story/:storyId',
          name: 'lobsters_story',
          builder:
              (context, state) => GenericNewsItemScreen(
                source: NewsSource.lobsters,
                itemId: state.pathParameters['storyId'] ?? '',
              ),
        ),

        // Reddit routes (placeholder for future implementation)
        GoRoute(
          path: 'reddit',
          name: 'reddit',
          builder:
              (context, state) =>
                  const Center(child: Text('Reddit support coming soon!')),
        ),
        GoRoute(
          path: 'reddit/post/:postId',
          name: 'reddit_post',
          builder:
              (context, state) =>
                  const Center(child: Text('Reddit post view coming soon!')),
        ),
      ],
    ),
    // Define any routes that should NOT show the AppShell (e.g., a standalone login screen)
    // GoRoute(
    //   path: '/login',
    //   name: 'login',
    //   builder: (context, state) => const LoginScreen(),
    // ),
  ],
  errorBuilder:
      (context, state) =>
          Scaffold(body: Center(child: Text('Error: ${state.error}'))),
);
