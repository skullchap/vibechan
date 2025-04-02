import 'package:flutter/material.dart';

import '../../../../core/domain/models/board.dart';

class BoardGridItem extends StatelessWidget {
  final Board board;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final String? highlightQuery;

  const BoardGridItem({
    super.key,
    required this.board,
    required this.onTap,
    this.onLongPress,
    this.highlightQuery,
  });

  @override
  Widget build(BuildContext context) {
    // Check if we should highlight this board
    final bool shouldHighlight =
        highlightQuery != null &&
        highlightQuery!.isNotEmpty &&
        (board.id.toLowerCase().contains(highlightQuery!.toLowerCase()) ||
            board.title.toLowerCase().contains(highlightQuery!.toLowerCase()) ||
            board.description.toLowerCase().contains(
              highlightQuery!.toLowerCase(),
            ));

    return Card(
      clipBehavior: Clip.antiAlias,
      // Highlight the card if it matches search
      color:
          shouldHighlight
              ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3)
              : null,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Board ID with potential highlight
              highlightQuery != null && highlightQuery!.isNotEmpty
                  ? _buildHighlightedText(
                    context,
                    '/${board.id}/',
                    highlightQuery!,
                    Theme.of(context).textTheme.titleLarge,
                  )
                  : Text(
                    '/${board.id}/',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
              const SizedBox(height: 4),
              // Board title with potential highlight
              highlightQuery != null && highlightQuery!.isNotEmpty
                  ? _buildHighlightedText(
                    context,
                    board.title,
                    highlightQuery!,
                    Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                  )
                  : Text(
                    board.title,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              const SizedBox(height: 4),
              Text(
                '${board.threadsCount} threads',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to highlight matching text
  Widget _buildHighlightedText(
    BuildContext context,
    String text,
    String query,
    TextStyle? style, {
    int? maxLines,
  }) {
    final String lowerText = text.toLowerCase();
    final String lowerQuery = query.toLowerCase();

    // If no match, return regular text
    if (!lowerText.contains(lowerQuery)) {
      return Text(
        text,
        style: style,
        textAlign: TextAlign.center,
        maxLines: maxLines,
        overflow: maxLines != null ? TextOverflow.ellipsis : null,
      );
    }

    // Otherwise, build rich text with highlights
    final List<TextSpan> spans = [];
    int startIndex = 0;

    while (true) {
      final int matchIndex = lowerText.indexOf(lowerQuery, startIndex);
      if (matchIndex == -1) {
        // Add the remaining text
        spans.add(TextSpan(text: text.substring(startIndex), style: style));
        break;
      }

      // Add text before match
      if (matchIndex > startIndex) {
        spans.add(
          TextSpan(text: text.substring(startIndex, matchIndex), style: style),
        );
      }

      // Add highlighted match
      spans.add(
        TextSpan(
          text: text.substring(matchIndex, matchIndex + lowerQuery.length),
          style: style?.copyWith(
            backgroundColor: Theme.of(
              context,
            ).colorScheme.primary.withOpacity(0.3),
            fontWeight: FontWeight.bold,
          ),
        ),
      );

      startIndex = matchIndex + lowerQuery.length;
    }

    return Text.rich(
      TextSpan(children: spans),
      textAlign: TextAlign.center,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
    );
  }
}
