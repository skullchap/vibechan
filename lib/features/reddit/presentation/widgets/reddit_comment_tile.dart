import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart'; // For rendering comment body
import 'package:vibechan/core/utils/time_utils.dart'; // For timestamp formatting
import 'package:vibechan/features/reddit/domain/models/reddit_comment.dart';
// Import URL launcher if needed for links in comments
// import 'package:url_launcher/url_launcher.dart';

class RedditCommentTile extends StatelessWidget {
  final RedditComment comment;
  final int currentDepth; // Track indentation level

  const RedditCommentTile({
    super.key,
    required this.comment,
    this.currentDepth = 0,
  });

  // Max depth to indent before stopping visual indentation
  static const int _maxIndentDepth = 8;
  // Indentation size per level
  static const double _indentation = 8.0;
  // Left padding for the content itself (excluding the indent line)
  static const double _contentPaddingLeft = 8.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isDeleted = comment.isDeleted;
    final isLoadMore = comment.isLoadMorePlaceholder;

    // Calculate effective depth and padding, stopping visual indent at max depth
    final double effectiveIndentDepth =
        (currentDepth < _maxIndentDepth ? currentDepth : _maxIndentDepth)
            .toDouble();
    final double indentLinePadding = effectiveIndentDepth * _indentation;

    // TODO: Handle 'Load More' action
    if (isLoadMore) {
      return Padding(
        // Indent the 'Load More' link slightly more than content
        padding: EdgeInsets.only(
          left: indentLinePadding + _indentation / 2,
          top: 6,
          bottom: 6,
        ),
        child: InkWell(
          onTap: () {
            print("TODO: Implement Load More Comments for ${comment.id}");
            // Need to trigger an API call, likely via a provider method
            // This might involve finding the parent post provider and calling a method there.
          },
          child: Text(
            comment.body, // e.g., "[load 5 more replies]"
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    // Use a Row to combine the indent line (if needed) and the content column
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Indentation Line Column
        if (currentDepth > 0) // Only show indent line if nested
          SizedBox(
            width: indentLinePadding,
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                width: 1.5, // Width of the indent line
                margin: EdgeInsets.only(
                  right: _indentation / 2 - 1.5,
                ), // Center the line in the indent space
                color: colorScheme.outline.withOpacity(
                  0.3,
                ), // Indent line color
                // Stretch the line vertically - achieved by Column parent
              ),
            ),
          ),

        // Content Column (takes remaining space)
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              // Apply left padding only if NOT indented (depth 0) or if indent line is shown
              left: currentDepth > 0 ? _contentPaddingLeft : _indentation / 2,
              top: 4.0,
              bottom: 4.0,
              right: 4.0, // Right padding for content
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Author, Score, Timestamp
                Row(
                  children: [
                    Flexible(
                      // Allow author name to wrap if long
                      child: Text(
                        comment.author,
                        style: textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color:
                              isDeleted
                                  ? colorScheme.onSurface.withOpacity(0.6)
                                  : colorScheme.primary,
                        ),
                        overflow: TextOverflow.ellipsis, // Prevent overflow
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${comment.score} pts', // TODO: Format score?
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.secondary,
                      ),
                    ),
                    const Spacer(), // Push timestamp to the right
                    Text(
                      formatTimestamp(
                        comment.createdDateTime,
                        useShortFormat: true,
                      ),
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    // Add overflow menu for comment actions later?
                  ],
                ),
                const SizedBox(height: 4),

                // Body (Render Markdown)
                isDeleted
                    ? Text(
                      comment.body,
                      style: textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    )
                    : MarkdownBody(
                      data: comment.body,
                      selectable: true,
                      styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                        p: textTheme.bodyMedium,
                        // Add other style adjustments if needed
                      ),
                      onTapLink: (text, href, title) {
                        // Handle link taps, e.g., launch URL
                        if (href != null) {
                          // await launchUrl(Uri.parse(href));
                          print("Tapped link: $href");
                        }
                      },
                    ),

                // Recursive Replies
                if (comment.replyComments.isNotEmpty)
                  Padding(
                    // No extra padding needed here, handled by nested tile's structure
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          comment.replyComments
                              .map(
                                (reply) => RedditCommentTile(
                                  comment: reply,
                                  currentDepth:
                                      currentDepth + 1, // Increment depth
                                ),
                              )
                              .toList(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
