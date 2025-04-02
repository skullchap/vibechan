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
    };
