import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vibechan/features/fourchan/board/presentation/screens/board_list_screen.dart';
import 'package:vibechan/features/fourchan/board/presentation/screens/board_catalog_screen.dart';
import 'package:vibechan/features/fourchan/board/presentation/screens/favorites_screen.dart';
import 'package:vibechan/features/fourchan/board/presentation/screens/settings_screen.dart';
import 'package:vibechan/features/fourchan/thread/presentation/screens/thread_detail_screen.dart';
import 'package:vibechan/shared/widgets/app_shell.dart';
import 'package:vibechan/shared/widgets/news/generic_news_screen.dart';
import 'package:vibechan/shared/widgets/news/generic_news_detail_screen.dart';
import 'package:vibechan/shared/enums/news_source.dart';
import 'package:vibechan/features/fourchan/carousel/presentation/screens/carousel_screen.dart';
import 'package:vibechan/features/reddit/presentation/screens/subreddit_grid_screen.dart';
import 'package:vibechan/features/reddit/presentation/screens/subreddit_screen.dart';
import 'package:vibechan/features/reddit/presentation/screens/post_detail_screen.dart';
import 'package:vibechan/app/app_routes.dart';
import 'package:vibechan/features/hackernews/presentation/providers/hackernews_item_detail_provider.dart';
import 'package:vibechan/features/lobsters/presentation/providers/lobsters_story_detail_provider.dart';

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
          path: AppRoute.boardList.path.substring(1), // Relative path
          name: AppRoute.boardList.name,
          builder: (context, state) => const BoardListScreen(),
          routes: [
            GoRoute(
              path: 'board/:boardId',
              name: AppRoute.boardCatalog.name,
              builder:
                  (context, state) => BoardCatalogScreen(
                    boardId: state.pathParameters['boardId']!,
                  ),
              routes: [
                GoRoute(
                  path: 'thread/:threadId',
                  name: AppRoute.thread.name,
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
          path: AppRoute.favorites.path.substring(1), // Relative path
          name: AppRoute.favorites.name,
          builder: (context, state) => const FavoritesScreen(),
        ),
        // Settings Route
        GoRoute(
          path: AppRoute.settings.path.substring(1), // Relative path
          name: AppRoute.settings.name,
          builder: (context, state) => const SettingsScreen(),
        ),

        // HackerNews Routes (using AppShellContentView)
        GoRoute(
          path: AppRoute.hackernews.path.substring(1), // Relative path
          name: AppRoute.hackernews.name,
          builder:
              (context, state) =>
                  const GenericNewsScreen(source: NewsSource.hackernews),
          routes: [
            GoRoute(
              path: 'item/:itemId', // Path relative to parent
              name: AppRoute.hackernewsItem.name,
              builder: (context, state) {
                final itemId = int.tryParse(
                  state.pathParameters['itemId'] ?? '',
                );
                if (itemId == null) {
                  return const Scaffold(
                    body: Center(child: Text('Invalid Item ID')),
                  );
                }
                return Consumer(
                  builder: (context, ref, _) {
                    final itemAsync = ref.watch(
                      hackerNewsItemDetailProvider(itemId),
                    );
                    return GenericNewsDetailScreen(
                      source: NewsSource.hackernews,
                      itemDetailAsync: itemAsync,
                      onRefresh:
                          () => ref.refresh(
                            hackerNewsItemDetailProvider(itemId).future,
                          ),
                    );
                  },
                );
              },
            ),
          ],
        ),

        // Lobsters Routes
        GoRoute(
          path: AppRoute.lobsters.path.substring(1), // Relative path
          name: AppRoute.lobsters.name,
          builder:
              (context, state) =>
                  const GenericNewsScreen(source: NewsSource.lobsters),
          routes: [
            GoRoute(
              path: 'story/:storyId',
              name: AppRoute.lobstersStory.name,
              builder: (context, state) {
                final storyId = state.pathParameters['storyId'] ?? '';
                if (storyId.isEmpty) {
                  return const Scaffold(
                    body: Center(child: Text('Invalid Story ID')),
                  );
                }
                return Consumer(
                  builder: (context, ref, _) {
                    final itemAsync = ref.watch(
                      lobstersStoryDetailProvider(storyId),
                    );
                    return GenericNewsDetailScreen(
                      source: NewsSource.lobsters,
                      itemDetailAsync: itemAsync,
                      onRefresh:
                          () => ref.refresh(
                            lobstersStoryDetailProvider(storyId).future,
                          ),
                    );
                  },
                );
              },
            ),
          ],
        ),

        GoRoute(
          path: AppRoute.subredditGrid.path.substring(1), // Relative path
          name: AppRoute.subredditGrid.name,
          builder: (context, state) => const SubredditGridScreen(),
          routes: [
            GoRoute(
              path: 'r/:subredditName', // Relative path, use :subredditName
              name: AppRoute.subreddit.name,
              builder: (context, state) {
                final subredditName =
                    state.pathParameters['subredditName'] ?? 'all';
                return SubredditScreen(subredditName: subredditName);
              },
              routes: [
                GoRoute(
                  path: 'comments/:postId', // Relative path, no :title
                  name: AppRoute.postDetail.name,
                  builder: (context, state) {
                    print("--- PostDetail Route Builder ---");
                    print("state.pathParameters: ${state.pathParameters}");

                    final subredditName =
                        state.pathParameters['subredditName'] ?? 'unknown';
                    final postId = state.pathParameters['postId'] ?? 'unknown';

                    print("Extracted subredditName: $subredditName");
                    print("Extracted postId: $postId");

                    if (subredditName == 'unknown' ||
                        subredditName.isEmpty ||
                        postId == 'unknown' ||
                        postId.isEmpty) {
                      print(
                        "Error: Invalid parameters received by PostDetail route builder.",
                      );
                      return Scaffold(
                        appBar: AppBar(title: Text("Error")),
                        body: Center(
                          child: Text("Invalid subreddit or post ID provided."),
                        ),
                      );
                    }

                    return PostDetailScreen(
                      subredditName: subredditName,
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
      path: AppRoute.carousel.path, // Use enum path
      name: AppRoute.carousel.name, // Use enum name
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
