import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';

// Define helper class outside the method
class _ListContext {
  final String type; // 'ul', 'ol'
  int itemIndex = 0;
  _ListContext(this.type);
}

/// A simple widget to render a limited subset of HTML using RichText.
///
/// Supports: <p>, <a>, <strong>, <em>, <code>, <br>, <ul>, <ol>, <li>
/// Ignores other tags. Does not support CSS or complex layouts.
class SimpleHtmlRenderer extends StatelessWidget {
  final String htmlString;
  final TextStyle? baseStyle;
  final int? maxLines;
  final TextOverflow overflow;

  const SimpleHtmlRenderer({
    super.key,
    required this.htmlString,
    this.baseStyle,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = baseStyle ?? DefaultTextStyle.of(context).style;
    final spans = _parseHtml(htmlString, defaultStyle);

    return Text.rich(
      TextSpan(children: spans),
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  List<InlineSpan> _parseHtml(String htmlData, TextStyle defaultStyle) {
    final List<InlineSpan> spans = [];
    final document = parse(htmlData);
    final List<GestureRecognizer> recognizers = [];

    void processNode(
      dom.Node node,
      List<InlineSpan> currentSpans,
      TextStyle currentStyle,
      // Use the top-level _ListContext class
      List<_ListContext> listStack,
    ) {
      if (node is dom.Text) {
        // Add non-empty text nodes
        if (node.text.trim().isNotEmpty) {
          currentSpans.add(TextSpan(text: node.text, style: currentStyle));
        }
      } else if (node is dom.Element) {
        TextStyle newStyle = currentStyle;
        String? linkHref;
        // Use _ListContext
        List<_ListContext> nextListStack = List.from(listStack);
        bool isListItem = false;

        switch (node.localName) {
          case 'p':
            // Add paragraph spacing only if the span list is not empty and the last element isn't already a double newline
            if (currentSpans.isNotEmpty) {
              // Check the last non-empty span
              final lastMeaningfulSpan = currentSpans.reversed.firstWhere(
                (s) => !(s is TextSpan && s.text?.trim().isEmpty == true),
                orElse:
                    () =>
                        const TextSpan(), // Return dummy if list is effectively empty
              );
              if (lastMeaningfulSpan is TextSpan &&
                  lastMeaningfulSpan.text?.endsWith('\n\n') == false) {
                currentSpans.add(const TextSpan(text: '\n\n'));
              }
            }
            break;
          case 'strong':
          case 'b':
            newStyle = newStyle.copyWith(fontWeight: FontWeight.bold);
            break;
          case 'em':
          case 'i':
            newStyle = newStyle.copyWith(fontStyle: FontStyle.italic);
            break;
          case 'code':
            newStyle = newStyle.copyWith(
              fontFamily: 'monospace',
              backgroundColor: Colors.black.withOpacity(0.08),
              fontSize:
                  (currentStyle.fontSize ?? 14) *
                  0.9, // Slightly smaller for code
            );
            break;
          case 'a':
            linkHref = node.attributes['href'];
            if (linkHref != null) {
              newStyle = newStyle.copyWith(
                color: Colors.blue.shade800,
                decoration: TextDecoration.underline,
                decorationColor: Colors.blue.shade800,
              );
            }
            break;
          case 'br':
            currentSpans.add(const TextSpan(text: '\n'));
            return;
          // List handling
          case 'ul':
          case 'ol':
            // Use _ListContext
            nextListStack.add(_ListContext(node.localName!));
            // Add spacing before list if needed
            if (currentSpans.isNotEmpty &&
                !(currentSpans.last is TextSpan &&
                    (currentSpans.last as TextSpan).text!.endsWith('\n'))) {
              currentSpans.add(const TextSpan(text: '\n'));
            }
            break;
          case 'li':
            isListItem = true;
            if (nextListStack.isNotEmpty) {
              final currentList = nextListStack.last;
              currentList.itemIndex++;
              // Calculate indentation based on list depth
              final indentation = '  ' * (nextListStack.length - 1);
              final marker =
                  (currentList.type == 'ol')
                      ? '${currentList.itemIndex}. '
                      : '• ';
              // Add newline before item, indentation, and marker
              currentSpans.add(
                TextSpan(text: '\n$indentation$marker', style: currentStyle),
              );
            } else {
              // List item outside of a list? Treat as paragraph start.
              currentSpans.add(const TextSpan(text: '\n\n'));
            }
            break;
        }

        List<InlineSpan> childrenSpans = [];
        for (final child in node.nodes) {
          processNode(child, childrenSpans, newStyle, nextListStack);
        }

        if (linkHref != null && childrenSpans.isNotEmpty) {
          final recognizer =
              TapGestureRecognizer()
                ..onTap = () async {
                  final uri = Uri.tryParse(linkHref!);
                  if (uri != null && await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } else {
                    print('Could not launch $linkHref');
                  }
                };
          recognizers.add(recognizer);
          // Apply the recognizer and the link style to the children spans
          currentSpans.add(
            TextSpan(
              children: childrenSpans,
              recognizer: recognizer,
              style: newStyle, // Apply the link style here
            ),
          );
        } else {
          currentSpans.addAll(childrenSpans);
        }

        // Add spacing after paragraphs and lists
        if ((node.localName == 'p' ||
                node.localName == 'ul' ||
                node.localName == 'ol') &&
            currentSpans.isNotEmpty) {
          final lastMeaningfulSpan = currentSpans.reversed.firstWhere(
            (s) => !(s is TextSpan && s.text?.trim().isEmpty == true),
            orElse: () => const TextSpan(),
          );
          if (lastMeaningfulSpan is TextSpan &&
              lastMeaningfulSpan.text?.endsWith('\n\n') == false) {
            // Add double newline after p, single after lists (list items add their own newline)
            currentSpans.add(
              TextSpan(text: node.localName == 'p' ? '\n\n' : '\n'),
            );
          }
        }
        // Remove context when leaving list element
        if (node.localName == 'ul' || node.localName == 'ol') {
          if (nextListStack.isNotEmpty) nextListStack.removeLast();
        }
      }
    }

    if (document.body != null) {
      for (final node in document.body!.nodes) {
        // Use _ListContext
        processNode(node, spans, defaultStyle, []);
      }
    }

    // Trim leading/trailing whitespace/newlines more carefully
    if (spans.isNotEmpty && spans.first is TextSpan) {
      final firstSpan = spans.first as TextSpan;
      spans[0] = TextSpan(
        text: firstSpan.text?.trimLeft(),
        style: firstSpan.style,
        children: firstSpan.children,
        recognizer: firstSpan.recognizer,
      );
    }
    if (spans.isNotEmpty && spans.last is TextSpan) {
      final lastSpan = spans.last as TextSpan;
      spans[spans.length - 1] = TextSpan(
        text: lastSpan.text?.trimRight(),
        style: lastSpan.style,
        children: lastSpan.children,
        recognizer: lastSpan.recognizer,
      );
    }
    spans.removeWhere((s) => s is TextSpan && s.text?.isEmpty == true);

    // Although recognizers are usually managed by the framework,
    // adding explicit disposal in a StatefullWidget's dispose method would be more robust
    // if this widget were stateful. For a StatelessWidget, this is less critical.

    return spans;
  }
}
