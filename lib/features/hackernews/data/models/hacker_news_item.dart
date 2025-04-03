import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vibechan/core/utils/comment_utils.dart'; // Import CommentNode

part 'hacker_news_item.freezed.dart';
part 'hacker_news_item.g.dart';

@freezed
abstract class HackerNewsItem with _$HackerNewsItem implements CommentNode {
  // Implement CommentNode
  const HackerNewsItem._();

  @JsonSerializable(explicitToJson: true)
  const factory HackerNewsItem({
    required int id,
    @Default(false) bool deleted,
    @Default('')
    String type, // e.g., "job", "story", "comment", "poll", "pollopt"
    String? by, // Author
    int? time, // Unix timestamp
    String? text, // Comment/story text (HTML)
    @Default(false) bool dead, // True if deleted/dead
    int? parent, // Parent item ID
    List<int>? poll, // List of poll option item IDs
    List<int>? kids, // IDs of direct comments/replies
    String? url, // URL of the story
    int? score, // Story score or vote count
    String? title, // Story title
    List<int>? parts, // List of related pollopt item IDs
    int? descendants, // Total comment count
    // Field added to store fetched comments
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default([])
    List<HackerNewsItem> comments, // Use HackerNewsItem directly
  }) = _HackerNewsItem;

  // Explicit getter implementations for CommentNode
  // Map 'comments' field to 'childComments' getter
  @override
  List<CommentNode>? get childComments => comments;

  // Handle nullability for 'deleted' field
  @override
  bool get isDeleted => deleted;

  // Handle nullability for 'dead' field
  @override
  bool get isDead => dead;

  // We need to add a depth getter implementation as well if CommentNode requires it.
  // Assuming depth isn't part of the model, provide a default or calculate if possible.
  // For now, let's assume it's not needed or handled elsewhere.
  // If 'depth' IS required by CommentNode and missing, build_runner will complain again.

  factory HackerNewsItem.fromJson(Map<String, dynamic> json) =>
      _$HackerNewsItemFromJson(json);
}
