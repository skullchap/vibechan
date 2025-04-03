// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Post _$PostFromJson(Map<String, dynamic> json) => _Post(
  id: json['id'] as String,
  boardId: json['boardId'] as String,
  threadId: json['threadId'] as String?,
  timestamp: DateTime.parse(json['timestamp'] as String),
  name: json['name'] as String?,
  tripcode: json['tripcode'] as String?,
  subject: json['subject'] as String?,
  comment: json['comment'] as String,
  media:
      json['media'] == null
          ? null
          : Media.fromJson(json['media'] as Map<String, dynamic>),
  referencedPosts:
      (json['referencedPosts'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  isOp: json['isOp'] as bool? ?? false,
  posterId: json['posterId'] as String?,
  countryCode: json['countryCode'] as String?,
  countryName: json['countryName'] as String?,
  boardFlag: json['boardFlag'] as String?,
);

Map<String, dynamic> _$PostToJson(_Post instance) => <String, dynamic>{
  'id': instance.id,
  'boardId': instance.boardId,
  'threadId': instance.threadId,
  'timestamp': instance.timestamp.toIso8601String(),
  'name': instance.name,
  'tripcode': instance.tripcode,
  'subject': instance.subject,
  'comment': instance.comment,
  'media': instance.media,
  'referencedPosts': instance.referencedPosts,
  'isOp': instance.isOp,
  'posterId': instance.posterId,
  'countryCode': instance.countryCode,
  'countryName': instance.countryName,
  'boardFlag': instance.boardFlag,
};
