import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/domain/models/post.dart';
import '../../../../shared/widgets/simple_html_renderer.dart';
import '../../../../shared/providers/search_provider.dart';

class PostBody extends ConsumerWidget {
  final Post post;

  const PostBody({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentHtml = post.comment ?? '';

    // Get search query for highlighting
    final isSearchActive = ref.watch(isSearchActiveProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final shouldHighlight = isSearchActive && searchQuery.isNotEmpty;

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SimpleHtmlRenderer(
        htmlString: commentHtml,
        baseStyle: textTheme.bodyMedium?.copyWith(
          height: 1.4,
          color: colorScheme.onSurfaceVariant,
        ),
        highlightTerms: shouldHighlight ? searchQuery : null,
        highlightColor: colorScheme.tertiaryContainer,
      ),
    );
  }
}
