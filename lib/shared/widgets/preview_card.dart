import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For Clipboard
import 'package:share_plus/share_plus.dart'; // For sharing
import 'package:url_launcher/url_launcher.dart'; // For launching URLs
import 'package:vibechan/core/di/injection.dart'; // For getIt
import 'package:vibechan/core/services/download_service.dart'; // Import DownloadService
import 'package:logger/logger.dart'; // Import Logger
// Import XFile for sharing
import 'package:shimmer/shimmer.dart';
import 'package:vibechan/features/fourchan/thread/presentation/widgets/post_video.dart';
import 'package:vibechan/shared/widgets/simple_html_renderer.dart';
import 'package:vibechan/shared/models/previewable_item.dart';

class GenericPreviewCard extends StatelessWidget {
  final PreviewableItem item;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final bool fullWidth;
  final bool squareAspect;
  final bool useFullMedia;
  final String? searchQuery;
  final int? orderIndex;

  const GenericPreviewCard({
    super.key,
    required this.item,
    required this.onTap,
    this.onLongPress,
    this.fullWidth = false,
    this.squareAspect = false,
    this.useFullMedia = false,
    this.searchQuery,
    this.orderIndex,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final String? mediaUrl =
        useFullMedia ? item.mediaPreviewUrl : item.thumbnailUrl;
    final double aspectRatio = item.mediaAspectRatio ?? 1.0;

    return Stack(
      children: [
        Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (mediaUrl != null)
                  Card(
                    margin: EdgeInsets.zero,
                    child: AspectRatio(
                      aspectRatio: useFullMedia ? 1 : aspectRatio,
                      child:
                          item.isVideo && item.mediaObject != null
                              ? PostVideo(
                                media: item.mediaObject!,
                                isPreview: true,
                              )
                              : Container(
                                color: colorScheme.surfaceContainerHighest,
                                child: CachedNetworkImage(
                                  imageUrl: mediaUrl,
                                  fit:
                                      useFullMedia
                                          ? BoxFit.cover
                                          : BoxFit.contain,
                                  placeholder:
                                      (context, url) => Shimmer.fromColors(
                                        baseColor:
                                            colorScheme.surfaceContainerHighest,
                                        highlightColor:
                                            colorScheme.surfaceContainerLow,
                                        child: Container(
                                          color:
                                              colorScheme
                                                  .surfaceContainerHighest,
                                        ),
                                      ),
                                  errorWidget:
                                      (context, url, error) => Center(
                                        child: Icon(
                                          Icons.broken_image_outlined,
                                          color: colorScheme.outline,
                                        ),
                                      ),
                                ),
                              ),
                    ),
                  ),

                if (!useFullMedia)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (item.subject != null) ...[
                          if (searchQuery != null && searchQuery!.isNotEmpty)
                            RichText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                children: _getHighlightedSpans(
                                  item.subject!,
                                  textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.onSurface,
                                  ),
                                  searchQuery!,
                                  colorScheme.tertiaryContainer,
                                ),
                              ),
                            )
                          else
                            Text(
                              item.subject!,
                              style: textTheme.titleMedium!.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          const SizedBox(height: 4),
                        ],
                        if (searchQuery != null &&
                            searchQuery!.isNotEmpty &&
                            item.commentSnippet != null)
                          SimpleHtmlRenderer(
                            htmlString: item.commentSnippet ?? '',
                            baseStyle: textTheme.bodyMedium!.copyWith(
                              height: 1.4,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 12,
                            highlightTerms: searchQuery,
                            highlightColor: colorScheme.tertiaryContainer,
                          )
                        else if (item.commentSnippet != null)
                          SimpleHtmlRenderer(
                            htmlString: item.commentSnippet!,
                            baseStyle: textTheme.bodyMedium!.copyWith(
                              height: 1.4,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 12,
                          ),
                        const SizedBox(height: 8),
                        if (item.stats.isNotEmpty) ...[
                          Wrap(
                            spacing: 12.0,
                            runSpacing: 4.0,
                            children:
                                item.stats.map((stat) {
                                  final statWidget = Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        stat.icon,
                                        size: 16,
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                      if (stat.value.isNotEmpty) ...[
                                        const SizedBox(width: 4),
                                        Text(
                                          stat.value,
                                          style: textTheme.bodySmall?.copyWith(
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ],
                                  );
                                  if (stat.tooltip != null) {
                                    return Tooltip(
                                      message: stat.tooltip!,
                                      child: statWidget,
                                    );
                                  } else {
                                    return statWidget;
                                  }
                                }).toList(),
                          ),
                        ],
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [_buildOverflowMenu(context)],
                        ),
                      ],
                    ),
                  ),
                if (useFullMedia)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [_buildOverflowMenu(context)],
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (orderIndex != null && orderIndex! > 0)
          Positioned(
            top: 4,
            right: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '#$orderIndex',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onTertiaryContainer,
                ),
              ),
            ),
          ),
      ],
    );
  }

  List<InlineSpan> _getHighlightedSpans(
    String text,
    TextStyle style,
    String searchTerms,
    Color highlightColor,
  ) {
    if (searchTerms.isEmpty) return [TextSpan(text: text, style: style)];

    final List<InlineSpan> result = [];
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
      if (match.start > lastMatchEnd) {
        result.add(
          TextSpan(
            text: text.substring(lastMatchEnd, match.start),
            style: style,
          ),
        );
      }
      result.add(
        TextSpan(
          text: text.substring(match.start, match.end),
          style: style.copyWith(
            backgroundColor: highlightColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
      lastMatchEnd = match.end;
    }
    if (lastMatchEnd < text.length) {
      result.add(TextSpan(text: text.substring(lastMatchEnd), style: style));
    }
    return result;
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
        itemBuilder:
            (context) => [
              if (item.mediaPreviewUrl != null) ...[
                PopupMenuItem<String>(
                  value: 'save_media',
                  child: Row(
                    children: [
                      Icon(
                        Icons.download,
                        color: colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      const Text('Save Media'),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'share_media',
                  child: Row(
                    children: [
                      Icon(
                        Icons.ios_share,
                        color: colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      const Text('Share Media'),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
              ],
              PopupMenuItem<String>(
                value: 'share_link',
                child: Row(
                  children: [
                    Icon(Icons.share, color: colorScheme.primary, size: 20),
                    const SizedBox(width: 12),
                    const Text('Share Link'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'copy_link',
                child: Row(
                  children: [
                    Icon(Icons.link, color: colorScheme.primary, size: 20),
                    const SizedBox(width: 12),
                    const Text('Copy Link'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'open_in_browser',
                child: Row(
                  children: [
                    Icon(
                      Icons.open_in_browser,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    const Text('Open in Browser'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'add_to_favorites',
                child: Row(
                  children: [
                    Icon(
                      Icons.favorite_border,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    const Text('Add to Favorites'),
                  ],
                ),
              ),
            ],
        onSelected: (value) => _handleMenuSelection(context, value),
      ),
    );
  }

  void _handleMenuSelection(BuildContext context, String value) async {
    // Get services from DI
    final downloadService = getIt<DownloadService>();
    final logger = getIt<Logger>(instanceName: 'AppLogger');

    // Construct URLs (adjust logic based on actual item properties)
    final String itemUrl =
        item.stats
                .firstWhere(
                  (s) => s.icon == Icons.link_outlined,
                  orElse: () => PreviewStatItem(icon: Icons.error, value: ''),
                )
                .value
                .isNotEmpty
            ? item.stats.firstWhere((s) => s.icon == Icons.link_outlined).value
            : 'https://example.com/item/${item.id}'; // Fallback
    final mediaUrl = item.mediaPreviewUrl;
    final mediaFilename =
        item.mediaObject?.filename ?? 'media_${item.id}.unknown';

    // Hide any previous snackbars
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
                        // Replace with your navigation logic
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
          ], text: item.subject ?? 'Shared Media');
        } else {
          logger.w("Failed to download media for sharing");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not share media')),
          );
        }
        break;
      case 'share_link':
        await Share.share(
          'Check this out: $itemUrl',
          subject: item.subject ?? 'Shared Item',
        );
        break;
      case 'copy_link':
        await Clipboard.setData(ClipboardData(text: itemUrl));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Copied link to clipboard')),
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Add to Favorites: Not implemented yet'),
          ),
        );
        break;
    }
  }
}
