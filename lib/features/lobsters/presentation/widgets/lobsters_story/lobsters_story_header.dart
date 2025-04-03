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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0), // Slightly more padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            story.title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
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
          DefaultTextStyle(
            style: theme.textTheme.bodyMedium!.copyWith(
              color: theme.textTheme.bodyMedium!.color?.withOpacity(0.8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.arrow_upward_rounded,
                  size: 16,
                  color: theme.colorScheme.secondary,
                ),
                const SizedBox(width: 3),
                Text('${story.score}'),
                const SizedBox(width: 12),
                Icon(Icons.person_outline_rounded, size: 16),
                const SizedBox(width: 3),
                Text(story.submitterUser),
                const SizedBox(width: 12),
                Icon(Icons.access_time_rounded, size: 16),
                const SizedBox(width: 3),
                Text(formatTimeAgoSimple(story.createdAt)),
              ],
            ),
          ),
          // Separator before description
          if (story.description != null && story.description!.isNotEmpty)
            const Divider(height: 24, thickness: 0.5),
          // Display description if it exists with search highlighting
          if (story.description != null && story.description!.isNotEmpty)
            SimpleHtmlRenderer(
              htmlString: story.description!,
              baseStyle: theme.textTheme.bodyLarge,
              highlightTerms: searchQuery,
              highlightColor: theme.colorScheme.primaryContainer.withOpacity(
                0.5,
              ),
            ),
          // Display tags if they exist
          if (story.tags.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: story.tags.map((tag) => TagChip(tag: tag)).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
