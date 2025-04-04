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
/// Also detects URLs in plain text and makes them clickable.
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

  /// The color used for links. Defaults to blue.
  final Color linkColor;

  /// Whether to auto-detect URLs in plain text and make them clickable.
  final bool autoDetectUrls;

  const SimpleHtmlRenderer({
    super.key,
    required this.htmlString,
    this.baseStyle,
    this.maxLines = 1000,
    this.overflow = TextOverflow.clip,
    this.highlightTerms,
    this.highlightColor,
    this.linkColor = Colors.blue,
    this.autoDetectUrls = true,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the default style from the context if not provided.
    final defaultStyle = baseStyle ?? DefaultTextStyle.of(context).style;

    // Remove <wbr> tags before parsing
    final cleanedHtml = htmlString.replaceAll(
      RegExp(r'<[/]?wbr>', caseSensitive: false),
      '',
    );

    // Parse the HTML and generate InlineSpans.
    final spans = _parseHtml(cleanedHtml, defaultStyle);

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
    void ensureSpacingBeforeBlock() {
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
          } else if (autoDetectUrls && currentHref == null) {
            // Auto-detect URLs in plain text if not already within an <a> tag
            spans.addAll(
              _createSpansWithUrlDetection(
                textContent,
                currentStyle,
                recognizers,
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

        switch (node.localName) {
          // === Block Elements ===
          case 'p':
            ensureSpacingBeforeBlock();
            break;
          case 'ul':
          case 'ol':
            ensureSpacingBeforeBlock();
            listStack.add(_ListContext(node.localName!));
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
              // Mark as list item
            } else {
              // Treat <li> outside <ul>/<ol> like a paragraph.
              ensureSpacingBeforeBlock();
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
            // Extract href attribute
            final hrefAttr = node.attributes['href'];
            if (hrefAttr != null && hrefAttr.isNotEmpty) {
              linkHref = hrefAttr;
              // Apply link style
              newStyle = newStyle.copyWith(
                color: linkColor,
                decoration: TextDecoration.underline,
                decorationColor: linkColor,
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

  /// Detects URLs in plain text and creates separate text spans for them.
  List<InlineSpan> _createSpansWithUrlDetection(
    String text,
    TextStyle style,
    List<GestureRecognizer> recognizers,
  ) {
    if (text.isEmpty) {
      return [TextSpan(text: text, style: style)];
    }

    // Regex to find the *start* of potential URLs (http://, https://, www.)
    final urlStartRegExp = RegExp(r'(https?://|www\.)', caseSensitive: false);

    final List<InlineSpan> result = [];
    int currentSearchIndex = 0; // Track position in the text

    while (currentSearchIndex < text.length) {
      // Find the next potential URL start from the current search index
      final match = urlStartRegExp.firstMatch(
        text.substring(currentSearchIndex),
      );

      if (match == null) {
        // No more URL starts found, add the remaining text
        if (currentSearchIndex < text.length) {
          result.add(
            TextSpan(text: text.substring(currentSearchIndex), style: style),
          );
        }
        break; // Exit the loop
      }

      // Calculate the actual start index in the original string
      final matchStartIndex = currentSearchIndex + match.start;

      // Add the text segment *before* the detected URL start
      if (matchStartIndex > currentSearchIndex) {
        result.add(
          TextSpan(
            text: text.substring(currentSearchIndex, matchStartIndex),
            style: style,
          ),
        );
      }

      // --- Scan forward to find the end of the URL ---
      int urlEndIndex =
          matchStartIndex +
          match.group(0)!.length; // Start scanning after the initial pattern
      while (urlEndIndex < text.length) {
        final char = text[urlEndIndex];
        if (char == ' ' || char == '\n' || char == '<') {
          break; // Stop at whitespace or tag start
        }
        urlEndIndex++;
      }
      String potentialUrl = text.substring(matchStartIndex, urlEndIndex);
      // --- End URL Scan ---

      // --- Intelligent Trimming of Trailing Punctuation ---
      String displayText = potentialUrl;
      String urlToLaunch = potentialUrl;
      const String punctuationChars =
          '.,;!?)]}"\''; // Chars to check for trimming

      while (displayText.isNotEmpty &&
          punctuationChars.contains(displayText.characters.last)) {
        // Check character immediately *after* the potential URL in the original text
        final nextCharIndex =
            urlEndIndex; // Index right after the potential URL
        if (nextCharIndex >= text.length || // End of text
            text[nextCharIndex] == ' ' || // Space
            text[nextCharIndex] == '\n' || // Newline
            text[nextCharIndex] == '<') {
          // Start of a tag
          // Trim the last character if it's punctuation and followed by a delimiter
          displayText = displayText.substring(0, displayText.length - 1);
          urlToLaunch = displayText; // Update launch URL as well
        } else {
          // Don't trim if the punctuation is likely part of the URL path/query
          break;
        }
      }
      // --- End Trimming ---

      // Normalize URLs that start with www.
      if (urlToLaunch.toLowerCase().startsWith('www.')) {
        urlToLaunch = 'https://$urlToLaunch';
      }

      // Add the URL segment as a clickable link
      final linkStyle = style.copyWith(
        color: linkColor,
        decoration: TextDecoration.underline,
        decorationColor: linkColor,
      );

      // Check if the trimmed URL is actually launchable before adding recognizer
      final uri = Uri.tryParse(urlToLaunch);
      TapGestureRecognizer? recognizer;
      if (uri != null) {
        recognizer =
            TapGestureRecognizer()
              ..onTap = () async {
                // Use the final urlToLaunch determined after trimming/normalization
                try {
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } else {
                    debugPrint(
                      'Could not launch $urlToLaunch - Scheme not supported?',
                    );
                  }
                } catch (e) {
                  debugPrint('Error launching URL $urlToLaunch: $e');
                }
              };
        recognizers.add(recognizer); // Keep track for potential disposal
      }

      result.add(
        TextSpan(
          text: displayText, // Use the potentially trimmed text for display
          style:
              uri != null ? linkStyle : style, // Apply link style only if valid
          recognizer: recognizer, // Add recognizer only if valid
        ),
      );

      // Move the search index past the detected URL segment
      currentSearchIndex = urlEndIndex;
    }

    return result;
  }

  // --- Helper Methods ---

  /// Creates a TextSpan, potentially with a TapGestureRecognizer for links.
  InlineSpan _createTextSpan(
    String text,
    TextStyle style,
    String? href,
    List<GestureRecognizer> recognizers,
  ) {
    if (href != null && href.isNotEmpty) {
      // Create a tap recognizer for links
      final recognizer =
          TapGestureRecognizer()
            ..onTap = () async {
              final uri = Uri.tryParse(href);
              if (uri != null) {
                try {
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

      // Add to list for potential disposal
      recognizers.add(recognizer);

      // Return span with tap recognizer
      return TextSpan(text: text, style: style, recognizer: recognizer);
    } else {
      // Regular text span without a recognizer
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
