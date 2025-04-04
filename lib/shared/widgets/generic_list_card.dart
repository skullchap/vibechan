import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For Clipboard
import 'package:share_plus/share_plus.dart'; // For sharing
import 'package:url_launcher/url_launcher.dart'; // For launching URLs
import 'package:vibechan/core/di/injection.dart'; // For getIt
import 'package:vibechan/core/services/download_service.dart'; // Import DownloadService
import 'package:logger/logger.dart'; // Import Logger
import 'package:cross_file/cross_file.dart'; // Import XFile for sharing
// Assume these services exist and are registered with get_it
// import 'package:vibechan/core/services/url_launcher_service.dart';
// import 'package:vibechan/core/services/clipboard_service.dart';
// import 'package:vibechan/core/services/share_service.dart';
// import 'package:vibechan/core/services/voting_service.dart';
// import 'package:vibechan/core/services/favorites_service.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vibechan/features/fourchan/domain/models/generic_list_item.dart';
import 'package:vibechan/shared/widgets/simple_html_renderer.dart';
import 'package:vibechan/core/utils/time_utils.dart';

// Placeholder for video widget if needed later
// import 'package:vibechan/features/thread/presentation/widgets/post_video.dart';

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
            if (hasMedia) _buildMediaSection(context, displayImageUrl),
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: _buildMetadataRow(context)),
                      _buildOverflowMenu(context),
                    ],
                  ),
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
      // Format timestamp nicely using our utility function
      metadataWidgets.add(
        _metadataItem(
          context,
          Icons.access_time,
          formatTimestamp(item.timestamp, useShortFormat: true),
        ),
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

  Widget _buildOverflowMenu(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: colorScheme.outline.withOpacity(0.5)),
      ),
      child: PopupMenuButton<String>(
        icon: Icon(
          Icons.more_vert,
          color: colorScheme.onSurfaceVariant,
          size: 20,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        tooltip: 'More options',
        position: PopupMenuPosition.over,
        offset: const Offset(-50.0, -60.0),
        itemBuilder: (context) => _buildMenuItems(context),
        onSelected: (value) => _handleMenuSelection(context, value),
      ),
    );
  }

  List<PopupMenuEntry<String>> _buildMenuItems(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final List<PopupMenuEntry<String>> items = [];

    // Media-related options
    if (item.mediaUrl != null) {
      items.add(
        PopupMenuItem<String>(
          value: 'save_media',
          child: Row(
            children: [
              Icon(Icons.download, color: colorScheme.primary, size: 20),
              const SizedBox(width: 12),
              const Text('Save Media'),
            ],
          ),
        ),
      );
    }

    // Common options for all sources
    items.add(
      PopupMenuItem<String>(
        value: 'share',
        child: Row(
          children: [
            Icon(Icons.share, color: colorScheme.primary, size: 20),
            const SizedBox(width: 12),
            const Text('Share'),
          ],
        ),
      ),
    );

    // Source-specific options
    switch (item.source) {
      case ItemSource.hackernews:
        items.add(
          PopupMenuItem<String>(
            value: 'upvote',
            child: Row(
              children: [
                Icon(Icons.arrow_upward, color: colorScheme.primary, size: 20),
                const SizedBox(width: 12),
                const Text('Upvote'),
              ],
            ),
          ),
        );
        break;
      case ItemSource.lobsters:
        items.add(
          PopupMenuItem<String>(
            value: 'upvote',
            child: Row(
              children: [
                Icon(Icons.arrow_upward, color: colorScheme.primary, size: 20),
                const SizedBox(width: 12),
                const Text('Upvote'),
              ],
            ),
          ),
        );
        break;
      case ItemSource.fourchan:
        // 4chan-specific options
        break;
      case ItemSource.reddit:
        // Reddit-specific options
        items.add(
          PopupMenuItem<String>(
            value: 'upvote',
            child: Row(
              children: [
                Icon(Icons.arrow_upward, color: colorScheme.primary, size: 20),
                const SizedBox(width: 12),
                const Text('Upvote'),
              ],
            ),
          ),
        );
        items.add(
          PopupMenuItem<String>(
            value: 'downvote',
            child: Row(
              children: [
                Icon(
                  Icons.arrow_downward,
                  color: colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                const Text('Downvote'),
              ],
            ),
          ),
        );
        break;
    }

    // Add "Open in Browser" option for all sources
    items.add(
      PopupMenuItem<String>(
        value: 'open_in_browser',
        child: Row(
          children: [
            Icon(Icons.open_in_browser, color: colorScheme.primary, size: 20),
            const SizedBox(width: 12),
            const Text('Open in Browser'),
          ],
        ),
      ),
    );

    // Add "Add to Favorites" option
    items.add(
      PopupMenuItem<String>(
        value: 'add_to_favorites',
        child: Row(
          children: [
            Icon(Icons.favorite_border, color: colorScheme.primary, size: 20),
            const SizedBox(width: 12),
            const Text('Add to Favorites'),
          ],
        ),
      ),
    );

    return items;
  }

  void _handleMenuSelection(BuildContext context, String value) async {
    // Get services from DI
    final downloadService = getIt<DownloadService>();
    final logger = getIt<Logger>(instanceName: 'AppLogger');

    // Construct URLs and data (replace with actual logic based on item source)
    // These are placeholders - needs proper logic based on item source & data
    final String itemUrl =
        item.metadata['url'] as String? ??
        'https://example.com/item/${item.id}';
    final String? mediaUrl = item.mediaUrl;
    final String mediaFilename =
        item.mediaUrl?.split('/').last ?? 'media_${item.id}.unknown';

    // Hide any previous snackbars before showing new ones
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    switch (value) {
      case 'save_media':
        if (mediaUrl == null) return;

        // Show downloading message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Checking permissions and starting download...'),
          ),
        );

        // Download the media
        bool success = await downloadService.saveMedia(mediaUrl, mediaFilename);

        // Show result message
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? 'Media saved successfully!'
                  : 'Failed to save media. Check permissions and storage.',
            ),
            action:
                success
                    ? null
                    : SnackBarAction(
                      label: 'Settings',
                      onPressed: () {
                        // Navigate to settings screen
                        Navigator.of(context).pushNamed('/settings');
                      },
                    ),
          ),
        );
        break;

      case 'share_media':
        if (mediaUrl == null) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Preparing media for sharing...')),
        );

        // Download to temporary location for sharing
        final tempFile = await downloadService.downloadMediaToTemp(
          mediaUrl,
          mediaFilename,
        );

        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        if (tempFile != null) {
          logger.i("Sharing temporary file: ${tempFile.path}");
          await Share.shareXFiles([
            XFile(tempFile.path),
          ], text: item.title ?? 'Shared Media');
        } else {
          logger.w("Failed to download media for sharing");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not share media')),
          );
        }
        break;

      case 'share':
        // Share content (title + URL)
        await Share.share(
          '${item.title ?? "Check this out"}: $itemUrl',
          subject: item.title ?? 'Shared Item',
        );
        break;

      case 'upvote':
        // TODO: Call VotingService
        // bool success = await votingService.vote(item.id, item.source, VoteType.up);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Upvote: Not implemented yet')),
        );
        break;

      case 'downvote':
        // TODO: Call VotingService (only for sources that support it, like Reddit)
        // if (item.source == ItemSource.reddit) {
        //   bool success = await votingService.vote(item.id, item.source, VoteType.down);
        // }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Downvote: Not implemented yet')),
        );
        break;

      case 'open_in_browser':
        final url = Uri.parse(itemUrl);
        try {
          if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
            throw 'Could not launch $url';
          }
        } catch (e) {
          logger.e("Could not launch URL: $itemUrl", error: e);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Could not open link: $e')));
        }
        break;

      case 'add_to_favorites':
        // TODO: Call FavoritesService
        // await favoritesService.addItem(item);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Add to Favorites: Not implemented yet'),
          ),
        );
        break;
    }
  }
}
