import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibechan/core/utils/time_utils.dart';
import 'package:vibechan/features/hackernews/data/models/hacker_news_item.dart';
import 'package:vibechan/shared/widgets/html_renderer/simple_html_renderer.dart';

/// Widget to display the header section of a HackerNews item (story or comment OP).
class HnItemHeader extends StatelessWidget {
  final HackerNewsItem item;
  final String? searchQuery;

  const HnItemHeader({super.key, required this.item, this.searchQuery});

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
          DefaultTextStyle(
            style: theme.textTheme.bodyMedium!.copyWith(
              color: theme.textTheme.bodyMedium!.color?.withOpacity(0.8),
            ),
            child: Row(
              children: [
                if (item.score != null) ...[
                  Icon(
                    Icons.arrow_upward_rounded,
                    size: 16,
                    color: theme.colorScheme.secondary,
                  ),
                  const SizedBox(width: 3),
                  Text('${item.score}'),
                  const SizedBox(width: 12),
                ],
                if (item.by != null) ...[
                  Icon(Icons.person_outline_rounded, size: 16),
                  const SizedBox(width: 3),
                  Text(item.by!),
                  const SizedBox(width: 12),
                ],
                if (item.time != null) ...[
                  Icon(Icons.access_time_rounded, size: 16),
                  const SizedBox(width: 3),
                  Text(
                    formatTimeAgoSimple(
                      DateTime.fromMillisecondsSinceEpoch(item.time! * 1000),
                    ),
                  ),
                ],
                const Spacer(), // Pushes comments to the right
                if (item.descendants != null) ...[
                  Icon(Icons.comment_outlined, size: 16),
                  const SizedBox(width: 3),
                  Text('${item.descendants}'),
                ],
              ],
            ),
          ),

          // Separator before text/body
          if (item.text != null && item.text!.isNotEmpty)
            const Divider(height: 24, thickness: 0.5),

          // Display item text if it exists (using HTML renderer)
          if (item.text != null && item.text!.isNotEmpty)
            SimpleHtmlRendererImpl(
              htmlString: item.text!,
              baseStyle: theme.textTheme.bodyLarge,
              highlightTerms: searchQuery,
              highlightColor: theme.colorScheme.primaryContainer.withOpacity(
                0.5,
              ),
              // Add onQuoteLink if needed in the future
            ),
        ],
      ),
    );
  }
}
