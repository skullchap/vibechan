// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Media _$MediaFromJson(Map<String, dynamic> json) => _Media(
  filename: json['filename'] as String,
  url: json['url'] as String,
  thumbnailUrl: json['thumbnailUrl'] as String,
  type: $enumDecode(_$MediaTypeEnumMap, json['type']),
  width: (json['width'] as num).toInt(),
  height: (json['height'] as num).toInt(),
  size: (json['size'] as num).toInt(),
  thumbnailWidth: (json['thumbnailWidth'] as num?)?.toInt(),
  thumbnailHeight: (json['thumbnailHeight'] as num?)?.toInt(),
  mimeType: json['mimeType'] as String?,
);

Map<String, dynamic> _$MediaToJson(_Media instance) => <String, dynamic>{
  'filename': instance.filename,
  'url': instance.url,
  'thumbnailUrl': instance.thumbnailUrl,
  'type': _$MediaTypeEnumMap[instance.type]!,
  'width': instance.width,
  'height': instance.height,
  'size': instance.size,
  'thumbnailWidth': instance.thumbnailWidth,
  'thumbnailHeight': instance.thumbnailHeight,
  'mimeType': instance.mimeType,
};

const _$MediaTypeEnumMap = {
  MediaType.image: 'image',
  MediaType.video: 'video',
  MediaType.gif: 'gif',
};
