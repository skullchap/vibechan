import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/providers/thread_providers.dart';
// import '../../../../shared/providers/tab_manager_provider.dart'; // Removed
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
    final thread = ref.watch(threadNotifierProvider(boardId, threadId));

    // Return content with a back button to navigate to the board
    return RefreshIndicator(
      onRefresh:
          () =>
              ref
                  .read(threadNotifierProvider(boardId, threadId).notifier)
                  .refresh(),
      child: thread.when(
        data:
            (threadData) => ListView.builder(
              padding: const EdgeInsets.only(
                top: 60,
                left: 8,
                right: 8,
                bottom: 8,
              ), // Add padding for the back button
              itemCount: threadData.replies.length + 1, // +1 for OP
              itemBuilder: (context, index) {
                final post =
                    index == 0
                        ? threadData.originalPost
                        : threadData.replies[index - 1];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: PostCard(
                    post: post,
                    isOriginalPost: index == 0,
                    onQuoteLink: (quotedPostId) {
                      // TODO: Implement quote link handling
                    },
                  ),
                );
              },
            ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stackTrace) => Padding(
              padding: const EdgeInsets.only(
                top: 60,
              ), // Add padding for the back button
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
}
