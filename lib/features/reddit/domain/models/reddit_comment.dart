import 'package:freezed_annotation/freezed_annotation.dart';
import 'reddit_comment_listing.dart';
import 'package:get_it/get_it.dart'; // Import GetIt
import 'package:logger/logger.dart'; // Import Logger

part 'reddit_comment.freezed.dart';
part 'reddit_comment.g.dart';

// Restore the custom JsonConverter
class RedditCommentConverter
    implements JsonConverter<RedditComment, Map<String, dynamic>> {
  const RedditCommentConverter();

  @override
  RedditComment fromJson(Map<String, dynamic> json) {
    // Get the NAMED logger instance
    final logger = GetIt.instance<Logger>(instanceName: "AppLogger");

    if (json.containsKey('kind')) {
      final kind = json['kind'] as String? ?? 'unknown';

      if (kind == 't1' && // Standard Comment
          json.containsKey('data') &&
          json['data'] is Map<String, dynamic>) {
        final dataMap = Map<String, dynamic>.from(
          json['data'] as Map<String, dynamic>,
        );
        try {
          if (dataMap.containsKey('replies') && dataMap['replies'] == '') {
            dataMap['replies'] = null;
          }
          if (dataMap.containsKey('created_utc') &&
              dataMap['created_utc'] is! num) {
            dataMap['created_utc'] =
                num.tryParse(dataMap['created_utc'].toString())?.toDouble() ??
                0.0;
          } else if (dataMap.containsKey('created_utc')) {
            dataMap['created_utc'] = (dataMap['created_utc'] as num).toDouble();
          }
          // Add depth if missing in data, might get it from outer context if available
          dataMap['depth'] ??= json['depth'] as int? ?? 0;
          // Ensure body_html is handled (default to null)
          return _$RedditCommentFromJson(dataMap);
        } catch (e, stackTrace) {
          logger.e(
            "Converter: Error parsing RedditComment (kind t1) from nested 'data'",
            error: e,
            stackTrace: stackTrace,
          );
          // Fall through to return an error comment
        }
      } else if (kind == 'more' && // Load More Placeholder
          json.containsKey('data') &&
          json['data'] is Map<String, dynamic>) {
        try {
          final dataMap = json['data'] as Map<String, dynamic>;
          final count = dataMap['count'] as int? ?? 0;
          final List<String> children =
              (dataMap['children'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              [];
          final id =
              dataMap['id'] as String? ??
              'more_${children.isNotEmpty ? children.join('_') : DateTime.now().millisecondsSinceEpoch}';
          // 'more' objects might not have depth in their own 'data', check outer json
          final depth = dataMap['depth'] as int? ?? json['depth'] as int? ?? 0;

          return _RedditComment(
            id: id,
            author: '[loader]',
            body:
                '[load ${count > 0 ? '$count ' : ''}more replies (${children.length} threads)]',
            bodyHtml: null, // 'more' items don't have bodyHtml
            score: 0,
            createdUtc: 0.0,
            depth: depth,
          );
        } catch (e, stackTrace) {
          print(
            "Converter: Error parsing RedditComment (kind more) from nested 'data': $e\n$stackTrace",
          );
          return _RedditComment(
            id: 'error-more-${DateTime.now().millisecondsSinceEpoch}',
            author: 'error',
            body: 'Error parsing RedditComment',
            bodyHtml: null,
            score: 0,
            createdUtc: 0.0,
            depth: json['depth'] as int? ?? 0,
          );
        }
      } else if (kind == 't3' && // <<<--- NEW: Handle Link Post (t3)
          json.containsKey('data') &&
          json['data'] is Map<String, dynamic>) {
        try {
          final dataMap = json['data'] as Map<String, dynamic>;
          print(
            "Converter: Encountered 't3' (Link Post), creating placeholder.",
          );

          // Extract common fields if they exist, providing defaults
          final id =
              dataMap['id'] as String? ??
              't3_placeholder_${DateTime.now().millisecondsSinceEpoch}';
          final author = dataMap['author'] as String? ?? '[unknown_author]';
          final score = dataMap['score'] as int? ?? 0;
          final createdUtc =
              (dataMap['created_utc'] as num?)?.toDouble() ?? 0.0;
          // Depth might not be relevant/present for a t3 in a comment list context
          final depth = dataMap['depth'] as int? ?? json['depth'] as int? ?? 0;
          // Ensure body_html is handled (default to null)
          dataMap['body_html'] ??= null;

          return _RedditComment(
            id: id,
            author: author,
            body: 'Unsupported Item Type: t3',
            bodyHtml: null,
            score: score,
            createdUtc: createdUtc,
            depth: depth,
          );
        } catch (e, stackTrace) {
          print(
            "Converter: Error parsing placeholder for unexpected 't3' item: $e\n$stackTrace",
          );
          // Fallback to a generic error if parsing the t3 fails
          return _RedditComment(
            id: 'error-t3-${DateTime.now().millisecondsSinceEpoch}',
            author: 'error',
            body: 'Error parsing RedditComment',
            bodyHtml: null,
            score: 0,
            createdUtc: 0.0,
            depth: json['depth'] as int? ?? 0,
          );
        }
      }
    }

    // Fallback if kind handling fails or no kind/data
    try {
      logger.d(
        "Converter: Attempting direct parse of RedditComment for object: $json",
      ); // Use debug log
      final fallbackData = Map<String, dynamic>.from(json);

      if (fallbackData.containsKey('replies') &&
          fallbackData['replies'] == '') {
        fallbackData['replies'] = null;
      }
      if (fallbackData.containsKey('created_utc') &&
          fallbackData['created_utc'] is! num) {
        fallbackData['created_utc'] =
            num.tryParse(fallbackData['created_utc'].toString())?.toDouble() ??
            0.0;
      } else if (fallbackData.containsKey('created_utc')) {
        fallbackData['created_utc'] =
            (fallbackData['created_utc'] as num).toDouble();
      }
      // Ensure depth exists for the error case too
      fallbackData['depth'] ??= json['depth'] as int? ?? 0;
      // Ensure body_html is handled in fallback
      fallbackData['body_html'] ??= null;

      // REMOVE Log the map being passed to the generated parser in fallback
      // logger.d("Converter: Parsing fallbackData: $fallbackData");
      return _$RedditCommentFromJson(fallbackData);
    } catch (e, stackTrace) {
      // Capture stack trace
      logger.e(
        "Converter: Failed to parse RedditComment directly or from kind handler",
        error: e,
        stackTrace: stackTrace,
      );
      // Return an error placeholder comment using the private constructor
      return _RedditComment(
        id: 'error-${DateTime.now().millisecondsSinceEpoch}',
        author: 'error',
        body: 'Error parsing RedditComment',
        bodyHtml: null,
        score: 0,
        createdUtc: 0.0,
        depth: json['depth'] as int? ?? 0,
      );
    }
  }

  @override
  Map<String, dynamic> toJson(RedditComment data) {
    if (data.isLoadMorePlaceholder ||
        data.body == 'Unsupported Item Type: t3' ||
        data.author == 'error') {
      // Simplified serialization for placeholders/errors
      // (Adjust as needed if you need to serialize these differently)
      return {
        'kind':
            (data.isLoadMorePlaceholder
                ? 'more'
                : 't1'), // Assuming t1 for others
        'data': {
          'id': data.id,
          'name': '${data.isLoadMorePlaceholder ? 'more' : 't1'}_${data.id}',
          'author': data.author,
          'body': data.body,
          'depth': data.depth,
          'score': data.score,
          'created_utc': data.createdUtc,
          // No replies or body_html needed for these types
        },
      };
    } else {
      // Serialize regular comments
      Map<String, dynamic> commentData = {
        'id': data.id,
        'author': data.author,
        'body': data.body,
        'body_html': data.bodyHtml, // Include HTML field
        'score': data.score,
        'created_utc': data.createdUtc,
        'depth': data.depth,
        'replies': data.replies?.toJson(), // Serializes the replies object/list
        'name': 't1_${data.id}',
      };

      // Wrap replies in Listing structure if needed
      if (commentData['replies'] != null) {
        commentData['replies'] = {
          'kind': 'Listing',
          'data': {
            'after': null,
            'dist': null,
            'modhash': null,
            'geo_filter': null,
            'children':
                commentData['replies'], // Assumes replies.toJson() returns list
            'before': null,
          },
        };
      } else {
        // Reddit API often expects an empty string "" for no replies on comments
        // rather than null or omitting the key, but null might also work.
        // Let's explicitly set it to null if absent, or "" if preferred by API.
        // commentData['replies'] = ""; // Alternative if API requires empty string
        commentData.remove('replies'); // Or just remove if null is okay
      }

      return {'kind': 't1', 'data': commentData};
    }
  }
}

@freezed
abstract class RedditComment with _$RedditComment {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory RedditComment({
    required String id,
    required String author,
    required String body,
    String? bodyHtml,
    required int score,
    required double createdUtc,
    @Default(0) int depth,
    RedditCommentListing? replies,
  }) = _RedditComment;

  // Restore the simple factory, converter will handle the rest
  factory RedditComment.fromJson(Map<String, dynamic> json) =>
      _$RedditCommentFromJson(json);
}

// Helper extension
extension RedditCommentX on RedditComment {
  DateTime get createdDateTime => DateTime.fromMillisecondsSinceEpoch(
    (createdUtc * 1000).round(),
    isUtc: true,
  );
  bool get isLoadMorePlaceholder => author == '[loader]';
  bool get isDeleted => author == '[deleted]' && body == '[deleted]';
  // Helper to get the actual list of comments from the nested structure
  List<RedditComment> get replyComments => replies?.data.children ?? [];
}
