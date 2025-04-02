import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Controls the visibility of the search bar
final searchVisibleProvider = StateProvider<bool>((ref) => false);

// Stores the current search query
final searchQueryProvider = StateProvider<String>((ref) => '');

// Provider to determine if search is active (visible and non-empty query)
final isSearchActiveProvider = Provider<bool>((ref) {
  final isVisible = ref.watch(searchVisibleProvider);
  final query = ref.watch(searchQueryProvider);
  return isVisible && query.isNotEmpty;
});

// Function to highlight text based on search terms
class TextHighlighter {
  static List<TextSpan> highlightText({
    required String text,
    required String searchQuery,
    required TextStyle normalStyle,
    required TextStyle highlightStyle,
  }) {
    if (searchQuery.isEmpty) {
      return [TextSpan(text: text, style: normalStyle)];
    }

    final spans = <TextSpan>[];
    final lowercaseText = text.toLowerCase();
    final lowercaseQuery = searchQuery.toLowerCase();

    int start = 0;
    int indexOfMatch;

    while (true) {
      indexOfMatch = lowercaseText.indexOf(lowercaseQuery, start);
      if (indexOfMatch < 0) {
        if (start < text.length) {
          spans.add(TextSpan(text: text.substring(start), style: normalStyle));
        }
        break;
      }

      if (indexOfMatch > start) {
        spans.add(
          TextSpan(
            text: text.substring(start, indexOfMatch),
            style: normalStyle,
          ),
        );
      }

      spans.add(
        TextSpan(
          text: text.substring(indexOfMatch, indexOfMatch + searchQuery.length),
          style: highlightStyle,
        ),
      );

      start = indexOfMatch + searchQuery.length;
    }

    return spans;
  }
}
