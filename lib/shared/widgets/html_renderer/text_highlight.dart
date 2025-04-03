import 'package:flutter/material.dart';

/// Gets a list of highlighted text spans with search terms highlighted
List<InlineSpan> getHighlightedSpans(
  String text,
  TextStyle style,
  String highlightTerms,
  Color highlightColor,
) {
  final List<InlineSpan> spans = [];
  final terms = highlightTerms.toLowerCase().split(RegExp(r'\s+'));
  final normalizedText = text.toLowerCase();

  int currentIndex = 0;

  for (int i = 0; i < text.length; i++) {
    for (final term in terms) {
      if (term.isEmpty) continue;

      if (i + term.length <= text.length &&
          normalizedText.substring(i, i + term.length) == term) {
        // Add text before the match
        if (i > currentIndex) {
          spans.add(
            TextSpan(text: text.substring(currentIndex, i), style: style),
          );
        }

        // Add the highlighted match
        spans.add(
          TextSpan(
            text: text.substring(i, i + term.length),
            style: style.copyWith(
              backgroundColor: highlightColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        );

        // Move the current index past the match
        currentIndex = i + term.length;
        break;
      }
    }
  }

  // Add any remaining text after the last match
  if (currentIndex < text.length) {
    spans.add(TextSpan(text: text.substring(currentIndex), style: style));
  }

  // If no matches were found, just return the original text
  if (spans.isEmpty) {
    spans.add(TextSpan(text: text, style: style));
  }

  return spans;
}
