import 'package:freezed_annotation/freezed_annotation.dart';
import 'media.dart';

part 'post.freezed.dart';
part 'post.g.dart';

@freezed
abstract class Post with _$Post {
  const factory Post({
    required String id,
    required String boardId,
    String? threadId,
    required DateTime timestamp,
    String? name,
    String? tripcode,
    String? subject,
    required String comment,
    Media? media,
    @Default([]) List<String> referencedPosts,
    @Default(false) bool isOp,
  }) = _Post;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
}