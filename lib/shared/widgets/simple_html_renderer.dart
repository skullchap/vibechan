import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';

import 'html_renderer/simple_html_renderer.dart';

// Define helper class outside the method
class _ListContext {
  final String type; // 'ul', 'ol'
  int itemIndex = 0;
  _ListContext(this.type);
}

/// Wrapper for backward compatibility.
/// The implementation has been moved to html_renderer/simple_html_renderer.dart
/// for better code organization.
class SimpleHtmlRenderer extends StatelessWidget {
  final String htmlString;
  final TextStyle? baseStyle;
  final int? maxLines;
  final TextOverflow overflow;
  final String? highlightTerms;
  final Color? highlightColor;

  const SimpleHtmlRenderer({
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
    // Use the implementation from the refactored file
    return SimpleHtmlRendererImpl(
      htmlString: htmlString,
      baseStyle: baseStyle,
      maxLines: maxLines,
      overflow: overflow,
      highlightTerms: highlightTerms,
      highlightColor: highlightColor,
    );
  }
}
