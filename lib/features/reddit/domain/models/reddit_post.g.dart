// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reddit_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RedditPost _$RedditPostFromJson(Map<String, dynamic> json) => _RedditPost(
  id: json['id'] as String,
  subreddit: json['subreddit'] as String,
  title: json['title'] as String,
  author: json['author'] as String,
  score: (json['score'] as num).toInt(),
  numComments: (json['num_comments'] as num).toInt(),
  permalink: json['permalink'] as String,
  createdUtc: (json['created_utc'] as num).toDouble(),
  selftext: json['selftext'] as String? ?? '',
  selftextHtml: json['selftext_html'] as String?,
  url: json['url'] as String?,
  thumbnail: json['thumbnail'] as String?,
  isVideo: json['is_video'] as bool? ?? false,
  stickied: json['stickied'] as bool? ?? false,
  over18: json['over18'] as bool? ?? false,
  linkFlairText: json['link_flair_text'] as String?,
  authorFlairText: json['author_flair_text'] as String?,
);

Map<String, dynamic> _$RedditPostToJson(_RedditPost instance) =>
    <String, dynamic>{
      'id': instance.id,
      'subreddit': instance.subreddit,
      'title': instance.title,
      'author': instance.author,
      'score': instance.score,
      'num_comments': instance.numComments,
      'permalink': instance.permalink,
      'created_utc': instance.createdUtc,
      'selftext': instance.selftext,
      'selftext_html': instance.selftextHtml,
      'url': instance.url,
      'thumbnail': instance.thumbnail,
      'is_video': instance.isVideo,
      'stickied': instance.stickied,
      'over18': instance.over18,
      'link_flair_text': instance.linkFlairText,
      'author_flair_text': instance.authorFlairText,
    };
