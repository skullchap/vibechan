// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reddit_post.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RedditPost {

 String get id; String get subreddit; String get title; String get author; int get score; int get numComments; String get permalink; double get createdUtc;// Keep as double for precision from Unix timestamp
 String get selftext; String? get selftextHtml;// Add HTML field
 String? get url;// Link or media URL
 String? get thumbnail;// URL for thumbnail
 bool get isVideo;// Consider adding 'media' or 'preview' for richer media handling later
 bool get stickied; bool get over18; String? get linkFlairText; String? get authorFlairText;
/// Create a copy of RedditPost
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RedditPostCopyWith<RedditPost> get copyWith => _$RedditPostCopyWithImpl<RedditPost>(this as RedditPost, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RedditPost&&(identical(other.id, id) || other.id == id)&&(identical(other.subreddit, subreddit) || other.subreddit == subreddit)&&(identical(other.title, title) || other.title == title)&&(identical(other.author, author) || other.author == author)&&(identical(other.score, score) || other.score == score)&&(identical(other.numComments, numComments) || other.numComments == numComments)&&(identical(other.permalink, permalink) || other.permalink == permalink)&&(identical(other.createdUtc, createdUtc) || other.createdUtc == createdUtc)&&(identical(other.selftext, selftext) || other.selftext == selftext)&&(identical(other.selftextHtml, selftextHtml) || other.selftextHtml == selftextHtml)&&(identical(other.url, url) || other.url == url)&&(identical(other.thumbnail, thumbnail) || other.thumbnail == thumbnail)&&(identical(other.isVideo, isVideo) || other.isVideo == isVideo)&&(identical(other.stickied, stickied) || other.stickied == stickied)&&(identical(other.over18, over18) || other.over18 == over18)&&(identical(other.linkFlairText, linkFlairText) || other.linkFlairText == linkFlairText)&&(identical(other.authorFlairText, authorFlairText) || other.authorFlairText == authorFlairText));
}


@override
int get hashCode => Object.hash(runtimeType,id,subreddit,title,author,score,numComments,permalink,createdUtc,selftext,selftextHtml,url,thumbnail,isVideo,stickied,over18,linkFlairText,authorFlairText);

@override
String toString() {
  return 'RedditPost(id: $id, subreddit: $subreddit, title: $title, author: $author, score: $score, numComments: $numComments, permalink: $permalink, createdUtc: $createdUtc, selftext: $selftext, selftextHtml: $selftextHtml, url: $url, thumbnail: $thumbnail, isVideo: $isVideo, stickied: $stickied, over18: $over18, linkFlairText: $linkFlairText, authorFlairText: $authorFlairText)';
}


}

/// @nodoc
abstract mixin class $RedditPostCopyWith<$Res>  {
  factory $RedditPostCopyWith(RedditPost value, $Res Function(RedditPost) _then) = _$RedditPostCopyWithImpl;
@useResult
$Res call({
 String id, String subreddit, String title, String author, int score, int numComments, String permalink, double createdUtc, String selftext, String? selftextHtml, String? url, String? thumbnail, bool isVideo, bool stickied, bool over18, String? linkFlairText, String? authorFlairText
});




}
/// @nodoc
class _$RedditPostCopyWithImpl<$Res>
    implements $RedditPostCopyWith<$Res> {
  _$RedditPostCopyWithImpl(this._self, this._then);

  final RedditPost _self;
  final $Res Function(RedditPost) _then;

/// Create a copy of RedditPost
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? subreddit = null,Object? title = null,Object? author = null,Object? score = null,Object? numComments = null,Object? permalink = null,Object? createdUtc = null,Object? selftext = null,Object? selftextHtml = freezed,Object? url = freezed,Object? thumbnail = freezed,Object? isVideo = null,Object? stickied = null,Object? over18 = null,Object? linkFlairText = freezed,Object? authorFlairText = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,subreddit: null == subreddit ? _self.subreddit : subreddit // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,numComments: null == numComments ? _self.numComments : numComments // ignore: cast_nullable_to_non_nullable
as int,permalink: null == permalink ? _self.permalink : permalink // ignore: cast_nullable_to_non_nullable
as String,createdUtc: null == createdUtc ? _self.createdUtc : createdUtc // ignore: cast_nullable_to_non_nullable
as double,selftext: null == selftext ? _self.selftext : selftext // ignore: cast_nullable_to_non_nullable
as String,selftextHtml: freezed == selftextHtml ? _self.selftextHtml : selftextHtml // ignore: cast_nullable_to_non_nullable
as String?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,thumbnail: freezed == thumbnail ? _self.thumbnail : thumbnail // ignore: cast_nullable_to_non_nullable
as String?,isVideo: null == isVideo ? _self.isVideo : isVideo // ignore: cast_nullable_to_non_nullable
as bool,stickied: null == stickied ? _self.stickied : stickied // ignore: cast_nullable_to_non_nullable
as bool,over18: null == over18 ? _self.over18 : over18 // ignore: cast_nullable_to_non_nullable
as bool,linkFlairText: freezed == linkFlairText ? _self.linkFlairText : linkFlairText // ignore: cast_nullable_to_non_nullable
as String?,authorFlairText: freezed == authorFlairText ? _self.authorFlairText : authorFlairText // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _RedditPost implements RedditPost {
  const _RedditPost({required this.id, required this.subreddit, required this.title, required this.author, required this.score, required this.numComments, required this.permalink, required this.createdUtc, this.selftext = '', this.selftextHtml, this.url, this.thumbnail, this.isVideo = false, this.stickied = false, this.over18 = false, this.linkFlairText, this.authorFlairText});
  

@override final  String id;
@override final  String subreddit;
@override final  String title;
@override final  String author;
@override final  int score;
@override final  int numComments;
@override final  String permalink;
@override final  double createdUtc;
// Keep as double for precision from Unix timestamp
@override@JsonKey() final  String selftext;
@override final  String? selftextHtml;
// Add HTML field
@override final  String? url;
// Link or media URL
@override final  String? thumbnail;
// URL for thumbnail
@override@JsonKey() final  bool isVideo;
// Consider adding 'media' or 'preview' for richer media handling later
@override@JsonKey() final  bool stickied;
@override@JsonKey() final  bool over18;
@override final  String? linkFlairText;
@override final  String? authorFlairText;

/// Create a copy of RedditPost
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RedditPostCopyWith<_RedditPost> get copyWith => __$RedditPostCopyWithImpl<_RedditPost>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RedditPost&&(identical(other.id, id) || other.id == id)&&(identical(other.subreddit, subreddit) || other.subreddit == subreddit)&&(identical(other.title, title) || other.title == title)&&(identical(other.author, author) || other.author == author)&&(identical(other.score, score) || other.score == score)&&(identical(other.numComments, numComments) || other.numComments == numComments)&&(identical(other.permalink, permalink) || other.permalink == permalink)&&(identical(other.createdUtc, createdUtc) || other.createdUtc == createdUtc)&&(identical(other.selftext, selftext) || other.selftext == selftext)&&(identical(other.selftextHtml, selftextHtml) || other.selftextHtml == selftextHtml)&&(identical(other.url, url) || other.url == url)&&(identical(other.thumbnail, thumbnail) || other.thumbnail == thumbnail)&&(identical(other.isVideo, isVideo) || other.isVideo == isVideo)&&(identical(other.stickied, stickied) || other.stickied == stickied)&&(identical(other.over18, over18) || other.over18 == over18)&&(identical(other.linkFlairText, linkFlairText) || other.linkFlairText == linkFlairText)&&(identical(other.authorFlairText, authorFlairText) || other.authorFlairText == authorFlairText));
}


@override
int get hashCode => Object.hash(runtimeType,id,subreddit,title,author,score,numComments,permalink,createdUtc,selftext,selftextHtml,url,thumbnail,isVideo,stickied,over18,linkFlairText,authorFlairText);

@override
String toString() {
  return 'RedditPost(id: $id, subreddit: $subreddit, title: $title, author: $author, score: $score, numComments: $numComments, permalink: $permalink, createdUtc: $createdUtc, selftext: $selftext, selftextHtml: $selftextHtml, url: $url, thumbnail: $thumbnail, isVideo: $isVideo, stickied: $stickied, over18: $over18, linkFlairText: $linkFlairText, authorFlairText: $authorFlairText)';
}


}

/// @nodoc
abstract mixin class _$RedditPostCopyWith<$Res> implements $RedditPostCopyWith<$Res> {
  factory _$RedditPostCopyWith(_RedditPost value, $Res Function(_RedditPost) _then) = __$RedditPostCopyWithImpl;
@override @useResult
$Res call({
 String id, String subreddit, String title, String author, int score, int numComments, String permalink, double createdUtc, String selftext, String? selftextHtml, String? url, String? thumbnail, bool isVideo, bool stickied, bool over18, String? linkFlairText, String? authorFlairText
});




}
/// @nodoc
class __$RedditPostCopyWithImpl<$Res>
    implements _$RedditPostCopyWith<$Res> {
  __$RedditPostCopyWithImpl(this._self, this._then);

  final _RedditPost _self;
  final $Res Function(_RedditPost) _then;

/// Create a copy of RedditPost
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? subreddit = null,Object? title = null,Object? author = null,Object? score = null,Object? numComments = null,Object? permalink = null,Object? createdUtc = null,Object? selftext = null,Object? selftextHtml = freezed,Object? url = freezed,Object? thumbnail = freezed,Object? isVideo = null,Object? stickied = null,Object? over18 = null,Object? linkFlairText = freezed,Object? authorFlairText = freezed,}) {
  return _then(_RedditPost(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,subreddit: null == subreddit ? _self.subreddit : subreddit // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,numComments: null == numComments ? _self.numComments : numComments // ignore: cast_nullable_to_non_nullable
as int,permalink: null == permalink ? _self.permalink : permalink // ignore: cast_nullable_to_non_nullable
as String,createdUtc: null == createdUtc ? _self.createdUtc : createdUtc // ignore: cast_nullable_to_non_nullable
as double,selftext: null == selftext ? _self.selftext : selftext // ignore: cast_nullable_to_non_nullable
as String,selftextHtml: freezed == selftextHtml ? _self.selftextHtml : selftextHtml // ignore: cast_nullable_to_non_nullable
as String?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,thumbnail: freezed == thumbnail ? _self.thumbnail : thumbnail // ignore: cast_nullable_to_non_nullable
as String?,isVideo: null == isVideo ? _self.isVideo : isVideo // ignore: cast_nullable_to_non_nullable
as bool,stickied: null == stickied ? _self.stickied : stickied // ignore: cast_nullable_to_non_nullable
as bool,over18: null == over18 ? _self.over18 : over18 // ignore: cast_nullable_to_non_nullable
as bool,linkFlairText: freezed == linkFlairText ? _self.linkFlairText : linkFlairText // ignore: cast_nullable_to_non_nullable
as String?,authorFlairText: freezed == authorFlairText ? _self.authorFlairText : authorFlairText // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
