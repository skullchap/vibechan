import 'package:freezed_annotation/freezed_annotation.dart';

part 'media.freezed.dart';
part 'media.g.dart';

enum MediaType {
  image,
  video,
  gif
}

@freezed
abstract class Media with _$Media {
  const factory Media({
    required String filename,
    required String url,
    required String thumbnailUrl,
    required MediaType type,
    required int width,
    required int height,
    required int size,
    int? thumbnailWidth,
    int? thumbnailHeight,
    String? mimeType,
  }) = _Media;

  factory Media.fromJson(Map<String, dynamic> json) => _$MediaFromJson(json);
}