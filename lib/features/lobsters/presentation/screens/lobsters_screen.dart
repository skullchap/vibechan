import 'package:flutter/material.dart';
import 'package:vibechan/shared/enums/news_source.dart';
import 'package:vibechan/shared/widgets/news/generic_news_screen.dart';

/// A wrapper for the Lobsters screen that uses the generic components
class LobstersScreen extends StatelessWidget {
  const LobstersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const GenericNewsScreen(source: NewsSource.lobsters);
  }
}
