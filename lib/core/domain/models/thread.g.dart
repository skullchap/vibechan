// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thread.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Thread _$ThreadFromJson(Map<String, dynamic> json) => _Thread(
  id: json['id'] as String,
  boardId: json['boardId'] as String,
  originalPost: Post.fromJson(json['originalPost'] as Map<String, dynamic>),
  replies:
      (json['replies'] as List<dynamic>?)
          ?.map((e) => Post.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  isSticky: json['isSticky'] as bool? ?? false,
  isClosed: json['isClosed'] as bool? ?? false,
  isWatched: json['isWatched'] as bool? ?? false,
  lastModified:
      json['lastModified'] == null
          ? null
          : DateTime.parse(json['lastModified'] as String),
  repliesCount: (json['repliesCount'] as num?)?.toInt(),
  imagesCount: (json['imagesCount'] as num?)?.toInt(),
);

Map<String, dynamic> _$ThreadToJson(_Thread instance) => <String, dynamic>{
  'id': instance.id,
  'boardId': instance.boardId,
  'originalPost': instance.originalPost,
  'replies': instance.replies,
  'isSticky': instance.isSticky,
  'isClosed': instance.isClosed,
  'isWatched': instance.isWatched,
  'lastModified': instance.lastModified?.toIso8601String(),
  'repliesCount': instance.repliesCount,
  'imagesCount': instance.imagesCount,
};
