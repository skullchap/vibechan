import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/domain/models/post.dart';

class PostHeader extends StatelessWidget {
  final Post post;
  final bool isOriginalPost;

  const PostHeader({
    super.key,
    required this.post,
    this.isOriginalPost = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        children: [
          if (post.subject != null)
            Expanded(
              child: Text(
                post.subject!,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          if (!isOriginalPost) ...[
            const Spacer(),
            if (post.subject != null) const SizedBox(width: 16),
            Text(
              post.name ?? 'Anonymous',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (post.tripcode != null) ...[
              const SizedBox(width: 4),
              Text(
                post.tripcode!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.green.shade700,
                ),
              ),
            ],
            const SizedBox(width: 8),
            Text('#${post.id}', style: theme.textTheme.bodySmall),
          ],
          if (isOriginalPost) ...[
            const Spacer(),
            PopupMenuButton<String>(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.more_vert, size: 18),
              itemBuilder:
                  (context) => [
                    const PopupMenuItem(
                      value: 'share_thread',
                      child: Text('Share Thread'),
                    ),
                  ],
              onSelected: (value) {
                if (value == 'share_thread') {
                  // TODO: Implement share thread logic (need thread URL)
                }
              },
            ),
          ],
        ],
      ),
    );
  }
}
