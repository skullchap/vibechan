import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/board/presentation/screens/board_list_screen.dart';
import '../features/board/presentation/screens/board_catalog_screen.dart';
import '../features/board/presentation/screens/favorites_screen.dart';
import '../features/thread/presentation/screens/thread_detail_screen.dart';
import '../shared/widgets/app_shell.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    // Root route now shows the app shell with tabs
    GoRoute(
      path: '/',
      builder: (context, state) => const AppShell(),
    ),
    
    // These routes are used within tabs but also available directly
    GoRoute(
      path: '/boards',
      name: 'boards',
      builder: (context, state) => const BoardListScreen(),
    ),
    GoRoute(
      path: '/favorites',
      name: 'favorites',
      builder: (context, state) => const FavoritesScreen(),
    ),
    GoRoute(
      path: '/board/:boardId',
      name: 'catalog',
      builder: (context, state) => BoardCatalogScreen(
        boardId: state.pathParameters['boardId']!,
      ),
      routes: [
        GoRoute(
          path: 'thread/:threadId',
          name: 'thread',
          builder: (context, state) => ThreadDetailScreen(
            boardId: state.pathParameters['boardId']!,
            threadId: state.pathParameters['threadId']!,
          ),
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Error: ${state.error}'),
    ),
  ),
);