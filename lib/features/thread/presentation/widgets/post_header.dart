import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vibechan/core/utils/string_highlighter.dart';
import '../../../../core/domain/models/post.dart';

class PostHeader extends StatelessWidget {
  final Post post;
  final bool isOriginalPost;
  final String? highlightQuery;

  const PostHeader({
    super.key,
    required this.post,
    this.isOriginalPost = false,
    this.highlightQuery,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final smallTextStyle = theme.textTheme.bodySmall;
    final boldSmallTextStyle = smallTextStyle?.copyWith(
      fontWeight: FontWeight.bold,
    );
    final tripcodeStyle = smallTextStyle?.copyWith(
      color: Colors.green.shade700,
    );
    final subjectStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.bold,
    );

    // Format the timestamp manually as MM/dd/yy
    final dt = post.timestamp;
    final year = dt.year.toString().substring(2); // Get last two digits of year
    final month = dt.month.toString().padLeft(2, '0');
    final day = dt.day.toString().padLeft(2, '0');
    final formattedDate = '$month/$day/$year';

    // Check if highlighting should be applied
    final shouldHighlight =
        highlightQuery != null && highlightQuery!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8.0,
        runSpacing: 4.0,
        children: [
          // Name with optional highlighting
          Text.rich(
            buildHighlightedTextSpan(
              post.name ?? 'Anonymous',
              boldSmallTextStyle,
              shouldHighlight ? highlightQuery! : '',
              colorScheme.tertiaryContainer,
            ),
          ),

          // Tripcode
          if (post.tripcode != null) Text(post.tripcode!, style: tripcodeStyle),

          // Post ID
          Text('#${post.id}', style: smallTextStyle),

          // Timestamp
          Text(formattedDate, style: smallTextStyle),

          // Subject with optional highlighting
          if (post.subject != null && post.subject!.isNotEmpty)
            Text.rich(
              buildHighlightedTextSpan(
                post.subject!,
                subjectStyle,
                shouldHighlight ? highlightQuery! : '',
                colorScheme.tertiaryContainer,
              ),
            ),

          // Share button
          IconButton(
            icon: Icon(
              Icons.share,
              size: 16,
              color: colorScheme.onSurfaceVariant,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            tooltip: 'Share Post',
            onPressed: () {
              // TODO: Generate shareable link/text
              Share.share('Check out this post: # ${post.id}');
            },
          ),
        ],
      ),
    );
  }
}
