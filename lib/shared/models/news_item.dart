import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vibechan/shared/enums/news_source.dart';

part 'news_item.freezed.dart';

@freezed
abstract class NewsItem with _$NewsItem {
  const factory NewsItem({
    required String id,
    required NewsSource source,
    String? title,
    String? url,
    String? body, // Could be plain text, HTML, or Markdown
    int? score,
    int? commentCount,
    String? authorName,
    DateTime? createdAt,
    List<String>? tags,
    @Default({}) Map<String, dynamic> metadata, // For source-specific data
    dynamic originalData, // Store the original data object if needed
  }) = _NewsItem;
}

@freezed
abstract class NewsComment with _$NewsComment {
  const factory NewsComment({
    required String id,
    required NewsSource source,
    String? text,
    String? authorName,
    DateTime? createdAt,
    int? score,
    int? depth,
    @Default([]) List<NewsComment> replies,
    @Default({}) Map<String, dynamic> metadata,
    dynamic originalData,
  }) = _NewsComment;
}
