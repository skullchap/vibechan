import 'package:flutter/material.dart';
import 'package:vibechan/features/fourchan/domain/models/post.dart';
import 'post_header.dart';
import 'post_body.dart';
import 'post_media.dart';

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
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PostHeader(post: post, isOriginalPost: isOriginalPost),
          PostMedia(post: post),
          PostBody(post: post),
        ],
      ),
    );
  }
}
