import 'package:flutter/material.dart';
import 'package:vibechan/shared/enums/news_source.dart';
import 'package:vibechan/shared/widgets/news/generic_news_screen.dart';

/// A wrapper for the Lobsters story screen that uses the generic components
class LobstersStoryScreen extends StatelessWidget {
  final String storyId;

  const LobstersStoryScreen({super.key, required this.storyId});

  @override
  Widget build(BuildContext context) {
    return GenericNewsItemScreen(source: NewsSource.lobsters, itemId: storyId);
  }
}
