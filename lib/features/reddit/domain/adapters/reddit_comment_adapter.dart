import 'package:vibechan/features/reddit/domain/models/reddit_comment.dart';
import 'package:vibechan/shared/models/generic_comment_item.dart';
// Potentially import html parser or markdown renderer if needed

extension RedditCommentAdapter on RedditComment {
  GenericCommentItem toGenericCommentItem() {
    // Handle placeholder types
    if (isLoadMorePlaceholder) {
      return GenericCommentItem(
        id: id,
        author: '[loader]',
        body: body, // Contains "[load X more replies...]"
        timestamp: DateTime.now(), // Placeholder time
        depth: depth,
        isPlaceholder: true,
        // Placeholder specific data if needed
        placeholderType: PlaceholderType.loadMore,
        placeholderData: {'load_more_id': id}, // Example data
      );
    }
    if (isDeleted) {
      return GenericCommentItem(
        id: id,
        author: author, // '[deleted]'
        body: body, // '[deleted]'
        timestamp: createdDateTime,
        depth: depth,
        isPlaceholder: true,
        placeholderType: PlaceholderType.deleted,
      );
    }

    // Regular comment
    return GenericCommentItem(
      id: id,
      author: author,
      // Basic body for now, could use SimpleHtmlRenderer or FlutterMarkdown later
      body: body,
      timestamp: createdDateTime,
      score: score,
      depth: depth,
      replyCount: replyComments.length, // Basic reply count
      // Pass original data if needed by the generic widget
      originalData: this,
    );
  }
}
