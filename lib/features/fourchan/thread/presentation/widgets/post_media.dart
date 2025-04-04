import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:vibechan/features/fourchan/domain/models/media.dart' as domain;
import 'package:vibechan/features/fourchan/domain/models/post.dart';
import 'post_video.dart';

class PostMedia extends StatelessWidget {
  final Post post;

  const PostMedia({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final media = post.media;
    if (media == null) return const SizedBox.shrink();

    return Card(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double maxWidth = constraints.maxWidth;
          final aspectRatio = media.width / media.height;

          // Calculate responsive height based on available width and aspect ratio
          final double adaptiveHeight = maxWidth / aspectRatio;
          // Limit height to reasonable bounds
          final double finalHeight = adaptiveHeight.clamp(100, 400);

          if (media.type == domain.MediaType.video) {
            return SizedBox(
              width: maxWidth,
              height: finalHeight,
              child: PostVideo(media: media),
            );
          }

          return CachedNetworkImage(
            imageUrl: media.url,
            width: maxWidth,
            height: finalHeight,
            fit: BoxFit.cover,
            placeholder:
                (_, __) => SizedBox(
                  width: maxWidth,
                  height: finalHeight,
                  child: const Center(child: CircularProgressIndicator()),
                ),
            errorWidget:
                (_, __, ___) => SizedBox(
                  width: maxWidth,
                  height: finalHeight,
                  child: const Center(child: Icon(Icons.error)),
                ),
          );
        },
      ),
    );
  }
}
