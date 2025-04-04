import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vibechan/features/fourchan/domain/models/post.dart';
import 'package:vibechan/shared/providers/search_provider.dart';

class PostHeader extends ConsumerWidget {
  final Post post;
  final bool isOriginalPost;

  const PostHeader({
    super.key,
    required this.post,
    this.isOriginalPost = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    // Get search state for highlighting
    final isSearchActive = ref.watch(isSearchActiveProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final shouldHighlight = isSearchActive && searchQuery.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Wrap(
        // Use Wrap for better flexibility
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8.0, // Horizontal spacing between items
        runSpacing: 4.0, // Vertical spacing if items wrap
        children: [
          // Name with optional highlighting
          if (shouldHighlight &&
              post.name != null &&
              post.name!.toLowerCase().contains(searchQuery.toLowerCase()))
            RichText(
              text: TextSpan(
                children: _getHighlightedSpans(
                  post.name ?? 'Anonymous',
                  boldSmallTextStyle ?? TextStyle(),
                  searchQuery,
                  colorScheme.tertiaryContainer,
                ),
              ),
            )
          else
            Text(post.name ?? 'Anonymous', style: boldSmallTextStyle),

          // Tripcode
          if (post.tripcode != null) Text(post.tripcode!, style: tripcodeStyle),

          // Post ID
          Text('#${post.id}', style: smallTextStyle),

          // Timestamp
          Text(formattedDate, style: smallTextStyle),

          // Subject with optional highlighting
          if (post.subject != null && post.subject!.isNotEmpty)
            if (shouldHighlight &&
                post.subject!.toLowerCase().contains(searchQuery.toLowerCase()))
              RichText(
                text: TextSpan(
                  children: _getHighlightedSpans(
                    post.subject!,
                    subjectStyle ?? TextStyle(),
                    searchQuery,
                    colorScheme.tertiaryContainer,
                  ),
                ),
              )
            else
              Text(post.subject!, style: subjectStyle),
        ],
      ),
    );
  }

  // Helper method to highlight search terms in text
  List<InlineSpan> _getHighlightedSpans(
    String text,
    TextStyle style,
    String searchTerms,
    Color highlightColor,
  ) {
    if (searchTerms.isEmpty) return [TextSpan(text: text, style: style)];

    final List<InlineSpan> result = [];
    final RegExp regExp = RegExp(
      searchTerms
          .split(' ')
          .where((term) => term.isNotEmpty)
          .map((term) {
            return RegExp.escape(term);
          })
          .join('|'),
      caseSensitive: false,
    );

    int lastMatchEnd = 0;
    for (final match in regExp.allMatches(text)) {
      // Add text before the match
      if (match.start > lastMatchEnd) {
        result.add(
          TextSpan(
            text: text.substring(lastMatchEnd, match.start),
            style: style,
          ),
        );
      }

      // Add the highlighted match
      result.add(
        TextSpan(
          text: text.substring(match.start, match.end),
          style: style.copyWith(
            backgroundColor: highlightColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

      lastMatchEnd = match.end;
    }

    // Add remaining text after the last match
    if (lastMatchEnd < text.length) {
      result.add(TextSpan(text: text.substring(lastMatchEnd), style: style));
    }

    return result;
  }
}
