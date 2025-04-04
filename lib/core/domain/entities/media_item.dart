import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_item.freezed.dart';

enum MediaType { image, video }

@freezed
abstract class MediaItem with _$MediaItem {
  const factory MediaItem({
    required String url,
    required MediaType type,
    required String sourceId, // Corrected syntax
    String? thumbnailUrl, // Optional thumbnail for videos or high-res images
    double? aspectRatio, // Optional aspect ratio if known
    int? width, // Optional width
    int? height, // Optional height
  }) = _MediaItem;
}
