import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibechan/features/reddit/presentation/screens/reddit_screen.dart';

class SubredditScreen extends ConsumerWidget {
  final String subredditName;

  const SubredditScreen({super.key, required this.subredditName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RedditScreen(subredditName: subredditName);
  }
}
