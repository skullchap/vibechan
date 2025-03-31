import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/domain/models/post.dart';
import '../../../../core/domain/models/media.dart';
import '../../../../shared/widgets/html_text.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final bool isOriginalPost;
  final Function(String)? onQuoteLink;

  const PostCard({
    super.key,
    required this.post,
    this.isOriginalPost = false,
    this.onQuoteLink,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPostHeader(context),
          if (post.media != null) _buildMediaPreview(context),
          _buildPostContent(context),
        ],
      ),
    );
  }

  Widget _buildPostHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          if (post.subject != null) ...[
            Expanded(
              child: Text(
                post.subject!,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          Text(
            post.name ?? 'Anonymous',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          if (post.tripcode != null) ...[
            const SizedBox(width: 4),
            Text(
              post.tripcode!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.green,
              ),
            ),
          ],
          const Spacer(),
          Text(
            '#${post.id}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          PopupMenuButton<String>(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'copy',
                child: Text('Copy Text'),
              ),
              if (post.media != null)
                const PopupMenuItem(
                  value: 'save',
                  child: Text('Save Media'),
                ),
              const PopupMenuItem(
                value: 'share',
                child: Text('Share'),
              ),
            ],
            onSelected: (value) => _handleMenuAction(context, value),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaPreview(BuildContext context) {
    final media = post.media!;
    final aspectRatio = media.width / media.height;

    return InkWell(
      onTap: () => _openMedia(context, media),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: CachedNetworkImage(
          imageUrl: media.type == MediaType.video ? media.thumbnailUrl : media.url,
          placeholder: (context, url) => AspectRatio(
            aspectRatio: aspectRatio,
            child: Container(
              color: Colors.grey[200],
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
          errorWidget: (context, url, error) => AspectRatio(
            aspectRatio: aspectRatio,
            child: Container(
              color: Colors.grey[200],
              child: const Icon(Icons.error),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPostContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: HtmlText(
        post.comment,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  void _handleMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'copy':
        // TODO: Implement copy to clipboard
        break;
      case 'save':
        if (post.media != null) {
          _saveMedia(post.media!);
        }
        break;
      case 'share':
        _sharePost();
        break;
    }
  }

  Future<void> _openMedia(BuildContext context, Media media) async {
    if (media.type == MediaType.video) {
      final url = Uri.parse(media.url);
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
    } else {
      // TODO: Implement full-screen image viewer
    }
  }

  Future<void> _saveMedia(Media media) async {
    // TODO: Implement media saving
  }

  Future<void> _sharePost() async {
    final text = post.subject != null 
      ? '${post.subject}\n${post.comment}'
      : post.comment;
    await Share.share(text);
  }
}