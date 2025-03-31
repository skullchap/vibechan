import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/board/presentation/screens/board_list_screen.dart';
import '../features/board/presentation/screens/board_catalog_screen.dart';
import '../features/thread/presentation/screens/thread_detail_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'boards',
      builder: (context, state) => const BoardListScreen(),
      routes: [
        GoRoute(
          path: 'board/:boardId',
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
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Error: ${state.error}'),
    ),
  ),
);