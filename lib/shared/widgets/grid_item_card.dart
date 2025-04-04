import 'package:flutter/material.dart';
// import 'package:vibechan/core/domain/models/board.dart'; // Use GridItem
import 'package:vibechan/shared/models/grid_item.dart';

// Renamed class
class GridItemCard extends StatelessWidget {
  // Use GridItem
  final GridItem item;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final String? highlightQuery;

  const GridItemCard({
    super.key,
    required this.item, // Updated parameter
    required this.onTap,
    this.onLongPress,
    this.highlightQuery,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    // Determine colors based on the item's sensitive flag
    final bool isSensitive = item.isSensitive;
    final Color cardColor =
        isSensitive
            ? colorScheme.errorContainer
            : colorScheme
                .surfaceContainerHigh; // Use a slightly different default
    final Color idColor =
        isSensitive ? colorScheme.onErrorContainer : colorScheme.onSurface;
    final Color titleColor =
        isSensitive
            ? colorScheme.onErrorContainer.withOpacity(0.8)
            : colorScheme.onSurface.withOpacity(0.8);

    // Use Card.filled for consistent styling, applying the conditional color
    return Card.filled(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      color: cardColor, // Apply conditional background color
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildHighlightedText(
                text: '/${item.id}/',
                style: textTheme.titleLarge!.copyWith(
                  color: idColor, // Apply conditional ID color
                  fontWeight: FontWeight.bold,
                ),
                highlightQuery: highlightQuery,
                highlightColor:
                    colorScheme
                        .tertiaryContainer, // Highlight color can stay consistent
              ),
              const SizedBox(height: 4),
              _buildHighlightedText(
                text: item.title,
                style: textTheme.bodyMedium!.copyWith(
                  color: titleColor, // Apply conditional title color
                ),
                highlightQuery: highlightQuery,
                highlightColor: colorScheme.tertiaryContainer,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHighlightedText({
    required String text,
    required TextStyle style,
    required String? highlightQuery,
    required Color highlightColor,
    int maxLines = 1,
  }) {
    if (highlightQuery == null || highlightQuery.isEmpty) {
      return Text(
        text,
        style: style,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
      );
    }

    final List<InlineSpan> spans = [];
    final RegExp regex = RegExp(
      RegExp.escape(highlightQuery),
      caseSensitive: false,
    );
    int lastMatchEnd = 0;

    for (final Match match in regex.allMatches(text)) {
      if (match.start > lastMatchEnd) {
        spans.add(
          TextSpan(
            text: text.substring(lastMatchEnd, match.start),
            style: style,
          ),
        );
      }
      spans.add(
        TextSpan(
          text: text.substring(match.start, match.end),
          style: style.copyWith(
            backgroundColor: highlightColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastMatchEnd), style: style));
    }

    return RichText(
      text: TextSpan(children: spans),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}
