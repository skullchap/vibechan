import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vibechan/core/domain/models/generic_list_item.dart';
import 'package:vibechan/shared/widgets/simple_html_renderer.dart';

import 'generic_list/generic_list_card.dart';

// Placeholder for video widget if needed later
// import 'package:vibechan/features/thread/presentation/widgets/post_video.dart';

/// Wrapper for backward compatibility.
/// The implementation has been moved to generic_list/generic_list_card.dart
/// for better code organization.
class GenericListCard extends StatelessWidget {
  final GenericListItem item;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final bool useFullMedia; // Controls whether to show thumbnail or full media
  final String? searchQuery; // Search term for highlighting
  final Color? highlightColor; // Color for search term highlighting

  const GenericListCard({
    super.key,
    required this.item,
    required this.onTap,
    this.onLongPress,
    this.useFullMedia = false,
    this.searchQuery,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    // Use the implementation from the refactored file
    return GenericListCardImpl(
      item: item,
      onTap: onTap,
      onLongPress: onLongPress,
      useFullMedia: useFullMedia,
      searchQuery: searchQuery,
      highlightColor: highlightColor,
    );
  }
}

class GenericListCardImpl extends StatelessWidget {
  final GenericListItem item;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final bool useFullMedia; // Controls whether to show thumbnail or full media
  final String? searchQuery; // Search term for highlighting
  final Color? highlightColor; // Color for search term highlighting

  const GenericListCardImpl({
    super.key,
    required this.item,
    required this.onTap,
    this.onLongPress,
    this.useFullMedia = false,
    this.searchQuery,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final displayImageUrl = useFullMedia ? item.mediaUrl : item.thumbnailUrl;
    final hasMedia = displayImageUrl != null;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasMedia) _buildMediaSection(context, displayImageUrl!),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (item.title != null && item.title!.isNotEmpty) ...[
                    // If search is active, use RichText with highlighting
                    if (searchQuery != null && searchQuery!.isNotEmpty)
                      Text.rich(
                        _buildHighlightedTextSpan(
                          item.title!,
                          textTheme.titleMedium,
                          searchQuery!,
                          highlightColor ??
                              colorScheme.primaryContainer.withOpacity(0.5),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )
                    else
                      Text(
                        item.title!,
                        style: textTheme.titleMedium,
                        maxLines: 2, // Allow a bit more space for titles
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 6),
                  ],
                  if (item.body != null && item.body!.isNotEmpty)
                    // Use SimpleHtmlRenderer with highlight terms
                    SimpleHtmlRenderer(
                      htmlString: item.body ?? '',
                      baseStyle: textTheme.bodyMedium,
                      highlightTerms: searchQuery,
                      highlightColor: highlightColor,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 8),
                  _buildMetadataRow(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to highlight text (for non-HTML content)
  TextSpan _buildHighlightedTextSpan(
    String text,
    TextStyle? style,
    String searchTerms,
    Color highlightColor,
  ) {
    if (searchTerms.isEmpty) return TextSpan(text: text, style: style);

    final List<InlineSpan> spans = [];
    final RegExp regExp = RegExp(
      searchTerms
          .split(' ')
          .where((term) => term.isNotEmpty)
          .map((term) {
            return RegExp.escape(term);
          })
          .join('|'),
      caseSensitive: false,
    );

    int lastMatchEnd = 0;
    for (final match in regExp.allMatches(text)) {
      // Add text before the match
      if (match.start > lastMatchEnd) {
        spans.add(
          TextSpan(
            text: text.substring(lastMatchEnd, match.start),
            style: style,
          ),
        );
      }

      // Add the highlighted match
      spans.add(
        TextSpan(
          text: text.substring(match.start, match.end),
          style: style?.copyWith(
            backgroundColor: highlightColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

      lastMatchEnd = match.end;
    }

    // Add remaining text after the last match
    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastMatchEnd), style: style));
    }

    return TextSpan(children: spans);
  }

  Widget _buildMediaSection(BuildContext context, String imageUrl) {
    // Basic image handling for now. Video could be added based on item.mediaType.
    // Aspect ratio might need adjustment based on source or metadata.
    final colorScheme = Theme.of(context).colorScheme;
    return AspectRatio(
      aspectRatio: 16 / 9, // Default aspect ratio, might need adjustment
      child: Container(
        color: colorScheme.surfaceVariant, // Background color while loading
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder:
              (context, url) => Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(color: Colors.white),
              ),
          errorWidget:
              (context, url, error) => Center(
                child: Icon(
                  Icons.broken_image,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
        ),
      ),
    );
  }

  Widget _buildMetadataRow(BuildContext context) {
    // Dynamically build the metadata row based on item.source and item.metadata
    List<Widget> metadataWidgets = [];

    switch (item.source) {
      case ItemSource.fourchan:
        metadataWidgets = _build4chanMetadata(context);
        break;
      case ItemSource.hackernews:
        metadataWidgets = _buildHackerNewsMetadata(context);
        break;
      case ItemSource.lobsters:
        metadataWidgets = _buildLobstersMetadata(context);
        break;
      case ItemSource.reddit:
        // Add Reddit specific metadata handling here
        break;
    }

    // Add timestamp if available
    if (item.timestamp != null) {
      // TODO: Format timestamp nicely
      metadataWidgets.add(
        _metadataItem(context, Icons.access_time, item.timestamp.toString()),
      );
    }

    if (metadataWidgets.isEmpty) {
      return const SizedBox.shrink(); // No metadata to show
    }

    // Use Wrap for flexibility if many items
    return Wrap(
      spacing: 12.0, // Horizontal space between items
      runSpacing: 4.0, // Vertical space between lines
      children: metadataWidgets,
    );
  }

  List<Widget> _build4chanMetadata(BuildContext context) {
    final replies = item.metadata['repliesCount'] as int?;
    final images = item.metadata['imagesCount'] as int?;
    final isSticky = item.metadata['isSticky'] as bool? ?? false;
    final isClosed = item.metadata['isClosed'] as bool? ?? false;

    List<Widget> widgets = [];
    if (replies != null) {
      widgets.add(_metadataItem(context, Icons.comment, replies.toString()));
    }
    if (images != null) {
      widgets.add(_metadataItem(context, Icons.image, images.toString()));
    }
    if (isSticky) {
      widgets.add(_metadataItem(context, Icons.push_pin, 'Sticky'));
    }
    if (isClosed) {
      widgets.add(_metadataItem(context, Icons.lock, 'Closed'));
    }
    return widgets;
  }

  List<Widget> _buildHackerNewsMetadata(BuildContext context) {
    final score = item.metadata['score'] as int?;
    final comments =
        item.metadata['descendants']
            as int?; // HN uses 'descendants' for comment count
    final author = item.metadata['by'] as String?;

    List<Widget> widgets = [];
    if (score != null) {
      widgets.add(_metadataItem(context, Icons.arrow_upward, score.toString()));
    }
    if (comments != null) {
      widgets.add(_metadataItem(context, Icons.comment, comments.toString()));
    }
    if (author != null) {
      widgets.add(_metadataItem(context, Icons.person, author));
    }
    // Add more HN specific data like 'type' (story, job, etc.) if needed
    return widgets;
  }

  List<Widget> _buildLobstersMetadata(BuildContext context) {
    final score = item.metadata['score'] as int?;
    final comments = item.metadata['commentsCount'] as int?;
    final author = item.metadata['submitterUser'] as String?;

    List<Widget> widgets = [];

    if (score != null) {
      widgets.add(_metadataItem(context, Icons.arrow_upward, score.toString()));
    }
    if (comments != null) {
      widgets.add(_metadataItem(context, Icons.comment, comments.toString()));
    }

    if (author != null) {
      widgets.add(_metadataItem(context, Icons.person, author));
    }

    return widgets;
  }

  Widget _metadataItem(BuildContext context, IconData icon, String text) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisSize: MainAxisSize.min, // Ensure row takes minimum space
      children: [
        Icon(
          icon,
          size: 16,
          color: colorScheme.onSurfaceVariant.withOpacity(0.7),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
