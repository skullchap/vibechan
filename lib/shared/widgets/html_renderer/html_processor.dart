import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';

import 'list_context.dart';

/// Parses HTML string into a list of InlineSpan objects
List<InlineSpan> parseHtml(
  BuildContext context,
  String htmlData,
  TextStyle? defaultStyle,
  Function(String)? onQuoteLink,
) {
  final List<InlineSpan> spans = [];
  final document = parse(htmlData);
  final List<GestureRecognizer> recognizers = [];
  final defaultTextStyle =
      defaultStyle ??
      Theme.of(context).textTheme.bodyMedium ??
      const TextStyle();

  void processNode(
    dom.Node node,
    List<InlineSpan> currentSpans,
    TextStyle currentStyle,
    List<ListContext> listStack,
  ) {
    if (node is dom.Text) {
      // Add non-empty text nodes
      if (node.text.trim().isNotEmpty) {
        currentSpans.add(TextSpan(text: node.text, style: currentStyle));
      }
    } else if (node is dom.Element) {
      TextStyle newStyle = currentStyle;
      String? linkHref;
      bool isQuoteLink = false;
      List<ListContext> nextListStack = List.from(listStack);
      bool isListItem = false;

      switch (node.localName) {
        case 'p':
          // Add paragraph spacing
          if (currentSpans.isNotEmpty) {
            final lastMeaningfulSpan = currentSpans.reversed.firstWhere(
              (s) => !(s is TextSpan && s.text?.trim().isEmpty == true),
              orElse: () => const TextSpan(),
            );
            if (lastMeaningfulSpan is TextSpan &&
                lastMeaningfulSpan.text?.endsWith('\n\n') != true) {
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
          final linkText = node.text;
          isQuoteLink =
              onQuoteLink != null &&
              linkHref != null &&
              linkHref.startsWith('#p');

          if (linkHref != null) {
            newStyle = newStyle.copyWith(
              color: Colors.blue.shade800, // Standard link color
              decoration: TextDecoration.underline,
              decorationColor: Colors.blue.shade800,
            );
            // Specific style for quote links (e.g., >>12345)
            if (isQuoteLink) {
              newStyle = newStyle.copyWith(
                color: Colors.green.shade700, // Quote link color
                decoration: TextDecoration.none, // No underline for quote links
              );
            }
          }
          break;
        case 'br':
          currentSpans.add(const TextSpan(text: '\n'));
          return;
        // List handling
        case 'ul':
        case 'ol':
          nextListStack.add(ListContext(node.localName!));
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
            final indentation = '  ' * (nextListStack.length - 1);
            final marker =
                (currentList.type == 'ol')
                    ? '${currentList.itemIndex}. '
                    : '• ';
            currentSpans.add(
              TextSpan(text: '\n$indentation$marker', style: currentStyle),
            );
          } else {
            currentSpans.add(const TextSpan(text: '\n\n'));
          }
          break;
      }

      // Process child nodes
      List<InlineSpan> childrenSpans = [];
      for (final child in node.nodes) {
        processNode(child, childrenSpans, newStyle, nextListStack);
      }

      // Handle links (regular and quote links)
      if (linkHref != null && childrenSpans.isNotEmpty) {
        final recognizer = TapGestureRecognizer();
        if (isQuoteLink) {
          final postId = linkHref.substring(2); // Remove "#p"
          recognizer.onTap = () => onQuoteLink!(postId);
        } else {
          recognizer.onTap = () async {
            final uri = Uri.tryParse(linkHref!); // It's known non-null here
            if (uri != null && await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            } else {
              print('Could not launch $linkHref');
            }
          };
        }
        recognizers.add(recognizer);

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
            lastMeaningfulSpan.text?.endsWith('\n\n') != true) {
          currentSpans.add(const TextSpan(text: '\n\n'));
        }
      }
    }
  }

  // Process all child nodes of the document body
  processNode(document.body!, spans, defaultTextStyle, []);

  // Clean up recognizers when not in use - moved dispose outside build
  // Consider managing recognizers lifecycle if this widget rebuilds frequently
  // for (final recognizer in recognizers) {
  //   recognizer.dispose();
  // }

  return spans;
}
