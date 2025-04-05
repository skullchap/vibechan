import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibechan/features/reddit/domain/adapters/reddit_post_adapter.dart';
import 'package:vibechan/features/reddit/presentation/providers/post_detail_provider.dart';
import 'package:vibechan/features/reddit/presentation/widgets/reddit_comment_tile.dart';
import 'package:vibechan/shared/widgets/generic_list_card.dart';
import 'package:vibechan/shared/enums/news_source.dart';
import 'package:vibechan/shared/widgets/news/generic_news_detail_screen.dart';

/// This screen now acts as a wrapper to fetch Reddit post details
/// and display them using the generic detail screen.
class PostDetailScreen extends ConsumerWidget {
  final String subredditName;
  final String postId;

  const PostDetailScreen({
    super.key,
    required this.subredditName,
    required this.postId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Create the params object
    final params = PostDetailParams(subreddit: subredditName, postId: postId);
    // Watch the provider using the params
    final detailAsync = ref.watch(postDetailProvider(params));

    return GenericNewsDetailScreen(
      source: NewsSource.reddit,
      // Pass the AsyncValue directly
      itemDetailAsync: detailAsync,
      // Pass the refresh logic
      onRefresh: () => ref.refresh(postDetailProvider(params).future),
    );
  }
}
