import 'package:freezed_annotation/freezed_annotation.dart';
import 'post.dart';

part 'thread.freezed.dart';
part 'thread.g.dart';

@freezed
abstract class Thread with _$Thread {
  const factory Thread({
    required String id,
    required String boardId,
    required Post originalPost,
    @Default([]) List<Post> replies,
    @Default(false) bool isSticky,
    @Default(false) bool isClosed,
    @Default(false) bool isWatched,
    DateTime? lastModified,
    int? repliesCount,
    int? imagesCount,
  }) = _Thread;

  factory Thread.fromJson(Map<String, dynamic> json) => _$ThreadFromJson(json);
}