import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vibechan/app/app_routes.dart';
import 'package:vibechan/features/reddit/domain/adapters/reddit_post_adapter.dart';
import 'package:vibechan/features/reddit/domain/models/reddit_post.dart';
import 'package:vibechan/features/reddit/presentation/providers/subreddit_posts_provider.dart';
import 'package:vibechan/shared/enums/news_source.dart';
import 'package:vibechan/shared/widgets/news/generic_news_list_screen.dart';

class SubredditScreen extends ConsumerWidget {
  final String subredditName;

  const SubredditScreen({super.key, required this.subredditName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(subredditPostsProvider(subredditName));

    return GenericNewsListScreen(
      source: NewsSource.reddit,
      title: "r/$subredditName",
      itemsAsync: postsAsync.when(
        data:
            (posts) => AsyncValue.data(
              posts.map((post) => post.toGenericListItem()).toList(),
            ),
        loading: () => const AsyncValue.loading(),
        error: (err, stack) => AsyncValue.error(err, stack),
      ),
      onRefresh:
          () => ref.refresh(subredditPostsProvider(subredditName).future),
      detailRouteName: AppRoute.postDetail.name,
      listContextId: subredditName,
    );
  }
}
