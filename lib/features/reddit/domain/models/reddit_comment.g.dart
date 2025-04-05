// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reddit_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RedditComment _$RedditCommentFromJson(Map<String, dynamic> json) =>
    _RedditComment(
      id: json['id'] as String,
      author: json['author'] as String,
      body: json['body'] as String,
      bodyHtml: json['body_html'] as String?,
      score: (json['score'] as num).toInt(),
      createdUtc: (json['created_utc'] as num).toDouble(),
      depth: (json['depth'] as num?)?.toInt() ?? 0,
      replies:
          json['replies'] == null
              ? null
              : RedditCommentListing.fromJson(
                json['replies'] as Map<String, dynamic>,
              ),
    );

Map<String, dynamic> _$RedditCommentToJson(_RedditComment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'author': instance.author,
      'body': instance.body,
      'body_html': instance.bodyHtml,
      'score': instance.score,
      'created_utc': instance.createdUtc,
      'depth': instance.depth,
      'replies': instance.replies,
    };
