import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibechan/features/fourchan/domain/models/post.dart';
import 'package:vibechan/features/fourchan/presentation/providers/thread_providers.dart';
import 'package:vibechan/features/fourchan/thread/presentation/widgets/post_card.dart';
import 'package:vibechan/shared/providers/search_provider.dart';
import 'package:vibechan/core/services/layout_service.dart';
import 'package:vibechan/core/utils/responsive_layout.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ThreadDetailScreen extends ConsumerWidget {
  final String boardId;
  final String threadId;

  const ThreadDetailScreen({
    super.key,
    required this.boardId,
    required this.threadId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final thread = ref.watch(threadNotifierProvider(boardId, threadId));
    final isSearchActive = ref.watch(isSearchActiveProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final layoutService = ref.read(layoutServiceProvider);
    final layoutState = ref.watch(layoutStateNotifierProvider);
    final currentLayout = layoutState.currentLayout;

    // Return just the content directly, no Scaffold or AppBar
    return RefreshIndicator(
      onRefresh:
          () =>
              ref
                  .read(threadNotifierProvider(boardId, threadId).notifier)
                  .refresh(),
      child: thread.when(
        data: (threadData) {
          // Filter posts if search is active
          List<Post> filteredReplies = threadData.replies;
          bool showOP = true;

          if (isSearchActive && searchQuery.isNotEmpty) {
            // Filter replies by search term
            filteredReplies = _filterPostsBySearch(
              threadData.replies,
              searchQuery,
            );

            // Check if OP should be shown based on search term
            showOP = _postMatchesSearch(threadData.originalPost, searchQuery);
          }

          // If search is active but no posts match, show a "no results" message
          if (isSearchActive &&
              searchQuery.isNotEmpty &&
              filteredReplies.isEmpty &&
              !showOP) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    'No posts match "$searchQuery"',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed:
                        () => ref.read(searchQueryProvider.notifier).state = '',
                    child: const Text('Clear Search'),
                  ),
                ],
              ),
            );
          }

          // Prepare the list of all posts to display
          final List<Post> postsToDisplay = [];
          if (showOP) {
            postsToDisplay.add(threadData.originalPost);
          }
          postsToDisplay.addAll(filteredReplies);

          // Get the appropriate column count based on layout
          final int columnCount = _getColumnCountForLayout(
            context,
            currentLayout,
          );

          // Use a more responsive layout approach
          return LayoutBuilder(
            builder: (context, constraints) {
              return MasonryGridView.builder(
                padding: layoutService.getPaddingForLayout(currentLayout),
                gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columnCount,
                ),
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                itemCount: postsToDisplay.length,
                itemBuilder: (context, index) {
                  final post = postsToDisplay[index];
                  final isOp = showOP && index == 0;

                  return PostCard(
                    post: post,
                    isOriginalPost: isOp,
                    orderIndex: index,
                    onQuoteLink: (quotedPostId) {
                      // TODO: Implement quote link handling
                    },
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stackTrace) => Padding(
              // Use padding suitable for direct body content
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: $error'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed:
                          () =>
                              ref
                                  .read(
                                    threadNotifierProvider(
                                      boardId,
                                      threadId,
                                    ).notifier,
                                  )
                                  .refresh(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }

  // Get appropriate column count based on layout and screen width
  int _getColumnCountForLayout(BuildContext context, AppLayout layout) {
    final width = MediaQuery.of(context).size.width;

    // Customize column count based on screen width for better responsiveness
    if (width < ResponsiveBreakpoints.medium) {
      return 1; // Single column on small screens
    } else if (width < ResponsiveBreakpoints.expanded) {
      return 2; // 2 columns on medium screens
    } else if (width < ResponsiveBreakpoints.large) {
      return 3; // 3 columns on large screens
    } else if (width < ResponsiveBreakpoints.xlarge) {
      return 4; // 4 columns on extra large screens
    } else {
      return 5; // 5 columns on very wide screens
    }
  }

  // Check if a post matches the search query
  bool _postMatchesSearch(Post post, String query) {
    if (query.isEmpty) return true;

    final lowercaseQuery = query.toLowerCase();

    // Check post name
    if (post.name != null &&
        post.name!.toLowerCase().contains(lowercaseQuery)) {
      return true;
    }

    // Check post subject
    if (post.subject != null &&
        post.subject!.toLowerCase().contains(lowercaseQuery)) {
      return true;
    }

    // Check post comment
    if (post.comment.toLowerCase().contains(lowercaseQuery)) {
      return true;
    }

    return false;
  }

  // Filter posts by search query
  List<Post> _filterPostsBySearch(List<Post> posts, String query) {
    if (query.isEmpty) return posts;

    return posts.where((post) => _postMatchesSearch(post, query)).toList();
  }
}
