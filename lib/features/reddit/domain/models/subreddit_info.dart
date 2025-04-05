import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

part 'subreddit_info.freezed.dart';
part 'subreddit_info.g.dart';

@freezed
abstract class SubredditInfo with _$SubredditInfo {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory SubredditInfo({
    required String id,
    required String displayName, // e.g., flutterdev
    required String title, // e.g., Flutter Development
    required String displayNamePrefixed, // e.g., r/flutterdev
    String? description,
    String? publicDescription,
    @JsonKey(name: 'subscribers') required int subscriberCount,
    @JsonKey(name: 'active_user_count') int? activeUserCount,
    String? iconImg, // URL for icon
    String? headerImg, // URL for banner
    double? createdUtc,
    @Default(false) bool over18,
  }) = _SubredditInfo;

  factory SubredditInfo.fromJson(Map<String, dynamic> json) {
    // Subreddit info is usually nested under 'data'
    if (json.containsKey('kind') &&
        json['kind'] == 't5' &&
        json.containsKey('data') &&
        json['data'] is Map<String, dynamic>) {
      return _$SubredditInfoFromJson(json['data'] as Map<String, dynamic>);
    }
    // Attempt direct parsing otherwise
    try {
      return _$SubredditInfoFromJson(json);
    } catch (e) {
      final logger = GetIt.instance<Logger>(instanceName: "AppLogger");
      logger.e(
        "Failed to parse SubredditInfo from JSON",
        error: e,
        stackTrace: StackTrace.current,
      );
      rethrow;
    }
  }
}

extension SubredditInfoX on SubredditInfo {
  DateTime? get createdDateTime =>
      createdUtc == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(
            (createdUtc! * 1000).round(),
            isUtc: true,
          );
}
