// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fourchan_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FourChanPost _$FourChanPostFromJson(Map<String, dynamic> json) =>
    _FourChanPost(
      no: (json['no'] as num).toInt(),
      time: (json['time'] as num).toInt(),
      com: json['com'] as String,
      name: json['name'] as String?,
      trip: json['trip'] as String?,
      sub: json['sub'] as String?,
      filename: json['filename'] as String?,
      ext: json['ext'] as String?,
      w: (json['w'] as num?)?.toInt(),
      h: (json['h'] as num?)?.toInt(),
      fsize: (json['fsize'] as num?)?.toInt(),
      repliesTo:
          (json['replies_to'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$FourChanPostToJson(_FourChanPost instance) =>
    <String, dynamic>{
      'no': instance.no,
      'time': instance.time,
      'com': instance.com,
      'name': instance.name,
      'trip': instance.trip,
      'sub': instance.sub,
      'filename': instance.filename,
      'ext': instance.ext,
      'w': instance.w,
      'h': instance.h,
      'fsize': instance.fsize,
      'replies_to': instance.repliesTo,
    };
