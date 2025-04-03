import 'package:flutter/material.dart';
import '../../../../core/domain/models/post.dart';
import '../../../../shared/widgets/html_renderer/simple_html_renderer.dart';
import 'post_header.dart';
import 'post_body.dart';
import 'post_media.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final bool isOriginalPost;
  final Function(String)? onQuoteLink;
  final String? highlightQuery;

  const PostCard({
    super.key,
    required this.post,
    this.isOriginalPost = false,
    this.onQuoteLink,
    this.highlightQuery,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PostHeader(
            post: post,
            isOriginalPost: isOriginalPost,
            highlightQuery: highlightQuery,
          ),
          if (post.media != null) PostMedia(post: post),
          if (post.comment.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
              child: SimpleHtmlRendererImpl(
                htmlString: post.comment,
                baseStyle: theme.textTheme.bodyMedium,
                highlightTerms: highlightQuery,
                highlightColor: colorScheme.tertiaryContainer,
                onQuoteLink: onQuoteLink,
              ),
            ),
        ],
      ),
    );
  }
}
