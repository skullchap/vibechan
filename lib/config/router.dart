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
// Import the new CarouselScreen
import 'package:vibechan/features/fourchan/carousel/presentation/screens/carousel_screen.dart';
// --- Import New Reddit Screens ---
import 'package:vibechan/features/reddit/presentation/screens/subreddit_grid_screen.dart';
import 'package:vibechan/features/reddit/presentation/screens/subreddit_screen.dart';
import 'package:vibechan/features/reddit/presentation/screens/post_detail_screen.dart';
// --- Import AppRoute enum ---
import 'package:vibechan/app/app_routes.dart';

// Remove navigator keys unless needed for specific non-shell scenarios
// final _rootNavigatorKey = GlobalKey<NavigatorState>();
// final _shellNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  // navigatorKey: _rootNavigatorKey, // Remove ShellRoute keys
  initialLocation: AppRoute.home.path, // Use enum for initial location
  routes: [
    // Root route renders the AppShell, which manages its own content via TabManager
    GoRoute(
      path: AppRoute.home.path, // Use enum
      name: AppRoute.home.name, // Use enum
      builder: (context, state) => const AppShell(),
      // Routes accessible *within* the AppShell structure
      routes: [
        // 4chan Routes
        GoRoute(
          path: 'boards',
          name: 'boards', // REVERTED
          builder: (context, state) => const BoardListScreen(),
          routes: [
            GoRoute(
              path: 'board/:boardId',
              name: 'catalog', // REVERTED
              builder:
                  (context, state) => BoardCatalogScreen(
                    boardId: state.pathParameters['boardId']!,
                  ),
              routes: [
                GoRoute(
                  path: 'thread/:threadId',
                  name: AppRoute.thread.name, // OK
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
        // Favorites Route
        GoRoute(
          path: 'favorites',
          name: 'favorites', // REVERTED
          builder: (context, state) => const FavoritesScreen(),
        ),
        // Settings Route
        GoRoute(
          path: 'settings',
          name: AppRoute.settings.name, // OK
          builder: (context, state) => const SettingsScreen(),
        ),

        // HackerNews Routes
        GoRoute(
          path: 'hackernews',
          name: 'hackernews', // REVERTED
          builder:
              (context, state) =>
                  const GenericNewsScreen(source: NewsSource.hackernews),
          routes: [
            GoRoute(
              path: 'item/:itemId',
              name: 'hackernews_item', // REVERTED
              builder:
                  (context, state) => GenericNewsItemScreen(
                    source: NewsSource.hackernews,
                    itemId: state.pathParameters['itemId'] ?? '',
                  ),
            ),
          ],
        ),

        // Lobsters Routes
        GoRoute(
          path: 'lobsters',
          name: AppRoute.lobsters.name, // OK
          builder:
              (context, state) =>
                  const GenericNewsScreen(source: NewsSource.lobsters),
          routes: [
            GoRoute(
              path: 'story/:storyId',
              name: 'lobsters_story', // REVERTED
              builder:
                  (context, state) => GenericNewsItemScreen(
                    source: NewsSource.lobsters,
                    itemId: state.pathParameters['storyId'] ?? '',
                  ),
            ),
          ],
        ),

        // --- NEW Reddit Routes (within AppShell) ---
        GoRoute(
          // Path matches the AppRoute enum path but relative to '/'
          // GoRouter handles combining parent/child paths
          path: AppRoute.subredditGrid.path.substring(1), // remove leading '/'
          name: AppRoute.subredditGrid.name, // OK: Use enum
          builder: (context, state) => const SubredditGridScreen(),
          routes: [
            GoRoute(
              // Path segment for subreddit: r/:subreddit
              path: 'r/:subreddit',
              name: AppRoute.subreddit.name, // OK: Use enum
              builder: (context, state) {
                final subredditName =
                    state.pathParameters['subreddit'] ?? 'all';
                return SubredditScreen(subreddit: subredditName);
              },
              routes: [
                GoRoute(
                  // Path segment for post detail: comments/:postId
                  path: 'comments/:postId',
                  name: AppRoute.postDetail.name, // OK: Use enum
                  builder: (context, state) {
                    final subredditName =
                        state.pathParameters['subreddit'] ?? 'unknown';
                    final postId = state.pathParameters['postId'] ?? 'unknown';
                    // Add error handling/validation for params if needed
                    return PostDetailScreen(
                      subreddit: subredditName,
                      postId: postId,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    // --- Separate Routes (Outside AppShell) ---
    GoRoute(
      path: '/carousel/:sourceInfo', // REVERTED
      name: 'carousel', // REVERTED
      builder: (context, state) {
        final sourceInfo = state.pathParameters['sourceInfo'];
        if (sourceInfo == null) {
          return const Scaffold(
            body: Center(
              child: Text('Error: Missing source info for carousel'),
            ),
          );
        }
        return CarouselScreen(sourceInfo: sourceInfo);
      },
    ),
    // Add other non-shell routes here (like login if needed)
  ],
  errorBuilder:
      (context, state) =>
          Scaffold(body: Center(child: Text('Error: ${state.error}'))),
);
