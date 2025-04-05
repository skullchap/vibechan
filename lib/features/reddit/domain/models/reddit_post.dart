import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

part 'reddit_post.freezed.dart';
part 'reddit_post.g.dart';

@freezed
abstract class RedditPost with _$RedditPost {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory RedditPost({
    required String id,
    required String subreddit,
    required String title,
    required String author,
    required int score,
    required int numComments,
    required String permalink,
    required double
    createdUtc, // Keep as double for precision from Unix timestamp
    @Default('') String selftext,
    String? selftextHtml, // Add HTML field
    String? url, // Link or media URL
    String? thumbnail, // URL for thumbnail
    @Default(false) bool isVideo,
    // Consider adding 'media' or 'preview' for richer media handling later
    @Default(false) bool stickied,
    @Default(false) bool over18,
    String? linkFlairText,
    String? authorFlairText,
  }) = _RedditPost;

  factory RedditPost.fromJson(Map<String, dynamic> json) {
    final logger = GetIt.instance<Logger>(instanceName: "AppLogger");

    // Prioritize using the 'data' field if it exists and is a Map
    if (json.containsKey('data') && json['data'] is Map<String, dynamic>) {
      final dataMap = Map<String, dynamic>.from(
        json['data'] as Map<String, dynamic>,
      );
      try {
        // Apply defaults to the dataMap
        logger.d("--- RedditPost.fromJson --- Trying nested 'data' field.");
        logger.d("Incoming dataMap id: ${dataMap['id']}");
        dataMap['id'] ??= 'missing_id_${DateTime.now().millisecondsSinceEpoch}';
        dataMap['subreddit'] ??= 'unknown';
        dataMap['title'] ??= '[Missing Title]';
        dataMap['author'] ??= '[deleted]';
        dataMap['permalink'] ??= '';
        dataMap['selftext'] ??= '';
        dataMap['selftext_html'] ??= null; // Default to null if missing

        return _$RedditPostFromJson(dataMap);
      } catch (e) {
        logger.e(
          "Error parsing RedditPost from nested 'data' field (Kind: ${json['kindd'] ?? json['kind'] ?? 'unknown'})",
          error: e,
        );
        // Rethrow immediately to see the specific error from dataMap parsing
        rethrow;
      }
    }

    // Fallback: Try parsing the original JSON directly (less common for posts)
    try {
      logger.d("--- RedditPost.fromJson --- Trying direct parse (fallback).");
      // Apply defaults BEFORE parsing
      logger.d("Incoming direct json id: ${json['id']}");
      json['id'] ??= 'missing_id_${DateTime.now().millisecondsSinceEpoch}';
      json['subreddit'] ??= 'unknown';
      json['title'] ??= '[Missing Title]';
      json['author'] ??= '[deleted]';
      json['permalink'] ??= '';
      json['selftext'] ??= ''; // Ensure selftext has default too
      json['selftext_html'] ??= null; // Default to null if missing

      return _$RedditPostFromJson(json);
    } catch (e) {
      logger.e(
        "Failed to parse RedditPost directly or from nested data",
        error: e,
      );
      rethrow; // Rethrow if all parsing attempts fail
    }
  }
}

// Helper extension for easy URL generation
extension RedditPostX on RedditPost {
  String get fullPermalink => 'https://www.reddit.com$permalink';
  DateTime get createdDateTime => DateTime.fromMillisecondsSinceEpoch(
    (createdUtc * 1000).round(),
    isUtc: true,
  );
}
