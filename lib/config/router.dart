import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/board/presentation/screens/board_list_screen.dart';
import '../features/board/presentation/screens/board_catalog_screen.dart';
import '../features/board/presentation/screens/favorites_screen.dart';
import '../features/board/presentation/screens/settings_screen.dart';
import '../features/thread/presentation/screens/thread_detail_screen.dart';
import '../shared/widgets/app_shell.dart';

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
