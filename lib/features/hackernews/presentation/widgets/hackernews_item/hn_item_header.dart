import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibechan/core/utils/time_utils.dart';
import 'package:vibechan/features/hackernews/data/models/hacker_news_item.dart';
import 'package:vibechan/shared/widgets/simple_html_renderer.dart';

/// Widget to display the header section of a HackerNews item (story or comment OP).
class HnItemHeader extends StatelessWidget {
  final HackerNewsItem item;
  final String? searchQuery;

  const HnItemHeader({super.key, required this.item, this.searchQuery});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // External Link (if available)
          if (item.url != null && item.url!.isNotEmpty)
            InkWell(
              child: Text(
                Uri.tryParse(item.url!)?.host ??
                    item.url!, // Show domain or full URL
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              onTap: () async {
                final uri = Uri.tryParse(item.url!);
                if (uri != null && await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
            ),
          if (item.url != null && item.url!.isNotEmpty)
            const SizedBox(height: 12),

          // Title (for stories)
          if (item.title != null)
            Text(item.title!, style: theme.textTheme.titleLarge),
          if (item.title != null) const SizedBox(height: 12),

          // Metadata row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left side: Score, author, time
              Row(
                children: [
                  // Score
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_upward_rounded,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text('${item.score}', style: theme.textTheme.bodySmall),
                    ],
                  ),
                  const SizedBox(width: 12),
                  // Author
                  if (item.by != null)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.person_outline_rounded,
                          size: 16,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(item.by!, style: theme.textTheme.bodySmall),
                      ],
                    ),
                  const SizedBox(width: 12),
                  // Time
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 16,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        formatTimeAgoSimple(
                          DateTime.fromMillisecondsSinceEpoch(
                            item.time! * 1000,
                          ),
                        ),
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
              // Right side: Open in browser button
              IconButton(
                icon: Icon(
                  Icons.open_in_browser,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                tooltip: 'Open in Browser',
                onPressed:
                    () => _launchUrl(
                      'https://news.ycombinator.com/item?id=${item.id}',
                    ),
              ),
            ],
          ),
          if (item.text != null && item.text!.isNotEmpty) ...[
            const SizedBox(height: 12),
            SimpleHtmlRenderer(
              htmlString: item.text!,
              baseStyle: theme.textTheme.bodyMedium,
              highlightTerms: searchQuery,
              highlightColor: theme.colorScheme.primaryContainer.withOpacity(
                0.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
