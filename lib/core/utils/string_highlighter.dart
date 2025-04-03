import 'package:flutter/material.dart';

/// Creates a TextSpan with search terms highlighted.
///
/// Takes a [text] string, a base [style], the [searchTerms] string
/// (space-separated), and a [highlightColor].
/// Returns a TextSpan with matched terms highlighted.
TextSpan buildHighlightedTextSpan(
  String text,
  TextStyle? style,
  String searchTerms,
  Color highlightColor,
) {
  if (searchTerms.isEmpty || text.isEmpty) {
    return TextSpan(text: text, style: style);
  }

  final List<InlineSpan> spans = [];
  final RegExp regExp = RegExp(
    searchTerms
        .split(' ')
        .where((term) => term.isNotEmpty)
        .map((term) => RegExp.escape(term))
        .join('|'),
    caseSensitive: false,
  );

  int lastMatchEnd = 0;
  for (final match in regExp.allMatches(text)) {
    // Add text before the match
    if (match.start > lastMatchEnd) {
      spans.add(
        TextSpan(text: text.substring(lastMatchEnd, match.start), style: style),
      );
    }

    // Add the highlighted match
    spans.add(
      TextSpan(
        text: text.substring(match.start, match.end),
        style: style?.copyWith(
          backgroundColor: highlightColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    lastMatchEnd = match.end;
  }

  // Add remaining text after the last match
  if (lastMatchEnd < text.length) {
    spans.add(TextSpan(text: text.substring(lastMatchEnd), style: style));
  }

  // If no spans were generated (e.g., no matches), return the original text
  if (spans.isEmpty) {
    return TextSpan(text: text, style: style);
  }

  return TextSpan(children: spans);
}
