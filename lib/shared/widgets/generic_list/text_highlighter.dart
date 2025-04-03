import 'package:flutter/material.dart';

/// Builds a TextSpan with highlighted search terms.
///
/// [text] The full text string.
/// [searchQuery] The query string to highlight.
/// [highlightColor] The color for highlighting.
/// [baseStyle] The base text style.
///
/// Returns a TextSpan with matching terms highlighted.
TextSpan buildHighlightedTextSpan({
  required String text,
  required String? searchQuery,
  required Color highlightColor,
  required TextStyle? baseStyle,
}) {
  if (searchQuery == null || searchQuery.isEmpty || text.isEmpty) {
    return TextSpan(text: text, style: baseStyle);
  }

  final List<TextSpan> spans = [];
  final String lowerCaseText = text.toLowerCase();
  final String lowerCaseQuery = searchQuery.toLowerCase();
  int start = 0;

  while (start < text.length) {
    final int index = lowerCaseText.indexOf(lowerCaseQuery, start);

    if (index == -1) {
      // No more matches
      spans.add(TextSpan(text: text.substring(start), style: baseStyle));
      break;
    } else {
      // Add text before the match
      if (index > start) {
        spans.add(
          TextSpan(text: text.substring(start, index), style: baseStyle),
        );
      }
      // Add the highlighted match
      final int end = index + searchQuery.length;
      spans.add(
        TextSpan(
          text: text.substring(index, end),
          style: baseStyle?.copyWith(
            backgroundColor: highlightColor,
            // Optionally adjust font weight or other styles for highlight
            // fontWeight: FontWeight.bold,
          ),
        ),
      );
      start = end;
    }
  }

  return TextSpan(children: spans);
}
