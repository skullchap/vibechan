import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibechan/features/fourchan/domain/models/post.dart';
import 'package:vibechan/features/fourchan/presentation/providers/thread_providers.dart';
import 'package:vibechan/features/fourchan/thread/presentation/widgets/post_card.dart';
import 'package:vibechan/shared/providers/search_provider.dart';

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

          // Calculate total item count based on filtering
          int totalItems = filteredReplies.length + (showOP ? 1 : 0);

          return ListView.builder(
            // Ensure top padding is removed, keep others
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
            itemCount: totalItems,
            itemBuilder: (context, index) {
              // Handle the case where OP might be filtered out
              if (showOP && index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: PostCard(
                    post: threadData.originalPost,
                    isOriginalPost: true,
                    onQuoteLink: (quotedPostId) {
                      // TODO: Implement quote link handling
                    },
                  ),
                );
              } else {
                // Adjust index if OP is shown
                final adjustedIndex = showOP ? index - 1 : index;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: PostCard(
                    post: filteredReplies[adjustedIndex],
                    isOriginalPost: false,
                    onQuoteLink: (quotedPostId) {
                      // TODO: Implement quote link handling
                    },
                  ),
                );
              }
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
