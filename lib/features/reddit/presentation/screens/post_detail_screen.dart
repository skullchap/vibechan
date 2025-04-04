import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibechan/features/reddit/domain/adapters/reddit_post_adapter.dart';
import 'package:vibechan/features/reddit/presentation/providers/post_detail_provider.dart';
import 'package:vibechan/features/reddit/presentation/widgets/reddit_comment_tile.dart';
import 'package:vibechan/shared/widgets/generic_list_card.dart';

class PostDetailScreen extends ConsumerWidget {
  final String subreddit;
  final String postId;

  const PostDetailScreen({
    super.key,
    required this.subreddit,
    required this.postId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final params = PostDetailParams(subreddit: subreddit, postId: postId);
    final detailState = ref.watch(postDetailProvider(params));

    return detailState.when(
      data: (data) {
        final post = data.$1;
        final comments = data.$2;

        return RefreshIndicator(
          onRefresh: () => ref.refresh(postDetailProvider(params).future),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                // Use adapter here
                child: GenericListCard(
                  item: post.toGenericListItem(),
                  onTap: null,
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Text(
                  '${post.numComments} Comments',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              if (comments.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.0),
                  child: Center(child: Text('No comments yet.')),
                )
              else
                ...comments.map(
                  (comment) => RedditCommentTile(comment: comment),
                ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error:
          (error, stackTrace) => Center(
            // USE SIMPLE TEXT FOR ERROR
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error loading post:\n${error.toString()}'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => ref.refresh(postDetailProvider(params)),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
