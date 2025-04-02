// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hacker_news_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HackerNewsItem _$HackerNewsItemFromJson(Map<String, dynamic> json) =>
    _HackerNewsItem(
      id: (json['id'] as num).toInt(),
      deleted: json['deleted'] as bool? ?? false,
      type: json['type'] as String?,
      by: json['by'] as String?,
      time: (json['time'] as num?)?.toInt(),
      text: json['text'] as String?,
      dead: json['dead'] as bool? ?? false,
      parent: (json['parent'] as num?)?.toInt(),
      poll: (json['poll'] as num?)?.toInt(),
      kids:
          (json['kids'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList(),
      url: json['url'] as String?,
      score: (json['score'] as num?)?.toInt(),
      title: json['title'] as String?,
      parts:
          (json['parts'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList(),
      descendants: (json['descendants'] as num?)?.toInt(),
    );

Map<String, dynamic> _$HackerNewsItemToJson(_HackerNewsItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'deleted': instance.deleted,
      'type': instance.type,
      'by': instance.by,
      'time': instance.time,
      'text': instance.text,
      'dead': instance.dead,
      'parent': instance.parent,
      'poll': instance.poll,
      'kids': instance.kids,
      'url': instance.url,
      'score': instance.score,
      'title': instance.title,
      'parts': instance.parts,
      'descendants': instance.descendants,
    };
