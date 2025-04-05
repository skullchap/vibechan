import 'package:flutter/material.dart';
import 'package:vibechan/core/utils/time_utils.dart';
import 'package:vibechan/features/reddit/domain/models/reddit_comment.dart';
import 'package:vibechan/shared/enums/news_source.dart';
import 'package:vibechan/shared/widgets/simple_html_renderer.dart';

// Helper function to decode basic HTML entities
String _decodeHtmlEntities(String text) {
  return text
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&amp;', '&')
      .replaceAll('&quot;', '"')
      .replaceAll('&#39;', '\'')
      // Add more replacements if needed (e.g., &nbsp;)
      .replaceAll('&nbsp;', ' ');
}

class NewsCommentItem extends StatelessWidget {
  final dynamic comment;
  final NewsSource source;
  final ThemeData theme;
  final Color marginColor;
  final String? searchQuery;

  const NewsCommentItem({
    required this.comment,
    required this.source,
    required this.theme,
    required this.marginColor,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Left margin indicator
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          width: 4,
          child: Container(color: marginColor),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Comment header with author and time
              Row(
                children: [
                  Text(
                    _getCommentAuthor(comment, source),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    formatTimeAgoSimple(_getCommentTimestamp(comment, source)),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall!.color?.withOpacity(0.7),
                    ),
                  ),
                  if (_getCommentScore(comment, source) != null) ...[
                    const SizedBox(width: 8),
                    Icon(
                      Icons.arrow_upward_rounded,
                      size: 14,
                      color: theme.colorScheme.secondary,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${_getCommentScore(comment, source)}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              // Comment body with search highlighting
              SimpleHtmlRenderer(
                htmlString: _getCommentBody(comment, source),
                baseStyle: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
                highlightTerms: searchQuery,
                highlightColor: theme.colorScheme.secondaryContainer
                    .withOpacity(0.5),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- Helper Methods Moved from GenericNewsDetailScreen ---

  static String _getCommentAuthor(dynamic comment, NewsSource source) {
    switch (source) {
      case NewsSource.hackernews:
        return comment.by ?? 'anonymous';
      case NewsSource.lobsters:
        // Assuming comment is LobstersComment
        return comment.commentingUser ?? 'anonymous';
      case NewsSource.reddit:
        return comment.author ?? 'anonymous';
      default:
        return 'anonymous';
    }
  }

  static DateTime _getCommentTimestamp(dynamic comment, NewsSource source) {
    switch (source) {
      case NewsSource.hackernews:
        if (comment.time is int) {
          return DateTime.fromMillisecondsSinceEpoch(comment.time * 1000);
        }
        return comment.time is DateTime ? comment.time : DateTime.now();
      case NewsSource.lobsters:
        // Assuming comment is LobstersComment
        return comment.createdAt ?? DateTime.now();
      case NewsSource.reddit:
        // Assuming comment is RedditComment
        return (comment is RedditComment)
            ? comment.createdDateTime
            : DateTime.now();
      default:
        return DateTime.now();
    }
  }

  static int? _getCommentScore(dynamic comment, NewsSource source) {
    switch (source) {
      case NewsSource.hackernews:
        return null; // HN doesn't show comment scores
      case NewsSource.lobsters:
        // Assuming comment is LobstersComment
        return comment.score;
      case NewsSource.reddit:
        return comment.score;
      default:
        return null;
    }
  }

  static String _getCommentBody(dynamic comment, NewsSource source) {
    switch (source) {
      case NewsSource.hackernews:
        return comment.text ?? '';
      case NewsSource.lobsters:
        // Assuming comment is LobstersComment
        return comment.comment ?? '';
      case NewsSource.reddit:
        if (comment is RedditComment) {
          // Prioritize HTML if available and not empty
          if (comment.bodyHtml != null && comment.bodyHtml!.isNotEmpty) {
            // *** Decode HTML entities before returning ***
            return _decodeHtmlEntities(comment.bodyHtml!);
          }
          // Fallback to plain text
          return comment.body ?? '';
        }
        return '';
      default:
        return '';
    }
  }
}
