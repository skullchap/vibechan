// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fourchan_thread.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FourChanThread _$FourChanThreadFromJson(Map<String, dynamic> json) =>
    _FourChanThread(
      no: (json['no'] as num).toInt(),
      isSticky: (json['sticky'] as num?)?.toInt() ?? 0,
      isClosed: (json['closed'] as num?)?.toInt() ?? 0,
      time: (json['time'] as num).toInt(),
      posts:
          (json['posts'] as List<dynamic>?)
              ?.map((e) => FourChanPost.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      replies: (json['replies'] as num?)?.toInt() ?? 0,
      images: (json['images'] as num?)?.toInt() ?? 0,
      com: json['com'] as String,
      sub: json['sub'] as String?,
      filename: json['filename'] as String?,
      ext: json['ext'] as String?,
      w: (json['w'] as num?)?.toInt(),
      h: (json['h'] as num?)?.toInt(),
      fsize: (json['fsize'] as num?)?.toInt(),
    );

Map<String, dynamic> _$FourChanThreadToJson(_FourChanThread instance) =>
    <String, dynamic>{
      'no': instance.no,
      'sticky': instance.isSticky,
      'closed': instance.isClosed,
      'time': instance.time,
      'posts': instance.posts,
      'replies': instance.replies,
      'images': instance.images,
      'com': instance.com,
      'sub': instance.sub,
      'filename': instance.filename,
      'ext': instance.ext,
      'w': instance.w,
      'h': instance.h,
      'fsize': instance.fsize,
    };
