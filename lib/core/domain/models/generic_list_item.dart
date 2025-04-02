import 'package:freezed_annotation/freezed_annotation.dart';

part 'generic_list_item.freezed.dart';
// No JSON serialization needed for this abstract model yet

enum MediaType { image, video, none }

enum ItemSource { fourchan, hackernews, reddit } // Add more sources as needed

@freezed
abstract class GenericListItem with _$GenericListItem {
  const factory GenericListItem({
    required String id,
    required ItemSource source,
    String? title,
    String? body, // Could be plain text, HTML, or Markdown depending on source
    String? thumbnailUrl,
    String? mediaUrl,
    @Default(MediaType.none) MediaType mediaType,
    DateTime? timestamp,
    @Default({})
    Map<String, dynamic>
    metadata, // For source-specific data (score, replies, author etc.)
    Object? originalData, // Optional: Store the original data object if needed
  }) = _GenericListItem;
}
