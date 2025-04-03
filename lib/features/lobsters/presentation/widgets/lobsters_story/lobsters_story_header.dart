import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibechan/core/utils/time_utils.dart';
import 'package:vibechan/features/lobsters/data/models/lobsters_story.dart';
import 'package:vibechan/shared/widgets/simple_html_renderer.dart';
import 'package:vibechan/shared/widgets/tag_chip.dart';

class LobstersStoryHeader extends StatelessWidget {
  final LobstersStory story;
  final String? searchQuery;

  const LobstersStoryHeader({super.key, required this.story, this.searchQuery});

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
      padding: const EdgeInsets.all(16.0), // Slightly more padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  story.title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Open in browser button
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
                    () => _launchUrl('https://lobste.rs/s/${story.shortId}'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (story.url.isNotEmpty) // Show URL only if it exists
            InkWell(
              child: Text(
                Uri.tryParse(story.url)?.host ??
                    story.url, // Show host or full URL
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              onTap: () async {
                final uri = Uri.tryParse(story.url);
                if (uri != null && await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
            ),
          if (story.url.isNotEmpty) const SizedBox(height: 12),
          // Story metadata row
          Row(
            children: [
              // Score
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.arrow_upward_rounded,
                    size: 16,
                    color: theme.colorScheme.error, // Lobsters uses red
                  ),
                  const SizedBox(width: 4),
                  Text('${story.score}', style: theme.textTheme.bodySmall),
                ],
              ),
              const SizedBox(width: 12),
              // Author
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.person_outline_rounded,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(story.submitterUser, style: theme.textTheme.bodySmall),
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
                    formatTimeAgoSimple(story.createdAt),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
          if (story.tags.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: story.tags.map((tag) => TagChip(tag: tag)).toList(),
            ),
          ],
          if (story.description != null && story.description!.isNotEmpty) ...[
            const SizedBox(height: 12),
            SimpleHtmlRenderer(
              htmlString: story.description!,
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
