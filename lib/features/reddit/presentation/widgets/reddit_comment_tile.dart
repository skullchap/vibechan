import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart'; // For rendering comment body
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibechan/core/utils/time_utils.dart'; // For timestamp formatting
import 'package:vibechan/features/reddit/domain/models/reddit_comment.dart';
import 'package:vibechan/features/reddit/presentation/providers/post_detail_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
// Import URL launcher if needed for links in comments
// import 'package:url_launcher/url_launcher.dart';

class RedditCommentTile extends ConsumerWidget {
  final RedditComment comment;
  final int currentDepth; // Track indentation level
  final PostDetailParams postParams; // Add params to identify the post

  const RedditCommentTile({
    super.key,
    required this.comment,
    required this.postParams,
    this.currentDepth = 0,
  });

  // Max depth to indent before stopping visual indentation
  static const int _maxIndentDepth = 8;
  // Indentation size per level
  static const double _indentation = 8.0;
  // Left padding for the content itself (excluding the indent line)
  static const double _contentPaddingLeft = 8.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    // Handle 'Load More' action
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
            final logger = GetIt.instance<Logger>(instanceName: "AppLogger");
            logger.d("Loading more comments for ${comment.id}");

            // Access the post detail provider and load more comments
            final postProvider = ref.read(postDetailProvider(postParams));

            // Since loading more comments would need to be implemented in the repository
            // and then exposed through the provider, we're just logging for now
            logger.d("Would load more comments for comment ID: ${comment.id}");

            // Example of how to refresh the post detail to get more comments
            // This would be implemented in a real app by calling repository methods
            // and updating the provider state
            ref.invalidate(postDetailProvider(postParams));
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
                color: colorScheme.outline.withAlpha(
                  (0.3 * 255).toInt(),
                ), // Fixed: replaced withOpacity with withAlpha
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
                                  ? colorScheme.onSurface.withAlpha(
                                    (0.6 * 255).toInt(),
                                  )
                                  : colorScheme.primary,
                        ),
                        overflow: TextOverflow.ellipsis, // Prevent overflow
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatScore(comment.score), // Formatted score
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
                        color: colorScheme.onSurface.withAlpha(
                          (0.6 * 255).toInt(),
                        ),
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
                          final logger = GetIt.instance<Logger>(
                            instanceName: "AppLogger",
                          );
                          logger.d("Tapped link: $href");
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
                                  postParams: postParams,
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

  // Format score with k/m suffixes if needed
  String _formatScore(int score) {
    if (score >= 1000000) {
      return '${(score / 1000000).toStringAsFixed(1)}m';
    } else if (score >= 1000) {
      return '${(score / 1000).toStringAsFixed(1)}k';
    } else {
      return '$score pts';
    }
  }
}
