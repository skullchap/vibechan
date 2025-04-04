import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For Clipboard
import 'package:share_plus/share_plus.dart'; // For sharing
import 'package:url_launcher/url_launcher.dart'; // For launching URLs
import 'package:vibechan/core/di/injection.dart'; // For getIt
import 'package:logger/logger.dart'; // Import Logger
import 'package:vibechan/core/services/download_service.dart'; // Import DownloadService
import 'package:cross_file/cross_file.dart'; // Import XFile for sharing

import 'package:vibechan/features/fourchan/domain/models/post.dart';
import 'post_header.dart';
import 'post_body.dart';
import 'post_media.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final bool isOriginalPost;
  final Function(String)? onQuoteLink;
  final int? orderIndex;

  const PostCard({
    super.key,
    required this.post,
    this.isOriginalPost = false,
    this.onQuoteLink,
    this.orderIndex,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Card(
              margin:
                  EdgeInsets
                      .zero, // Remove default card margin to respect grid spacing
              clipBehavior: Clip.antiAlias, // Ensure content doesn't overflow
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PostHeader(post: post, isOriginalPost: isOriginalPost),
                  PostMedia(post: post),
                  PostBody(post: post, onQuoteLink: onQuoteLink),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                      child: _buildOverflowMenu(context),
                    ),
                  ),
                ],
              ),
            ),
            // Order indicator - only show when orderIndex is provided and > 0
            if (orderIndex != null && orderIndex! > 0)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '#${orderIndex}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onTertiaryContainer,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
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
        itemBuilder:
            (context) => [
              if (post.media != null) ...[
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
                      ), // Using iOS share icon
                      const SizedBox(width: 12),
                      const Text('Share Media'),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'copy_media',
                  child: Row(
                    children: [
                      Icon(Icons.copy, color: colorScheme.primary, size: 20),
                      const SizedBox(width: 12),
                      const Text('Copy Media'),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
              ],
              PopupMenuItem<String>(
                value: 'share_link', // Renamed from 'share'
                child: Row(
                  children: [
                    Icon(Icons.share, color: colorScheme.primary, size: 20),
                    const SizedBox(width: 12),
                    const Text('Share Link'), // Renamed
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
                value: 'copy_text',
                child: Row(
                  children: [
                    Icon(
                      Icons.content_copy,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    const Text('Copy Text'),
                  ],
                ),
              ),
              if (isOriginalPost)
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
            ],
        onSelected: (value) => _handleMenuSelection(context, value),
      ),
    );
  }

  void _handleMenuSelection(BuildContext context, String value) async {
    // Get services from DI
    final downloadService = getIt<DownloadService>();
    final logger = getIt<Logger>(instanceName: 'AppLogger');

    final threadUrl =
        'https://boards.4channel.org/${post.boardId}/thread/${post.threadId ?? post.id}';
    final postLink = '$threadUrl#p${post.id}';
    final mediaUrl = post.media?.url;
    final mediaFilename = post.media?.filename ?? 'media.unknown';

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
          ], text: 'Media from post: $postLink');
        } else {
          logger.w("Failed to download media for sharing");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not share media')),
          );
        }
        break;
      case 'copy_media':
        if (mediaUrl == null) return;
        // Just copy the URL for now
        await Clipboard.setData(ClipboardData(text: mediaUrl));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Copied media URL to clipboard')),
        );
        break;
      case 'share_link':
        await Share.share(
          'Check out this post: $postLink',
          subject: '4chan Post',
        );
        break;
      case 'copy_link':
        await Clipboard.setData(ClipboardData(text: postLink));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Copied link to clipboard')),
        );
        break;
      case 'copy_text':
        await Clipboard.setData(ClipboardData(text: post.comment));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Copied text to clipboard')),
        );
        break;
      case 'open_in_browser':
        final url = Uri.parse(threadUrl);
        try {
          if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
            throw 'Could not launch $url';
          }
        } catch (e) {
          logger.e("Could not launch URL: $threadUrl", error: e);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Could not open link: $e')));
        }
        break;
    }
  }
}
