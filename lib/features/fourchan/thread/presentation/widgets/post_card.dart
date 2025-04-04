import 'package:flutter/material.dart';
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
}
