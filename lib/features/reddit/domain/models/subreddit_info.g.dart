// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subreddit_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SubredditInfo _$SubredditInfoFromJson(Map<String, dynamic> json) =>
    _SubredditInfo(
      id: json['id'] as String,
      displayName: json['display_name'] as String,
      title: json['title'] as String,
      displayNamePrefixed: json['display_name_prefixed'] as String,
      description: json['description'] as String?,
      publicDescription: json['public_description'] as String?,
      subscriberCount: (json['subscribers'] as num).toInt(),
      activeUserCount: (json['active_user_count'] as num?)?.toInt(),
      iconImg: json['icon_img'] as String?,
      headerImg: json['header_img'] as String?,
      createdUtc: (json['created_utc'] as num?)?.toDouble(),
      over18: json['over18'] as bool? ?? false,
    );

Map<String, dynamic> _$SubredditInfoToJson(_SubredditInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'display_name': instance.displayName,
      'title': instance.title,
      'display_name_prefixed': instance.displayNamePrefixed,
      'description': instance.description,
      'public_description': instance.publicDescription,
      'subscribers': instance.subscriberCount,
      'active_user_count': instance.activeUserCount,
      'icon_img': instance.iconImg,
      'header_img': instance.headerImg,
      'created_utc': instance.createdUtc,
      'over18': instance.over18,
    };
