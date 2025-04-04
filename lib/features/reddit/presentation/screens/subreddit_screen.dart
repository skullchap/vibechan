import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibechan/features/reddit/domain/adapters/reddit_post_adapter.dart'; // Adapter
import 'package:vibechan/features/reddit/presentation/providers/subreddit_posts_provider.dart';
import 'package:vibechan/shared/widgets/generic_list_card.dart'; // The generic card
import 'package:vibechan/app/app_routes.dart';
import 'package:vibechan/shared/providers/tab_manager_provider.dart';

class SubredditScreen extends ConsumerStatefulWidget {
  final String subreddit;
  const SubredditScreen({super.key, required this.subreddit});

  @override
  ConsumerState<SubredditScreen> createState() => _SubredditScreenState();
}

class _SubredditScreenState extends ConsumerState<SubredditScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      // Trigger near bottom
      // Call fetchMorePosts on the provider
      ref
          .read(subredditPostsProvider(widget.subreddit).notifier)
          .fetchMorePosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the provider for the specific subreddit
    final postsState = ref.watch(subredditPostsProvider(widget.subreddit));

    // Determine if the provider is currently fetching more posts
    // This relies on the provider managing an internal `_isLoadingMore` flag
    // or extending the state to include this information.
    // For now, we check if the state is AsyncLoading AFTER having data.
    final bool isLoadingMore = postsState.hasValue && postsState.isRefreshing;

    return RefreshIndicator(
      onRefresh:
          () => ref.refresh(subredditPostsProvider(widget.subreddit).future),
      child: postsState.when(
        // Main content display
        data: (posts) {
          if (posts.isEmpty && !postsState.isLoading) {
            // Show empty message only if not loading initially
            return const Center(
              child: Text('No posts found in this subreddit.'),
            );
          }

          return ListView.builder(
            controller: _scrollController,
            itemCount:
                posts.length + (isLoadingMore ? 1 : 0), // Add space for loader
            itemBuilder: (context, index) {
              if (isLoadingMore && index == posts.length) {
                // Show loading indicator at the bottom if loading more
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final post = posts[index];
              final genericItem = post.toGenericListItem(); // Use the adapter

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                child: GenericListCard(
                  item: genericItem,
                  onTap: () {
                    final tabNotifier = ref.read(tabManagerProvider.notifier);

                    // Navigate using TabManager
                    tabNotifier.navigateToOrReplaceActiveTab(
                      // Use post title, fallback if empty
                      title: post.title.isNotEmpty ? post.title : 'Post',
                      initialRouteName: AppRoute.postDetail.name,
                      pathParameters: {
                        'subreddit': post.subreddit,
                        'postId': post.id,
                      },
                      icon: Icons.comment_outlined, // Icon for comments/post
                    );
                  },
                ),
              );
            },
          );
        },
        // Initial Loading State
        loading: () => const Center(child: CircularProgressIndicator()),
        // Error State Handling
        error: (error, stackTrace) {
          final previousData =
              postsState.valueOrNull; // Get previous data if available
          if (previousData != null && previousData.isNotEmpty) {
            // Show previous list with error message at the bottom
            print(
              "Error state reached but showing previous data for r/${widget.subreddit}",
            );
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller:
                        _scrollController, // Attach scroll controller here too
                    itemCount: previousData.length,
                    itemBuilder: (context, index) {
                      final post = previousData[index];
                      final genericItem = post.toGenericListItem();
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 4.0,
                        ),
                        // Ensure card is tappable even in error state display
                        child: GenericListCard(
                          item: genericItem,
                          onTap: () {
                            final tabNotifier = ref.read(
                              tabManagerProvider.notifier,
                            );

                            // Navigate using TabManager (same logic as above)
                            tabNotifier.navigateToOrReplaceActiveTab(
                              title:
                                  post.title.isNotEmpty ? post.title : 'Post',
                              initialRouteName: AppRoute.postDetail.name,
                              pathParameters: {
                                'subreddit': post.subreddit,
                                'postId': post.id,
                              },
                              icon: Icons.comment_outlined,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                // Error indicator at bottom
                Container(
                  padding: const EdgeInsets.all(16.0),
                  color: Theme.of(
                    context,
                  ).colorScheme.errorContainer.withAlpha((255 * 0.8).round()),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Error loading more posts', // Simplified message
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ),
                      // Optionally add a retry button here for the fetchMorePosts action
                      TextButton(
                        onPressed:
                            () =>
                                ref
                                    .read(
                                      subredditPostsProvider(
                                        widget.subreddit,
                                      ).notifier,
                                    )
                                    .fetchMorePosts(),
                        child: Text(
                          'RETRY',
                          style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.onErrorContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            // No previous data, show full screen error
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error loading posts:\n${error.toString()}'),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed:
                          () => ref.refresh(
                            subredditPostsProvider(widget.subreddit),
                          ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
