// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_tab.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ContentTab _$ContentTabFromJson(Map<String, dynamic> json) => _ContentTab(
  id: json['id'] as String,
  title: json['title'] as String,
  initialRouteName: json['initialRouteName'] as String,
  pathParameters: Map<String, String>.from(json['pathParameters'] as Map),
  icon:
      json['icon'] == null
          ? Icons.web
          : const IconDataConverter().fromJson(json['icon'] as String),
  isActive: json['isActive'] as bool? ?? false,
);

Map<String, dynamic> _$ContentTabToJson(_ContentTab instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'initialRouteName': instance.initialRouteName,
      'pathParameters': instance.pathParameters,
      'icon': const IconDataConverter().toJson(instance.icon),
      'isActive': instance.isActive,
    };
