import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vibechan/core/domain/models/media.dart';
import 'package:vibechan/core/domain/models/thread.dart';
import 'package:vibechan/features/thread/presentation/widgets/post_video.dart';
import 'package:vibechan/shared/widgets/html_text.dart';

class ThreadPreviewCard extends StatelessWidget {
  final Thread thread;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final bool fullWidth;
  final bool squareAspect;
  final bool useFullMedia;

  const ThreadPreviewCard({
    super.key,
    required this.thread,
    required this.onTap,
    this.onLongPress,
    this.fullWidth = false,
    this.squareAspect = false,
    this.useFullMedia = false,
  });

  @override
  Widget build(BuildContext context) {
    final originalPost = thread.originalPost;
    final media = originalPost.media;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (media != null)
              Card(
                margin: EdgeInsets.all(0),
                child: AspectRatio(
                  aspectRatio: useFullMedia ? 1 : media.width / media.height,
                  child:
                      media.type == MediaType.video && useFullMedia
                          ? PostVideo(media: media)
                          : CachedNetworkImage(
                            imageUrl:
                                useFullMedia ? media.url : media.thumbnailUrl,
                            fit: BoxFit.cover,
                            placeholder:
                                (context, url) => Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(color: Colors.white),
                                ),
                            errorWidget:
                                (context, url, error) =>
                                    const Center(child: Icon(Icons.error)),
                          ),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (originalPost.subject != null) ...[
                    Text(
                      originalPost.subject!,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                  ],
                  HtmlText(
                    originalPost.comment,
                    maxLines: 4,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.comment, size: 16),
                      const SizedBox(width: 4),
                      Text('${thread.repliesCount}'),
                      const SizedBox(width: 16),
                      const Icon(Icons.image, size: 16),
                      const SizedBox(width: 4),
                      Text('${thread.imagesCount}'),
                      if (thread.isSticky) ...[
                        const SizedBox(width: 16),
                        const Icon(Icons.push_pin, size: 16),
                      ],
                      if (thread.isClosed) ...[
                        const SizedBox(width: 16),
                        const Icon(Icons.lock, size: 16),
                      ],
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
}
