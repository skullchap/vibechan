// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reddit_comment_listing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RedditCommentListing _$RedditCommentListingFromJson(
  Map<String, dynamic> json,
) => _RedditCommentListing(
  kind: json['kind'] as String,
  data: RedditCommentListingData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RedditCommentListingToJson(
  _RedditCommentListing instance,
) => <String, dynamic>{'kind': instance.kind, 'data': instance.data};

_RedditCommentListingData _$RedditCommentListingDataFromJson(
  Map<String, dynamic> json,
) => _RedditCommentListingData(
  after: json['after'] as String?,
  before: json['before'] as String?,
  children:
      (json['children'] as List<dynamic>)
          .map(
            (e) => const RedditCommentConverter().fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
);

Map<String, dynamic> _$RedditCommentListingDataToJson(
  _RedditCommentListingData instance,
) => <String, dynamic>{
  'after': instance.after,
  'before': instance.before,
  'children':
      instance.children.map(const RedditCommentConverter().toJson).toList(),
};
