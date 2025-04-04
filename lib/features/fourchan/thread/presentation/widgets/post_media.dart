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

    if (media.type == domain.MediaType.video) {
      return PostVideo(media: media);
    }

    final aspectRatio = media.width / media.height;
    return CachedNetworkImage(
      imageUrl: media.url,
      placeholder:
          (_, __) => AspectRatio(
            aspectRatio: aspectRatio,
            child: const Center(child: CircularProgressIndicator()),
          ),
      errorWidget:
          (_, __, ___) => AspectRatio(
            aspectRatio: aspectRatio,
            child: const Icon(Icons.error),
          ),
    );
  }
}
