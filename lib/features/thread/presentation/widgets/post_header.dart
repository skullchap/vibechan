import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibechan/core/utils/string_highlighter.dart';
import '../../../../core/domain/models/post.dart';
import '../../../../core/domain/models/generic_list_item.dart';

class PostHeader extends StatelessWidget {
  final Post post;
  final bool isOriginalPost;
  final String? highlightQuery;

  const PostHeader({
    super.key,
    required this.post,
    this.isOriginalPost = false,
    this.highlightQuery,
  });

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  String _generateShareableText() {
    final StringBuffer buffer = StringBuffer();

    // Add subject if available
    if (post.subject != null && post.subject!.isNotEmpty) {
      buffer.writeln(post.subject);
    }

    // Add name and ID
    buffer.write('Posted by ${post.name ?? 'Anonymous'}');
    if (post.posterId != null) {
      buffer.write(' (ID: ${post.posterId})');
    }
    buffer.writeln();

    // Add post ID
    buffer.write('Post #${post.id}');

    // Add source URL if available
    final sourceUrl = _getSourceUrl();
    if (sourceUrl != null) {
      buffer.write('\n$sourceUrl');
    }

    return buffer.toString();
  }

  String? _getSourceUrl() {
    switch (post.source) {
      case ItemSource.fourchan:
        return 'https://boards.4channel.org/${post.boardId}/thread/${post.threadId}#p${post.id}';
      case ItemSource.hackernews:
        return 'https://news.ycombinator.com/item?id=${post.id}';
      case ItemSource.lobsters:
        return 'https://lobste.rs/s/${post.id}';
      case ItemSource.reddit:
        return null; // TODO: Implement Reddit URL format
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final smallTextStyle = theme.textTheme.bodySmall;
    final boldSmallTextStyle = smallTextStyle?.copyWith(
      fontWeight: FontWeight.bold,
    );
    final tripcodeStyle = smallTextStyle?.copyWith(
      color: Colors.green.shade700,
    );
    final subjectStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.bold,
    );

    // Format the timestamp manually as MM/dd/yy
    final dt = post.timestamp;
    final year = dt.year.toString().substring(2); // Get last two digits of year
    final month = dt.month.toString().padLeft(2, '0');
    final day = dt.day.toString().padLeft(2, '0');
    final formattedDate = '$month/$day/$year';

    // Check if highlighting should be applied
    final shouldHighlight =
        highlightQuery != null && highlightQuery!.isNotEmpty;

    final sourceUrl = _getSourceUrl();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8.0,
        runSpacing: 4.0,
        children: [
          // Subject with optional highlighting (Moved earlier if OP)
          if (isOriginalPost &&
              post.subject != null &&
              post.subject!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(
                bottom: 4.0,
              ), // Add spacing below subject
              child: Text.rich(
                buildHighlightedTextSpan(
                  post.subject!,
                  subjectStyle,
                  shouldHighlight ? highlightQuery! : '',
                  colorScheme.tertiaryContainer,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

          // Name with optional highlighting
          Text.rich(
            buildHighlightedTextSpan(
              post.name ?? 'Anonymous',
              boldSmallTextStyle,
              shouldHighlight ? highlightQuery! : '',
              colorScheme.tertiaryContainer,
            ),
          ),

          // Tripcode
          if (post.tripcode != null) Text(post.tripcode!, style: tripcodeStyle),

          // Poster ID
          if (post.posterId != null)
            Text('(ID: ${post.posterId})', style: smallTextStyle),

          // Country Flag/Name (Placeholder icon)
          if (post.countryCode != null || post.countryName != null)
            Tooltip(
              message:
                  post.countryName ?? post.countryCode ?? 'Unknown Country',
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(width: 4), // Spacing before flag
                  Icon(
                    Icons.flag,
                    size: smallTextStyle?.fontSize ?? 12,
                    color: smallTextStyle?.color,
                  ),
                  if (post.countryCode != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 2.0),
                      child: Text(post.countryCode!, style: smallTextStyle),
                    ),
                ],
              ),
            ),

          // Post ID (No.)
          Text(
            'No. ${post.id}',
            style: smallTextStyle,
          ), // Changed prefix to No.
          // Timestamp
          Text(formattedDate, style: smallTextStyle),

          // Subject (Moved for non-OP posts)
          if (!isOriginalPost &&
              post.subject != null &&
              post.subject!.isNotEmpty)
            Text.rich(
              buildHighlightedTextSpan(
                post.subject!,
                subjectStyle,
                shouldHighlight ? highlightQuery! : '',
                colorScheme.tertiaryContainer,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

          // Action buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Share button
              IconButton(
                icon: Icon(
                  Icons.share,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                tooltip: 'Share Post',
                onPressed: () {
                  Share.share(_generateShareableText());
                },
              ),
              // Open in browser button
              if (sourceUrl != null)
                IconButton(
                  icon: Icon(
                    Icons.open_in_browser,
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  tooltip: 'Open in Browser',
                  onPressed: () => _launchUrl(sourceUrl),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
