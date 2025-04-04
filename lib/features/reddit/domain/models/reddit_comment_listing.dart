import 'package:freezed_annotation/freezed_annotation.dart';
import 'reddit_comment.dart'; // Import the comment model

part 'reddit_comment_listing.freezed.dart';
part 'reddit_comment_listing.g.dart';

// Represents the "Listing" object that contains replies
@freezed
abstract class RedditCommentListing with _$RedditCommentListing {
  const factory RedditCommentListing({
    required String kind, // Should be "Listing"
    required RedditCommentListingData data,
  }) = _RedditCommentListing;

  factory RedditCommentListing.fromJson(Map<String, dynamic> json) =>
      _$RedditCommentListingFromJson(json);
}

// Represents the "data" part of the replies listing
@freezed
abstract class RedditCommentListingData with _$RedditCommentListingData {
  const factory RedditCommentListingData({
    String? after,
    String? before,
    @RedditCommentConverter() required List<RedditComment> children,
  }) = _RedditCommentListingData;

  factory RedditCommentListingData.fromJson(Map<String, dynamic> json) =>
      _$RedditCommentListingDataFromJson(json);
}
