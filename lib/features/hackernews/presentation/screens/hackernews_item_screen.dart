import 'package:flutter/material.dart';
import 'package:vibechan/shared/enums/news_source.dart';
import 'package:vibechan/shared/widgets/news/generic_news_screen.dart';

/// A wrapper for the HackerNews item screen that uses the generic components
class HackerNewsItemScreen extends StatelessWidget {
  final int itemId;

  const HackerNewsItemScreen({super.key, required this.itemId});

  @override
  Widget build(BuildContext context) {
    return GenericNewsItemScreen(
      source: NewsSource.hackernews,
      itemId: itemId.toString(),
    );
  }
}
