import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class HtmlText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow overflow;
  final TextAlign textAlign;

  const HtmlText(
    this.text, {
    super.key,
    this.style,
    this.maxLines,
    this.overflow = TextOverflow.clip,
    this.textAlign = TextAlign.start,
  });

  String _preprocessText(String text) {
    // Convert HTML line breaks to markdown
    String processed = text.replaceAll(RegExp(r'<br\s*/?>'), '\n');
    // Convert chan-style quotes to markdown quotes
    processed = processed.replaceAll(RegExp(r'^>(.+)$', multiLine: true), '> \$1');
    // Remove other HTML tags
    processed = processed.replaceAll(RegExp(r'<[^>]*>'), '');
    return processed;
  }

  @override
  Widget build(BuildContext context) {
    final processedText = _preprocessText(text);
    
    return MarkdownBody(
      data: processedText,
      styleSheet: MarkdownStyleSheet(
        p: style,
        blockquote: style?.copyWith(
          color: Colors.green,
        ),
      ),
      softLineBreak: true,
      fitContent: true,
      selectable: false,
    );
  }
}