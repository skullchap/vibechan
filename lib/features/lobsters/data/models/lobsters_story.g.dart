// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lobsters_story.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LobstersStory _$LobstersStoryFromJson(Map<String, dynamic> json) =>
    _LobstersStory(
      shortId: json['short_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      title: json['title'] as String,
      url: json['url'] as String,
      score: (json['score'] as num).toInt(),
      commentCount: (json['comment_count'] as num).toInt(),
      description: json['description'] as String?,
      commentsUrl: json['comments_url'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      submitterUser: json['submitter_user'] as String,
      comments:
          (json['comments'] as List<dynamic>?)
              ?.map((e) => LobstersComment.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$LobstersStoryToJson(_LobstersStory instance) =>
    <String, dynamic>{
      'short_id': instance.shortId,
      'created_at': instance.createdAt.toIso8601String(),
      'title': instance.title,
      'url': instance.url,
      'score': instance.score,
      'comment_count': instance.commentCount,
      'description': instance.description,
      'comments_url': instance.commentsUrl,
      'tags': instance.tags,
      'submitter_user': instance.submitterUser,
      'comments': instance.comments,
    };

_LobstersComment _$LobstersCommentFromJson(Map<String, dynamic> json) =>
    _LobstersComment(
      shortId: json['short_id'] as String,
      commentingUser: json['commenting_user'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      lastEditedAt: DateTime.parse(json['last_edited_at'] as String),
      isDeleted: json['is_deleted'] as bool,
      isModerated: json['is_moderated'] as bool,
      score: (json['score'] as num).toInt(),
      depth: (json['depth'] as num).toInt(),
      comment: json['comment'] as String?,
      comments:
          (json['comments'] as List<dynamic>?)
              ?.map((e) => LobstersComment.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$LobstersCommentToJson(_LobstersComment instance) =>
    <String, dynamic>{
      'short_id': instance.shortId,
      'commenting_user': instance.commentingUser,
      'created_at': instance.createdAt.toIso8601String(),
      'last_edited_at': instance.lastEditedAt.toIso8601String(),
      'is_deleted': instance.isDeleted,
      'is_moderated': instance.isModerated,
      'score': instance.score,
      'depth': instance.depth,
      'comment': instance.comment,
      'comments': instance.comments,
    };
