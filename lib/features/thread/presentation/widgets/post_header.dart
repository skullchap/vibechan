import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/domain/models/post.dart';

class PostHeader extends StatelessWidget {
  final Post post;

  const PostHeader({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          if (post.subject != null)
            Expanded(
              child: Text(
                post.subject!,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          Text(post.name ?? 'Anonymous', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
          if (post.tripcode != null) ...[
            const SizedBox(width: 4),
            Text(post.tripcode!, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.green)),
          ],
          const Spacer(),
          Text('#${post.id}', style: Theme.of(context).textTheme.bodySmall),
          PopupMenuButton<String>(
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'copy', child: Text('Copy Text')),
              const PopupMenuItem(value: 'share', child: Text('Share')),
            ],
            onSelected: (value) {
              if (value == 'share') Share.share(post.comment);
              // TODO: implement copy
            },
          ),
        ],
      ),
    );
  }
}
