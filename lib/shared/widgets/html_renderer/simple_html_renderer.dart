import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;

import 'text_highlight.dart';
import 'html_processor.dart';

/// A simple widget to render a limited subset of HTML using RichText.
///
/// Supports: <p>, <a>, <strong>, <em>, <code>, <br>, <ul>, <ol>, <li>
/// Ignores other tags. Does not support CSS or complex layouts.
class SimpleHtmlRendererImpl extends StatelessWidget {
  final String htmlString;
  final TextStyle? baseStyle;
  final int? maxLines;
  final TextOverflow overflow;
  final String? highlightTerms;
  final Color? highlightColor;

  const SimpleHtmlRendererImpl({
    super.key,
    required this.htmlString,
    this.baseStyle,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
    this.highlightTerms,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = baseStyle ?? DefaultTextStyle.of(context).style;
    final spans = parseHtml(
      htmlString,
      defaultStyle,
      highlightTerms,
      highlightColor ?? Colors.yellow.withOpacity(0.3),
    );

    return Text.rich(
      TextSpan(children: spans),
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
