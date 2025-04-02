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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Wrap(
        // Use Wrap for better flexibility
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8.0, // Horizontal spacing between items
        runSpacing: 4.0, // Vertical spacing if items wrap
        children: [
          // Name
          Text(post.name ?? 'Anonymous', style: boldSmallTextStyle),

          // Tripcode
          if (post.tripcode != null) Text(post.tripcode!, style: tripcodeStyle),

          // Post ID
          Text('#${post.id}', style: smallTextStyle),

          // Timestamp
          Text(formattedDate, style: smallTextStyle),

          // Subject (only if it exists)
          if (post.subject != null && post.subject!.isNotEmpty)
            Text(
              post.subject!,
              style: subjectStyle,
              // Consider adding maxLines and overflow if subjects can be very long
              // maxLines: 1,
              // overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }
}
