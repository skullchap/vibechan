import 'package:flutter/material.dart';
import 'package:vibechan/core/utils/time_utils.dart';
import 'package:vibechan/features/lobsters/data/models/lobsters_story.dart';
import 'package:vibechan/shared/widgets/simple_html_renderer.dart';

class LobstersCommentCard extends StatelessWidget {
  final LobstersComment comment;
  final Color marginColor;
  final String? searchQuery;

  const LobstersCommentCard({
    super.key,
    required this.comment,
    required this.marginColor,
    this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: marginColor, width: 3)),
      ),
      padding: const EdgeInsets.only(left: 12, top: 8, right: 8, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Comment metadata
          DefaultTextStyle(
            style: theme.textTheme.bodySmall!.copyWith(
              color: theme.textTheme.bodySmall!.color?.withOpacity(0.7),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.person_outline_rounded,
                  size: 14,
                  color: marginColor,
                ),
                const SizedBox(width: 3),
                Text(comment.commentingUser),
                const SizedBox(width: 8),
                Icon(Icons.access_time_rounded, size: 14),
                const SizedBox(width: 3),
                Text(formatTimeAgoSimple(comment.createdAt)),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_upward_rounded,
                  size: 14,
                  color: theme.colorScheme.secondary,
                ),
                const SizedBox(width: 2),
                Text('${comment.score}'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Comment body
          SimpleHtmlRenderer(
            htmlString: comment.comment ?? '',
            baseStyle: theme.textTheme.bodyMedium,
            highlightTerms: searchQuery,
            highlightColor: theme.colorScheme.primaryContainer.withOpacity(0.5),
          ),
        ],
      ),
    );
  }
}
