import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibechan/features/hackernews/presentation/providers/hackernews_stories_provider.dart';

import '../widgets/hackernews/hackernews_list_view.dart';

class HackerNewsScreen extends ConsumerWidget {
  const HackerNewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Read the current sort type
    final currentSortType = ref.watch(currentHackerNewsSortTypeProvider);

    // Display the ListView widget, passing the sort type
    return HackerNewsListView(sortType: currentSortType);
  }
}
