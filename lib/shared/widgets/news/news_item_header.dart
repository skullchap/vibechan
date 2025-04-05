import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibechan/core/utils/time_utils.dart';
import 'package:vibechan/features/lobsters/data/models/lobsters_story.dart';
import 'package:vibechan/features/reddit/domain/models/reddit_post.dart';
import 'package:vibechan/shared/enums/news_source.dart';
import 'package:vibechan/shared/widgets/simple_html_renderer.dart';

// Helper function to decode basic HTML entities (can be shared or moved later)
String _decodeHtmlEntities(String text) {
  return text
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&amp;', '&')
      .replaceAll('&quot;', '"')
      .replaceAll('&#39;', '\'')
      .replaceAll('&nbsp;', ' ');
}

class NewsItemHeader extends StatelessWidget {
  final dynamic item; // Can be HN item, LobstersStory, or RedditPost
  final NewsSource source;
  final ThemeData theme;
  final String? searchQuery;
  final Future<void> Function() onRefresh;
  final bool isRefreshing;

  const NewsItemHeader({
    super.key,
    required this.item,
    required this.source,
    required this.theme,
    required this.searchQuery,
    required this.onRefresh,
    required this.isRefreshing,
  });

  @override
  Widget build(BuildContext context) {
    // Note: For Reddit, 'item' passed here should already be the RedditPost,
    // not the tuple (RedditPost, List<RedditComment>)
    final itemData = item;
    if (itemData == null) {
      return const Card(
        child: ListTile(title: Text('Error: Invalid post data')),
      );
    }

    final url = _getItemUrl(itemData, source);
    final metadataRowWidget = DefaultTextStyle(
      style: theme.textTheme.bodyMedium!.copyWith(
        color: theme.textTheme.bodyMedium!.color?.withOpacity(0.8),
      ),
      child: Row(children: _buildMetadataRow(context, itemData, theme, source)),
    );
    final body = _getItemBody(itemData, source) ?? '';
    final tags = _getItemTags(itemData, source);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh'),
              onPressed: isRefreshing ? null : onRefresh,
            ),
            const SizedBox(width: 8),
          ],
        ),
        Card(
          elevation: 1,
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (url != null && url.isNotEmpty)
                  InkWell(
                    child: Text(
                      Uri.tryParse(url)?.host ?? 'Source Link',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    onTap: () async {
                      final uri = Uri.tryParse(url);
                      if (uri != null && await canLaunchUrl(uri)) {
                        await launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    },
                  ),
                if (url != null && url.isNotEmpty) const SizedBox(height: 12),
                metadataRowWidget,
                if (body.isNotEmpty) ...[
                  const Divider(height: 24, thickness: 0.5),
                  SimpleHtmlRenderer(
                    htmlString: body,
                    baseStyle: theme.textTheme.bodyLarge,
                    highlightTerms: searchQuery,
                    highlightColor: theme.colorScheme.primaryContainer
                        .withOpacity(0.5),
                  ),
                ],
                if (tags != null && tags.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children:
                          tags
                              .map(
                                (tag) => Chip(
                                  label: Text(tag),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
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

  // --- Helper Methods Moved from GenericNewsDetailScreen ---

  static List<Widget> _buildMetadataRow(
    BuildContext context,
    dynamic item,
    ThemeData theme,
    NewsSource source,
  ) {
    final List<Widget> widgets = [];
    final score = _getItemScore(item, source);

    if (score != null) {
      widgets.add(
        Icon(
          Icons.arrow_upward_rounded,
          size: 16,
          color: theme.colorScheme.secondary,
        ),
      );
      widgets.add(const SizedBox(width: 3));
      widgets.add(Text('$score'));
      widgets.add(const SizedBox(width: 12));
    }

    widgets.add(const Icon(Icons.person_outline_rounded, size: 16));
    widgets.add(const SizedBox(width: 3));
    widgets.add(Text(_getItemAuthor(item, source)));
    widgets.add(const SizedBox(width: 12));
    widgets.add(const Icon(Icons.access_time_rounded, size: 16));
    widgets.add(const SizedBox(width: 3));
    widgets.add(Text(formatTimeAgoSimple(_getItemTimestamp(item, source))));

    return widgets;
  }

  static String? _getItemUrl(dynamic item, NewsSource source) {
    switch (source) {
      case NewsSource.hackernews:
        return item.url;
      case NewsSource.lobsters:
        return item.url;
      case NewsSource.reddit:
        return item.url;
    }
  }

  static int? _getItemScore(dynamic item, NewsSource source) {
    switch (source) {
      case NewsSource.hackernews:
        return item.score;
      case NewsSource.lobsters:
        return item.score;
      case NewsSource.reddit:
        return item.score;
    }
  }

  static String _getItemAuthor(dynamic item, NewsSource source) {
    switch (source) {
      case NewsSource.hackernews:
        return item.by ?? 'anonymous';
      case NewsSource.lobsters:
        // Assuming item is LobstersStory based on context where this is called
        return (item is LobstersStory) ? item.submitterUser : 'anonymous';
      case NewsSource.reddit:
        return item.author ?? 'anonymous';
    }
  }

  static DateTime _getItemTimestamp(dynamic item, NewsSource source) {
    switch (source) {
      case NewsSource.hackernews:
        if (item.time is int) {
          return DateTime.fromMillisecondsSinceEpoch(item.time * 1000);
        }
        // Attempt to handle if time is already DateTime (less likely for HN API)
        return item.time is DateTime ? item.time : DateTime.now();
      case NewsSource.lobsters:
        // Assuming item is LobstersStory
        return (item is LobstersStory) ? item.createdAt : DateTime.now();
      case NewsSource.reddit:
        // Assuming item is RedditPost
        return (item is RedditPost) ? item.createdDateTime : DateTime.now();
    }
  }

  static String? _getItemBody(dynamic item, NewsSource source) {
    switch (source) {
      case NewsSource.hackernews:
        return item.text;
      case NewsSource.lobsters:
        return (item is LobstersStory) ? item.description : null;
      case NewsSource.reddit:
        if (item is RedditPost) {
          // Prioritize HTML if available and not empty
          if (item.selftextHtml != null && item.selftextHtml!.isNotEmpty) {
            // *** Decode HTML entities before returning ***
            return _decodeHtmlEntities(item.selftextHtml!);
          }
          // Fallback to plain text
          return item.selftext;
        }
        return null;
    }
  }

  static List<String>? _getItemTags(dynamic item, NewsSource source) {
    switch (source) {
      case NewsSource.hackernews:
        return null; // HN doesn't have tags
      case NewsSource.lobsters:
        // Assuming item is LobstersStory
        return (item is LobstersStory) ? item.tags : null;
      case NewsSource.reddit:
        // Reddit uses 'link_flair_text', handle potential null
        final flair = (item is RedditPost) ? item.linkFlairText : null;
        return flair != null && flair.isNotEmpty ? [flair] : null;
    }
  }
}
