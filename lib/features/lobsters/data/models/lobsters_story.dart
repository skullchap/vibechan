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
  }) = _LobstersStory;

  factory LobstersStory.fromJson(Map<String, dynamic> json) =>
      _$LobstersStoryFromJson(json);
}
