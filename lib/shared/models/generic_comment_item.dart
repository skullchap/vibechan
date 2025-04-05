import 'package:freezed_annotation/freezed_annotation.dart';

part 'generic_comment_item.freezed.dart';
// Note: No .g.dart needed if we don't persist this specific model directly

// Enum for different placeholder types
enum PlaceholderType { loadMore, deleted, error }

@freezed
abstract class GenericCommentItem with _$GenericCommentItem {
  const factory GenericCommentItem({
    required String id,
    String? author,
    String? body,
    DateTime? timestamp,
    int? score,
    int? depth,
    int? replyCount,
    // Placeholder specific fields
    @Default(false) bool isPlaceholder,
    PlaceholderType? placeholderType,
    Map<String, dynamic>? placeholderData,
    // Optional link to original data source model
    dynamic originalData,
    // Any other common fields needed for display
    // e.g., String? bodyHtml for rich text?
    // e.g., List<GenericCommentItem>? replies (if handling nesting generically)
  }) = _GenericCommentItem;

  // No fromJson/toJson needed here unless this exact model is serialized/deserialized
}
