import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';
import 'dart:collection'; // For Queue

// Helper class to manage list context (type and item index) during parsing.
class _ListContext {
  final String type; // 'ul' or 'ol'
  int itemIndex = 0;
  _ListContext(this.type);
}

/// A Flutter widget that renders a limited subset of HTML content using RichText.
///
/// Supports the following tags:
/// - <p>: Paragraphs (adds vertical spacing).
/// - <a>: Links (clickable, opens externally).
/// - <strong>, <b>: Bold text.
/// - <em>, <i>: Italic text.
/// - <code>: Monospaced text with a background.
/// - <br>: Line breaks.
/// - <ul>, <ol>, <li>: Unordered and ordered lists with basic indentation.
///
/// Ignores other HTML tags and does not support CSS or complex layouts.
/// Handles text wrapping via RichText's softWrap property.
class SimpleHtmlRenderer extends StatelessWidget {
  /// The HTML string to render.
  final String htmlString;

  /// The base text style to apply. Defaults to the ambient DefaultTextStyle.
  final TextStyle? baseStyle;

  /// An optional maximum number of lines for the text to span, wrapping if necessary.
  final int maxLines;

  /// How visual overflow should be handled.
  final TextOverflow overflow;

  /// Optional space-separated search terms to highlight in the rendered text.
  final String? highlightTerms;

  /// The color used for highlighting search terms. Defaults to yellow with opacity.
  final Color? highlightColor;

  const SimpleHtmlRenderer({
    super.key,
    required this.htmlString,
    this.baseStyle,
    this.maxLines = 1000,
    this.overflow = TextOverflow.clip,
    this.highlightTerms,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the default style from the context if not provided.
    final defaultStyle = baseStyle ?? DefaultTextStyle.of(context).style;
    // Parse the HTML and generate InlineSpans.
    final spans = _parseHtml(htmlString, defaultStyle);

    // Use RichText to display the parsed spans.
    // softWrap enables text wrapping based on available width.
    // Note: Wrapping only occurs at whitespace characters. Very long words
    // without spaces may still overflow if they exceed the available width.
    return RichText(
      text: TextSpan(
        // Use the default style as the root style for the TextSpan tree.
        style: defaultStyle,
        children: spans,
      ),
      maxLines: maxLines,
      overflow: overflow,
      softWrap: true, // Explicitly enable soft wrap
    );
  }

  // --- HTML Parsing Logic ---

  List<InlineSpan> _parseHtml(String htmlData, TextStyle defaultStyle) {
    final List<InlineSpan> spans = [];
    final document = parse(htmlData);
    final body = document.body;

    if (body == null) {
      return spans; // Return empty list if no body
    }

    // Use a Queue for efficient addition/removal from the front.
    final ListQueue<dom.Node> nodeQueue = ListQueue.from(body.nodes);
    // Stack to keep track of nested list contexts.
    final List<_ListContext> listStack = [];
    // Keep track of gesture recognizers to dispose them if needed (though less critical in StatelessWidget).
    final List<GestureRecognizer> recognizers = [];

    // Helper function to add vertical spacing if needed before block elements.
    void _ensureSpacingBeforeBlock() {
      if (spans.isNotEmpty) {
        final lastSpan = spans.last;
        // Add double newline if the last span doesn't already end with one.
        if (lastSpan is TextSpan &&
            (lastSpan.text?.endsWith('\n\n') == false &&
                lastSpan.text?.endsWith('\n') == false)) {
          spans.add(const TextSpan(text: '\n\n'));
        } else if (lastSpan is TextSpan &&
            lastSpan.text?.endsWith('\n\n') == false &&
            lastSpan.text?.endsWith('\n') == true) {
          // If it ends with a single newline, add one more.
          spans.add(const TextSpan(text: '\n'));
        }
      }
    }

    // Recursively process HTML nodes.
    void processNode(
      dom.Node node,
      TextStyle currentStyle,
      String? currentHref, // Pass down href for nested elements within <a>
    ) {
      if (node is dom.Text) {
        // Replace non-breaking spaces (&nbsp;) with regular spaces to allow wrapping.
        // Also trim whitespace that might be leftover from HTML formatting,
        // but preserve internal whitespace needed for wrapping.
        final textContent = node.text.replaceAll(RegExp(r'&nbsp;|&#160;'), ' ');

        // Add text span if the content is not purely whitespace.
        if (textContent.isNotEmpty) {
          // Apply highlighting if terms are provided.
          if (highlightTerms != null && highlightTerms!.isNotEmpty) {
            spans.addAll(
              _createHighlightedSpans(
                textContent,
                currentStyle,
                highlightTerms!,
                highlightColor ?? Colors.yellow.withOpacity(0.3),
                currentHref,
                recognizers, // Pass recognizers list
              ),
            );
          } else {
            // Create a regular TextSpan.
            spans.add(
              _createTextSpan(
                textContent,
                currentStyle,
                currentHref,
                recognizers, // Pass recognizers list
              ),
            );
          }
        }
      } else if (node is dom.Element) {
        TextStyle newStyle = currentStyle;
        String? linkHref = currentHref; // Inherit href from parent <a> if any
        bool isBlockElement = false;
        bool isListItem = false;

        switch (node.localName) {
          // === Block Elements ===
          case 'p':
            _ensureSpacingBeforeBlock();
            isBlockElement = true;
            break;
          case 'ul':
          case 'ol':
            _ensureSpacingBeforeBlock();
            listStack.add(_ListContext(node.localName!));
            isBlockElement = true;
            break;
          case 'li':
            if (listStack.isNotEmpty) {
              final currentList = listStack.last;
              currentList.itemIndex++;
              // Add spacing before the list item marker if needed.
              if (spans.isNotEmpty &&
                  !(spans.last is TextSpan &&
                      (spans.last as TextSpan).text!.endsWith('\n'))) {
                spans.add(const TextSpan(text: '\n'));
              }
              // Calculate indentation based on nesting depth.
              final indentation = '  ' * (listStack.length - 1);
              final marker =
                  (currentList.type == 'ol')
                      ? '${currentList.itemIndex}. '
                      : '• '; // Bullet point for ul
              spans.add(
                TextSpan(text: '$indentation$marker', style: currentStyle),
              );
              isListItem = true; // Mark as list item
            } else {
              // Treat <li> outside <ul>/<ol> like a paragraph.
              _ensureSpacingBeforeBlock();
              isBlockElement = true;
            }
            break;

          // === Inline Elements ===
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
              fontFamily: 'monospace', // Use a monospaced font
              backgroundColor: Colors.grey.shade200,
              fontSize: (currentStyle.fontSize ?? 14) * 0.9,
            );
            break;
          case 'a':
            // Only override href if this 'a' tag has one.
            final hrefAttr = node.attributes['href'];
            if (hrefAttr != null && hrefAttr.isNotEmpty) {
              linkHref = hrefAttr;
              newStyle = newStyle.copyWith(
                color: Colors.blue.shade700, // Link color
                decoration: TextDecoration.underline,
                decorationColor: Colors.blue.shade700,
              );
            }
            break;
          case 'br':
            // Add a newline, respecting preceding/following whitespace potentially.
            spans.add(const TextSpan(text: '\n'));
            return; // <br> has no children.

          // Default: Ignore other tags like <div>, <span>, etc.
          default:
            // We simply process children with current style.
            break;
        }

        // Recursively process child nodes with the new style and potential link.
        for (final child in node.nodes) {
          processNode(child, newStyle, linkHref);
        }

        // Cleanup after processing block elements.
        if (node.localName == 'ul' || node.localName == 'ol') {
          if (listStack.isNotEmpty) {
            listStack.removeLast(); // Pop from list context stack
          }
          // Add a newline after the list if it's not followed by another block element
          // or if it's the last element. This helps separate lists from subsequent text.
          if (spans.isNotEmpty &&
              !(spans.last is TextSpan &&
                  (spans.last as TextSpan).text!.endsWith('\n'))) {
            spans.add(const TextSpan(text: '\n'));
          }
        }
        // No explicit spacing needed after </p> because the next <p> or block
        // element will add spacing *before* itself.
      }
    }

    // Process all top-level nodes in the body.
    while (nodeQueue.isNotEmpty) {
      processNode(nodeQueue.removeFirst(), defaultStyle, null);
    }

    // --- Final Cleanup ---

    // Trim leading/trailing whitespace/newlines from the entire result.
    while (spans.isNotEmpty) {
      if (spans.first is TextSpan) {
        final firstSpan = spans.first as TextSpan;
        final trimmedText = firstSpan.text?.trimLeft();
        if (trimmedText != null && trimmedText.isEmpty) {
          spans.removeAt(0); // Remove empty span
        } else if (trimmedText != firstSpan.text) {
          spans[0] = _copyTextSpan(firstSpan, text: trimmedText); // Update span
          break;
        } else {
          break; // No leading whitespace found
        }
      } else {
        break; // First element is not a TextSpan
      }
    }

    while (spans.isNotEmpty) {
      if (spans.last is TextSpan) {
        final lastSpan = spans.last as TextSpan;
        final trimmedText = lastSpan.text?.trimRight();
        if (trimmedText != null && trimmedText.isEmpty) {
          spans.removeLast(); // Remove empty span
        } else if (trimmedText != lastSpan.text) {
          spans[spans.length - 1] = _copyTextSpan(
            lastSpan,
            text: trimmedText,
          ); // Update span
          break;
        } else {
          break; // No trailing whitespace found
        }
      } else {
        break; // Last element is not a TextSpan
      }
    }

    // Note: GestureRecognizers created here should ideally be disposed.
    // In a StatefulWidget, this would be done in the dispose() method.
    // For StatelessWidget, they are typically garbage collected when the
    // widget/element/render object tree is rebuilt/removed, but explicit
    // disposal is safer practice if this were converted to StatefulWidget.
    // Example: for (final recognizer in _recognizers) { recognizer.dispose(); }

    return spans;
  }

  // --- Helper Methods ---

  /// Creates a TextSpan, potentially with a TapGestureRecognizer for links.
  InlineSpan _createTextSpan(
    String text,
    TextStyle style,
    String? href,
    List<GestureRecognizer> recognizers,
  ) {
    if (href != null) {
      final recognizer =
          TapGestureRecognizer()
            ..onTap = () async {
              final uri = Uri.tryParse(href);
              if (uri != null) {
                try {
                  // Try launching the URL externally.
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } else {
                    debugPrint(
                      'Could not launch $href - Scheme not supported?',
                    );
                  }
                } catch (e) {
                  debugPrint('Error launching URL $href: $e');
                }
              } else {
                debugPrint('Invalid URL: $href');
              }
            };
      recognizers.add(recognizer); // Keep track for potential disposal
      return TextSpan(text: text, style: style, recognizer: recognizer);
    } else {
      // Regular text span without a recognizer.
      return TextSpan(text: text, style: style);
    }
  }

  /// Creates a list of InlineSpans, highlighting search terms.
  List<InlineSpan> _createHighlightedSpans(
    String text,
    TextStyle style,
    String searchTerms,
    Color highlightColor,
    String? href, // Pass href for links
    List<GestureRecognizer> recognizers, // Pass recognizers list
  ) {
    if (searchTerms.isEmpty || text.isEmpty) {
      return [_createTextSpan(text, style, href, recognizers)];
    }

    final List<InlineSpan> result = [];
    // Create a regex to find any of the search terms (case-insensitive).
    // Split terms by space, filter empty, escape special chars, join with '|'.
    final RegExp regExp = RegExp(
      searchTerms
          .split(' ')
          .where((term) => term.isNotEmpty)
          .map(RegExp.escape) // Escape regex characters in terms
          .join('|'), // OR condition
      caseSensitive: false,
    );

    int lastMatchEnd = 0;
    final Iterable<RegExpMatch> matches = regExp.allMatches(text);

    for (final match in matches) {
      // Add text segment before the current match.
      if (match.start > lastMatchEnd) {
        result.add(
          _createTextSpan(
            text.substring(lastMatchEnd, match.start),
            style,
            href,
            recognizers,
          ),
        );
      }

      // Add the highlighted match segment.
      result.add(
        _createTextSpan(
          text.substring(match.start, match.end),
          style.copyWith(
            backgroundColor: highlightColor,
            fontWeight: FontWeight.bold, // Optionally make highlight bold
          ),
          href, // Apply link recognizer to highlighted part too
          recognizers,
        ),
      );

      lastMatchEnd = match.end;
    }

    // Add any remaining text segment after the last match.
    if (lastMatchEnd < text.length) {
      result.add(
        _createTextSpan(text.substring(lastMatchEnd), style, href, recognizers),
      );
    }

    return result;
  }

  /// Helper to create a copy of a TextSpan with optional modifications.
  /// This is needed because TextSpan is immutable.
  TextSpan _copyTextSpan(
    TextSpan original, {
    String? text,
    List<InlineSpan>? children,
    TextStyle? style,
    GestureRecognizer? recognizer,
  }) {
    return TextSpan(
      text: text ?? original.text,
      children: children ?? original.children,
      style: style ?? original.style,
      recognizer: recognizer ?? original.recognizer,
      // mouseCursor: original.mouseCursor, // Include if needed
      // onEnter: original.onEnter,         // Include if needed
      // onExit: original.onExit,          // Include if needed
      // semanticsLabel: original.semanticsLabel, // Include if needed
      // locale: original.locale,             // Include if needed
      // spellOut: original.spellOut,         // Include if needed
    );
  }
}
