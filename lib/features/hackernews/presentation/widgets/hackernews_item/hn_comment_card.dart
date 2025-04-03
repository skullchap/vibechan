import 'package:flutter/material.dart';
import 'package:vibechan/core/utils/time_utils.dart';
import 'package:vibechan/features/hackernews/data/models/hacker_news_item.dart';
import 'package:vibechan/shared/widgets/html_renderer/simple_html_renderer.dart';

/// Widget to display a single HackerNews comment with indentation.
class HnCommentCard extends StatelessWidget {
  final HackerNewsItem comment;
  final Color marginColor;
  final String? searchQuery;

  const HnCommentCard({
    super.key,
    required this.comment,
    required this.marginColor,
    this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Indentation color bar
            Container(
              width: 5.0,
              decoration: BoxDecoration(
                color: marginColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
            ),
            // Comment content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Comment metadata (author, time)
                    DefaultTextStyle(
                      style: theme.textTheme.labelMedium!.copyWith(
                        color: theme.textTheme.labelMedium!.color?.withOpacity(
                          0.7,
                        ),
                      ),
                      child: Row(
                        children: [
                          if (comment.by != null)
                            Text(
                              comment.by!,
                              style: theme.textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          const Spacer(),
                          if (comment.time != null) ...[
                            Icon(Icons.access_time_rounded, size: 14),
                            const SizedBox(width: 2),
                            Text(
                              formatTimeAgoSimple(
                                DateTime.fromMillisecondsSinceEpoch(
                                  comment.time! * 1000,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Comment body (HTML rendered)
                    if (comment.text != null && comment.text!.isNotEmpty)
                      SimpleHtmlRendererImpl(
                        htmlString: comment.text!,
                        baseStyle: theme.textTheme.bodyMedium,
                        highlightTerms: searchQuery,
                        highlightColor: theme.colorScheme.primaryContainer
                            .withOpacity(0.5),
                        // Add onQuoteLink if needed
                      ),
                    // Deleted/Dead indicators
                    if (comment.deleted)
                      Text(
                        '[deleted]',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    if (comment.dead)
                      Text(
                        '[content removed]',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
