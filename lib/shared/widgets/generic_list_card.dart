import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ADD BACK for Clipboard
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibechan/core/di/injection.dart';
import 'package:vibechan/core/services/download_service.dart';
import 'package:logger/logger.dart';
// import 'package:cross_file/cross_file.dart'; // REMOVE Unused
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vibechan/features/fourchan/domain/models/generic_list_item.dart';
import 'package:vibechan/shared/widgets/simple_html_renderer.dart';
import 'package:vibechan/core/utils/time_utils.dart';
import 'package:vibechan/config/app_config.dart'; // ADD BACK for AppConfig
import 'package:get_it/get_it.dart';

// Placeholder for video widget if needed later
// import 'package:vibechan/features/thread/presentation/widgets/post_video.dart';

class GenericListCard extends StatelessWidget {
  final GenericListItem item;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool useFullMedia;
  final bool isSelected;
  final String? searchQuery; // For highlighting
  final bool isDetailView; // New flag
  final Color? highlightColor; // Color for search term highlighting

  const GenericListCard({
    super.key,
    required this.item,
    this.onTap,
    this.onLongPress,
    this.useFullMedia = false,
    this.isSelected = false,
    this.searchQuery,
    this.isDetailView = false, // Default to false
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final displayImageUrl = useFullMedia ? item.mediaUrl : item.thumbnailUrl;
    final hasMedia =
        displayImageUrl != null &&
        displayImageUrl.isNotEmpty &&
        Uri.tryParse(displayImageUrl)?.isAbsolute == true;

    return Card(
      // Removed explicit color: let Card Theme handle it or use surfaceContainerLow
      // color: cardColor,
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero, // Assume parent handles margin/padding
      child: InkWell(
        onTap: isDetailView ? null : onTap, // Disable tap in detail view
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
                    /* --- Temporarily removed highlighting --- 
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
                    */
                    Text(
                      // Use simple Text for now
                      item.title!,
                      style: textTheme.titleMedium,
                      maxLines: 2, // Allow a bit more space for titles
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                  ],
                  // ADDED Condition: Only show domain/URL if NOT in detail view
                  if (!isDetailView &&
                      item.metadata['displayUrl'] != null &&
                      item.mediaType == MediaType.none &&
                      (item.body == null || item.body!.isEmpty))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.link,
                            size: 16,
                            color: colorScheme.secondary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              item.metadata['domain'] as String? ??
                                  item.metadata['displayUrl'] as String? ??
                                  '', // Show domain if available, else full URL
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.secondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (item.body != null && item.body!.isNotEmpty)
                    // Use SimpleHtmlRenderer with highlight terms - REMOVE HIGHLIGHTING FOR NOW
                    SimpleHtmlRenderer(
                      htmlString: item.body!, // Fixed param name
                      baseStyle: textTheme.bodyMedium, // Fixed param name
                      // highlightTerms: searchQuery, // Removed
                      // highlightColor: highlightColor, // Removed
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

  Widget _buildMediaSection(BuildContext context, String mediaUrl) {
    final colorScheme = Theme.of(context).colorScheme;
    const double aspectRatio = 16 / 9;
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Container(
        color: colorScheme.surfaceContainerHighest,
        child: CachedNetworkImage(
          imageUrl: mediaUrl,
          fit: BoxFit.cover,
          placeholder:
              (context, url) => Shimmer.fromColors(
                baseColor: colorScheme.surfaceContainerHighest,
                highlightColor: colorScheme.onSurfaceVariant.withAlpha(
                  (255 * 0.1).round(),
                ),
                child: Container(color: colorScheme.surfaceContainerHighest),
              ),
          errorWidget:
              (context, url, error) =>
                  const Center(child: Icon(Icons.broken_image)),
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
        metadataWidgets = _buildRedditMetadata(context);
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

  List<Widget> _buildRedditMetadata(BuildContext context) {
    final score = item.metadata['score'] as int?;
    final comments = item.metadata['numComments'] as int?;
    final author = item.metadata['author'] as String?;
    final subreddit = item.metadata['subreddit'] as String?;
    // TODO: Add flair display?

    List<Widget> widgets = [];

    if (score != null) {
      // Use a different icon for score potentially?
      widgets.add(_metadataItem(context, Icons.trending_up, score.toString()));
    }
    if (comments != null) {
      widgets.add(
        _metadataItem(
          context,
          Icons.mode_comment_outlined,
          comments.toString(),
        ),
      );
    }
    if (author != null && author != '[deleted]') {
      widgets.add(_metadataItem(context, Icons.person_outline, author));
    }
    if (subreddit != null) {
      // Could make this tappable later to navigate to the subreddit
      widgets.add(
        _metadataItem(context, Icons.subtitles_outlined, 'r/$subreddit'),
      );
    }

    return widgets;
  }

  Widget _metadataItem(BuildContext context, IconData icon, String text) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: colorScheme.onSurfaceVariant.withAlpha((255 * 0.7).round()),
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
        border: Border.all(
          color: colorScheme.outline.withAlpha((255 * 0.5).round()),
        ),
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
    final logger = GetIt.instance<Logger>(instanceName: "AppLogger");
    final downloadService = GetIt.instance<DownloadService>();
    // Assume services are available via getIt
    // final urlLauncher = getIt<UrlLauncherService>();
    // final clipboard = getIt<ClipboardService>();
    // final share = getIt<ShareService>();
    // final voting = getIt<VotingService>();
    // final favorites = getIt<FavoritesService>();

    // Define target URL based on item source and metadata
    String? targetUrl;
    if (item.source == ItemSource.hackernews ||
        item.source == ItemSource.lobsters) {
      targetUrl =
          item.metadata['url'] as String? ??
          item.metadata['commentsUrl'] as String?;
    } else if (item.source == ItemSource.reddit) {
      // Use permalink for Reddit posts
      targetUrl =
          item.metadata['permalink'] != null
              ? 'https://www.reddit.com${item.metadata['permalink']}'
              : item.mediaUrl;
    } else {
      targetUrl = item.mediaUrl; // Fallback for other types like 4chan media
    }

    final String shareText = item.title ?? 'Check this out';
    final String shareSubject = item.title ?? AppConfig.appName;
    final String? shareUrl = targetUrl;

    switch (value) {
      case 'save_media':
        if (item.mediaUrl != null) {
          try {
            // Use correct method: saveMedia
            // Generate a filename (this could be improved)
            final suggestedFilename = item.mediaUrl!.split('/').last;
            final success = await downloadService.saveMedia(
              item.mediaUrl!,
              suggestedFilename,
            );
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(success ? 'Media saved!' : 'Download failed'),
              ),
            );
          } catch (e) {
            logger.e('Error saving media: $e');
            if (!context.mounted) return;
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Error saving media')));
          }
        }
        break;
      case 'share':
        if (shareUrl != null) {
          // If it's media, try sharing the file directly if possible/downloaded
          if (item.mediaUrl != null) {
            // For simplicity, just share the URL for now.
            // File sharing would require downloading first.
            await Share.share('$shareText\n$shareUrl', subject: shareSubject);
          } else {
            await Share.share('$shareText\n$shareUrl', subject: shareSubject);
          }
        }
        break;
      case 'open_in_browser':
        if (targetUrl != null) {
          final uri = Uri.tryParse(targetUrl);
          if (uri != null && await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } else {
            logger.w('Could not launch URL: $targetUrl');
            // Add mounted check before showing SnackBar
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Could not open URL: $targetUrl')),
            );
          }
        }
        break;
      case 'copy_link':
        if (targetUrl != null) {
          // Use Clipboard
          await Clipboard.setData(ClipboardData(text: targetUrl));
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Link copied to clipboard')),
          );
        }
        break;
      case 'upvote':
      case 'downvote':
        // TODO: Call VotingService (only for sources that support it, like Reddit)
        logger.w('Voting action ($value) not implemented yet.');
        break;
      case 'add_favorite':
      case 'remove_favorite':
        // TODO: Call FavoritesService
        logger.w('Favorite action ($value) not implemented yet.');
        break;
    }
  }
}
