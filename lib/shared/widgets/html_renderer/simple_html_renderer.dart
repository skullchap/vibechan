import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibechan/core/utils/string_highlighter.dart';

import 'html_processor.dart';

/// A stateless widget that renders a limited subset of HTML using RichText.
///
/// Supports: <p>, <a>, <strong>, <em>, <code>, <br>, <ul>, <ol>, <li>
/// Ignores other tags. Does not support CSS or complex layouts.
class SimpleHtmlRendererImpl extends ConsumerWidget {
  final String htmlString;
  final TextStyle? baseStyle;
  final int? maxLines;
  final TextOverflow? overflow;
  final String? highlightTerms;
  final Color? highlightColor;
  final Function(String)? onQuoteLink;

  const SimpleHtmlRendererImpl({
    super.key,
    required this.htmlString,
    this.baseStyle,
    this.maxLines,
    this.overflow,
    this.highlightTerms,
    this.highlightColor,
    this.onQuoteLink,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultStyle = baseStyle ?? Theme.of(context).textTheme.bodyMedium;

    // Parse HTML first
    final List<InlineSpan> spans = parseHtml(
      context,
      htmlString,
      defaultStyle,
      onQuoteLink,
    );

    // Apply highlighting to TextSpans after parsing
    final finalSpans =
        (highlightTerms != null && highlightTerms!.isNotEmpty)
            ? spans.map((span) {
              if (span is TextSpan && span.text != null) {
                // Rebuild the span with highlighting applied to its text
                return buildHighlightedTextSpan(
                  span.text!,
                  span.style ?? defaultStyle,
                  highlightTerms!,
                  highlightColor ??
                      Theme.of(context).colorScheme.tertiaryContainer,
                );
              }
              // Return other spans (like WidgetSpan or non-text TextSpans) as is
              return span;
            }).toList()
            : spans;

    return Text.rich(
      TextSpan(children: finalSpans),
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
