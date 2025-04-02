import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'lobsters_story.freezed.dart';
part 'lobsters_story.g.dart';

@freezed
abstract class LobstersStory with _$LobstersStory {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory LobstersStory({
    required String shortId,
    required DateTime createdAt,
    required String title,
    required String url,
    required int score,
    required int commentCount,
    String? description,
    required String commentsUrl,
    required List<String> tags,
    required String submitterUser,
    List<LobstersComment>? comments,
  }) = _LobstersStory;

  factory LobstersStory.fromJson(Map<String, dynamic> json) =>
      _$LobstersStoryFromJson(json);
}

@freezed
abstract class LobstersComment with _$LobstersComment {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory LobstersComment({
    required String shortId,
    required String commentingUser,
    required DateTime createdAt,
    @JsonKey(name: 'last_edited_at') required DateTime lastEditedAt,
    required bool isDeleted,
    required bool isModerated,
    required int score,
    required int depth,
    String? comment,
    List<LobstersComment>? comments,
  }) = _LobstersComment;

  factory LobstersComment.fromJson(Map<String, dynamic> json) =>
      _$LobstersCommentFromJson(json);
}
