import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibechan/features/fourchan/board/presentation/screens/board_catalog_screen.dart';
import 'package:vibechan/features/fourchan/board/presentation/screens/board_list_screen.dart';
import 'package:vibechan/features/fourchan/board/presentation/screens/favorites_screen.dart';
import 'package:vibechan/features/fourchan/board/presentation/screens/settings_screen.dart';
import 'package:vibechan/features/fourchan/thread/presentation/screens/thread_detail_screen.dart';
import 'package:vibechan/features/lobsters/presentation/providers/lobsters_stories_provider.dart';
import 'package:vibechan/features/reddit/presentation/screens/subreddit_grid_screen.dart';
import 'package:vibechan/features/reddit/presentation/providers/subreddit_posts_provider.dart';
import 'package:vibechan/features/reddit/presentation/providers/post_detail_provider.dart';
import 'package:vibechan/features/reddit/domain/adapters/reddit_post_adapter.dart';
import 'package:vibechan/shared/widgets/news/generic_news_list_screen.dart';
import 'package:vibechan/shared/widgets/news/generic_news_detail_screen.dart';
import 'package:vibechan/shared/enums/news_source.dart';
import 'package:vibechan/app/app_routes.dart';
import 'package:vibechan/features/hackernews/presentation/providers/hackernews_item_detail_provider.dart';
import 'package:vibechan/features/lobsters/presentation/providers/lobsters_story_detail_provider.dart';

import '../../models/content_tab.dart';
import '../../../core/services/layout_service.dart';
import '../../../features/hackernews/presentation/screens/hackernews_screen.dart';

// Define a record type for the build result
typedef _ContentBuildResult = ({Widget content, bool addPadding});

class AppShellContentView extends ConsumerWidget {
  final ContentTab? activeTab;
  final bool isSearchVisible;

  const AppShellContentView({
    super.key,
    required this.activeTab,
    required this.isSearchVisible,
  });

  // Helper function to build content based on the active tab and AppRoute
  _ContentBuildResult _buildContentForTab(ContentTab? tab, WidgetRef ref) {
    if (tab == null) {
      return (
        content: const Center(
          child: Text('No tabs open. Select a source to start.'),
        ),
        addPadding: true,
      );
    }

    final routeName = tab.initialRouteName;
    final params = tab.pathParameters;

    // Use if/else if with AppRoute.xxx.name for comparison
    if (routeName == AppRoute.boardList.name) {
      return (content: const BoardListScreen(), addPadding: true);
    } else if (routeName == AppRoute.boardCatalog.name) {
      final boardId = params['boardId'];
      return (
        content:
            boardId != null
                ? BoardCatalogScreen(boardId: boardId)
                : const Center(child: Text('Error: Missing boardId')),
        addPadding: false,
      );
    } else if (routeName == AppRoute.thread.name) {
      final boardId = params['boardId'];
      final threadId = params['threadId'];
      return (
        content:
            (boardId != null && threadId != null)
                ? ThreadDetailScreen(boardId: boardId, threadId: threadId)
                : const Center(child: Text('Error: Missing board/thread ID')),
        addPadding: false,
      );
    } else if (routeName == AppRoute.favorites.name) {
      return (content: const FavoritesScreen(), addPadding: true);
    } else if (routeName == AppRoute.settings.name) {
      return (content: const SettingsScreen(), addPadding: true);
    } else if (routeName == AppRoute.hackernews.name) {
      // Assuming HackerNewsScreen is the correct top-level widget now
      // If it needs to be GenericNewsScreen, adjust accordingly
      return (content: const HackerNewsScreen(), addPadding: true);
    } else if (routeName == AppRoute.hackernewsItem.name) {
      final itemId = int.tryParse(params['itemId'] ?? '');
      // Use GenericNewsDetailScreen for HN Item
      return (
        content:
            itemId != null
                ? Consumer(
                  builder: (context, ref, _) {
                    final detailAsync = ref.watch(
                      // Ensure correct provider is used (assuming one exists for HN Item)
                      // Replace with actual HN item detail provider if different
                      hackerNewsItemDetailProvider(itemId),
                    );
                    return GenericNewsDetailScreen(
                      source: NewsSource.hackernews,
                      itemDetailAsync: detailAsync,
                      onRefresh:
                          () => ref.refresh(
                            hackerNewsItemDetailProvider(itemId).future,
                          ),
                    );
                  },
                )
                : const Center(child: Text('Error: Missing item ID')),
        addPadding: false,
      );
    } else if (routeName == AppRoute.lobsters.name) {
      // Use GenericNewsListScreen for Lobsters
      return (
        content: Consumer(
          builder: (context, ref, _) {
            // Get the current sort type
            final currentSortType = ref.watch(currentLobstersSortTypeProvider);
            // Watch the provider family with the current sort type
            final itemsAsync = ref.watch(
              lobstersStoriesProvider(currentSortType),
            );
            return GenericNewsListScreen(
              source: NewsSource.lobsters,
              title: 'Lobsters', // Or fetch dynamically if needed
              itemsAsync: itemsAsync.when(
                // Provider already returns List<GenericListItem>
                data: (items) => AsyncData(items),
                loading: () => const AsyncLoading(),
                error: (e, s) => AsyncError(e, s),
              ),
              detailRouteName: AppRoute.lobstersStory.name,
              listContextId: 'lobsters_main', // Unique context ID
              onRefresh: () async {
                // Refresh the provider instance with the current sort type
                ref.refresh(lobstersStoriesProvider(currentSortType).future);
              },
            );
          },
        ),
        addPadding: true, // Or false depending on GenericNewsListScreen design
      );
    } else if (routeName == AppRoute.lobstersStory.name) {
      final storyId = params['storyId'];
      // Use GenericNewsDetailScreen for Lobsters Story
      return (
        content:
            storyId != null
                ? Consumer(
                  builder: (context, ref, _) {
                    final detailAsync = ref.watch(
                      // Ensure correct provider is used
                      lobstersStoryDetailProvider(storyId),
                    );
                    return GenericNewsDetailScreen(
                      source: NewsSource.lobsters,
                      itemDetailAsync: detailAsync,
                      onRefresh:
                          () => ref.refresh(
                            lobstersStoryDetailProvider(storyId).future,
                          ),
                    );
                  },
                )
                : const Center(child: Text('Error: Missing story ID')),
        addPadding: false,
      );
    } else if (routeName == AppRoute.subredditGrid.name) {
      return (content: const SubredditGridScreen(), addPadding: true);
    } else if (routeName == AppRoute.subreddit.name) {
      final subredditName = params['subredditName'];
      return (
        content:
            subredditName != null
                ? Consumer(
                  builder: (context, ref, _) {
                    final postsAsync = ref.watch(
                      subredditPostsProvider(subredditName),
                    );
                    return GenericNewsListScreen(
                      source: NewsSource.reddit,
                      title: 'r/$subredditName',
                      itemsAsync: postsAsync.when(
                        data:
                            (posts) => AsyncData(
                              posts.map((p) => p.toGenericListItem()).toList(),
                            ),
                        loading: () => const AsyncLoading(),
                        error: (e, s) => AsyncError(e, s),
                      ),
                      detailRouteName: AppRoute.postDetail.name,
                      listContextId:
                          subredditName, // Use subreddit name as context
                      onRefresh:
                          () => ref.refresh(
                            subredditPostsProvider(subredditName).future,
                          ),
                    );
                  },
                )
                : const Center(child: Text('Error: Missing subreddit name')),
        addPadding: false,
      );
    } else if (routeName == AppRoute.postDetail.name) {
      final subredditName = params['subredditName'];
      final postId = params['postId'];
      return (
        content:
            (subredditName != null && postId != null)
                ? Consumer(
                  builder: (context, ref, _) {
                    final detailParams = PostDetailParams(
                      subreddit: subredditName,
                      postId: postId,
                    );
                    final detailAsync = ref.watch(
                      postDetailProvider(detailParams),
                    );
                    return GenericNewsDetailScreen(
                      source: NewsSource.reddit,
                      itemDetailAsync: detailAsync,
                      onRefresh:
                          () => ref.refresh(
                            postDetailProvider(detailParams).future,
                          ),
                    );
                  },
                )
                : const Center(child: Text('Error: Missing subreddit/post ID')),
        addPadding: false,
      );
    } else {
      // Fallback for unknown route names
      return (
        content: Center(child: Text('Unknown content for: ${tab.title}')),
        addPadding: true,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layoutState = ref.watch(layoutStateNotifierProvider);
    final layoutService = ref.read(layoutServiceProvider);
    final padding = layoutService.getPaddingForLayout(
      layoutState.currentLayout,
    );

    // Call the helper function to get content and padding flag
    final (:content, :addPadding) = _buildContentForTab(activeTab, ref);

    // Wrap content with padding based on layout and the flag
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
              activeTab!.title, // Still use tab title for the secondary bar
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
