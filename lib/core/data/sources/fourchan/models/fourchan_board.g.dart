// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fourchan_board.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FourChanBoard _$FourChanBoardFromJson(Map<String, dynamic> json) =>
    _FourChanBoard(
      board: json['board'] as String,
      title: json['title'] as String,
      workSafe: (json['ws_board'] as num).toInt(),
      perPage: (json['per_page'] as num).toInt(),
      pages: (json['pages'] as num).toInt(),
      maxFilesize: (json['max_filesize'] as num).toInt(),
      metaDescription: json['meta_description'] as String? ?? '',
    );

Map<String, dynamic> _$FourChanBoardToJson(_FourChanBoard instance) =>
    <String, dynamic>{
      'board': instance.board,
      'title': instance.title,
      'ws_board': instance.workSafe,
      'per_page': instance.perPage,
      'pages': instance.pages,
      'max_filesize': instance.maxFilesize,
      'meta_description': instance.metaDescription,
    };
