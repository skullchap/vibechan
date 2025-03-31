// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Board _$BoardFromJson(Map<String, dynamic> json) => _Board(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  isWorksafe: json['isWorksafe'] as bool? ?? false,
  threadsCount: (json['threadsCount'] as num?)?.toInt() ?? 0,
  iconUrl: json['iconUrl'] as String?,
);

Map<String, dynamic> _$BoardToJson(_Board instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'isWorksafe': instance.isWorksafe,
  'threadsCount': instance.threadsCount,
  'iconUrl': instance.iconUrl,
};
