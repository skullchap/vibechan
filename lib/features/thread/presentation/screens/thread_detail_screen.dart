import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vibechan/core/presentation/widgets/common/empty_state.dart';
import 'package:vibechan/core/presentation/widgets/common/loading_indicator.dart';

import '../../../../core/presentation/providers/thread_providers.dart';
import '../../../../shared/providers/search_provider.dart';
import '../../../../core/domain/models/post.dart';
import '../utils/post_filtering.dart';
import '../widgets/post_card.dart';

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
    final threadState = ref.watch(threadNotifierProvider(boardId, threadId));
    final isSearchActive = ref.watch(isSearchActiveProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    Future<void> refresh() =>
        ref.read(threadNotifierProvider(boardId, threadId).notifier).refresh();

    return RefreshIndicator(
      onRefresh: refresh,
      child: threadState.when(
        data: (threadData) {
          final showOP = postMatchesSearch(
            threadData.originalPost,
            isSearchActive ? searchQuery : '',
          );
          final filteredReplies = filterPostsBySearch(
            threadData.replies,
            isSearchActive ? searchQuery : '',
          );

          if (isSearchActive &&
              searchQuery.isNotEmpty &&
              !showOP &&
              filteredReplies.isEmpty) {
            return EmptyState(
              icon: Icons.search_off,
              title: 'No posts match "${searchQuery}"',
              subtitle: 'Clear search to see all posts',
            );
          }

          if (!showOP && filteredReplies.isEmpty) {
            // Should not normally happen unless OP is the only post and is filtered out.
            return const EmptyState(
              icon: Icons.forum_outlined,
              title: 'No posts to display',
            );
          }

          int totalItems = filteredReplies.length + (showOP ? 1 : 0);

          return ListView.builder(
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
              bottom: 8,
              top: 8,
            ), // Added top padding
            itemCount: totalItems,
            itemBuilder: (context, index) {
              if (showOP && index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: PostCard(
                    post: threadData.originalPost,
                    isOriginalPost: true,
                    highlightQuery: isSearchActive ? searchQuery : null,
                    onQuoteLink: (quotedPostId) {
                      // TODO: Implement quote link handling
                    },
                  ),
                );
              } else {
                final adjustedIndex = showOP ? index - 1 : index;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: PostCard(
                    post: filteredReplies[adjustedIndex],
                    isOriginalPost: false,
                    highlightQuery: isSearchActive ? searchQuery : null,
                    onQuoteLink: (quotedPostId) {
                      // TODO: Implement quote link handling
                    },
                  ),
                );
              }
            },
          );
        },
        loading: () => const LoadingIndicator(),
        error:
            (error, stackTrace) => _buildErrorWidget(context, error, refresh),
      ),
    );
  }

  // Keep old error handling for now
  Widget _buildErrorWidget(
    BuildContext context,
    Object error,
    VoidCallback onRetry,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 16),
            Text('Error loading thread: $error'),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
