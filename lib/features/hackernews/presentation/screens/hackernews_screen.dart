import 'package:flutter/material.dart';
import 'package:vibechan/shared/enums/news_source.dart';
import 'package:vibechan/shared/widgets/news/generic_news_screen.dart';

/// A wrapper for the HackerNews screen that uses the generic components
/// This is a transitional component to help with migration to generic components
class HackerNewsScreen extends StatelessWidget {
  const HackerNewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const GenericNewsScreen(source: NewsSource.hackernews);
  }
}
