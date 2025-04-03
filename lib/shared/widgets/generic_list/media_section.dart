import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

/// Displays media (images) in the generic list card
class MediaSection extends StatelessWidget {
  final String imageUrl;

  const MediaSection({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AspectRatio(
      aspectRatio: 16 / 9, // Default aspect ratio
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
}
