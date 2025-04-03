import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';

import 'list_context.dart';
import 'text_highlight.dart';

/// Parses HTML string into a list of InlineSpan objects
List<InlineSpan> parseHtml(
  String htmlData,
  TextStyle defaultStyle,
  String? highlightTerms,
  Color highlightColor,
) {
  final List<InlineSpan> spans = [];
  final document = parse(htmlData);
  final List<GestureRecognizer> recognizers = [];

  void processNode(
    dom.Node node,
    List<InlineSpan> currentSpans,
    TextStyle currentStyle,
    List<ListContext> listStack,
  ) {
    if (node is dom.Text) {
      // Add non-empty text nodes
      if (node.text.trim().isNotEmpty) {
        if (highlightTerms != null && highlightTerms.isNotEmpty) {
          // Highlight terms in the text
          final highlightedSpans = getHighlightedSpans(
            node.text,
            currentStyle,
            highlightTerms,
            highlightColor,
          );
          currentSpans.addAll(highlightedSpans);
        } else {
          currentSpans.add(TextSpan(text: node.text, style: currentStyle));
        }
      }
    } else if (node is dom.Element) {
      TextStyle newStyle = currentStyle;
      String? linkHref;
      List<ListContext> nextListStack = List.from(listStack);
      bool isListItem = false;

      switch (node.localName) {
        case 'p':
          // Add paragraph spacing
          if (currentSpans.isNotEmpty) {
            // Check the last non-empty span
            final lastMeaningfulSpan = currentSpans.reversed.firstWhere(
              (s) => !(s is TextSpan && s.text?.trim().isEmpty == true),
              orElse: () => const TextSpan(),
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
            fontSize: (currentStyle.fontSize ?? 14) * 0.9,
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
          nextListStack.add(ListContext(node.localName!));
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
            // List item outside of a list? Treat as paragraph.
            currentSpans.add(const TextSpan(text: '\n\n'));
          }
          break;
      }

      // Process child nodes
      List<InlineSpan> childrenSpans = [];
      for (final child in node.nodes) {
        processNode(child, childrenSpans, newStyle, nextListStack);
      }

      // Handle links specially
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

        // Apply the recognizer and link style to the children spans
        currentSpans.add(
          TextSpan(
            children: childrenSpans,
            recognizer: recognizer,
            style: newStyle,
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
            !lastMeaningfulSpan.text!.endsWith('\n\n')) {
          currentSpans.add(const TextSpan(text: '\n\n'));
        }
      }
    }
  }

  // Process all child nodes of the document body
  processNode(document.body!, spans, defaultStyle, []);

  // Clean up recognizers when not in use
  for (final recognizer in recognizers) {
    recognizer.dispose();
  }

  return spans;
}
