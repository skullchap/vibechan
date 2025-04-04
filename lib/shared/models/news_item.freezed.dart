// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'news_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NewsItem {

 String get id; NewsSource get source; String? get title; String? get url; String? get body;// Could be plain text, HTML, or Markdown
 int? get score; int? get commentCount; String? get authorName; DateTime? get createdAt; List<String>? get tags; Map<String, dynamic> get metadata;// For source-specific data
 dynamic get originalData;
/// Create a copy of NewsItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NewsItemCopyWith<NewsItem> get copyWith => _$NewsItemCopyWithImpl<NewsItem>(this as NewsItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NewsItem&&(identical(other.id, id) || other.id == id)&&(identical(other.source, source) || other.source == source)&&(identical(other.title, title) || other.title == title)&&(identical(other.url, url) || other.url == url)&&(identical(other.body, body) || other.body == body)&&(identical(other.score, score) || other.score == score)&&(identical(other.commentCount, commentCount) || other.commentCount == commentCount)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.tags, tags)&&const DeepCollectionEquality().equals(other.metadata, metadata)&&const DeepCollectionEquality().equals(other.originalData, originalData));
}


@override
int get hashCode => Object.hash(runtimeType,id,source,title,url,body,score,commentCount,authorName,createdAt,const DeepCollectionEquality().hash(tags),const DeepCollectionEquality().hash(metadata),const DeepCollectionEquality().hash(originalData));

@override
String toString() {
  return 'NewsItem(id: $id, source: $source, title: $title, url: $url, body: $body, score: $score, commentCount: $commentCount, authorName: $authorName, createdAt: $createdAt, tags: $tags, metadata: $metadata, originalData: $originalData)';
}


}

/// @nodoc
abstract mixin class $NewsItemCopyWith<$Res>  {
  factory $NewsItemCopyWith(NewsItem value, $Res Function(NewsItem) _then) = _$NewsItemCopyWithImpl;
@useResult
$Res call({
 String id, NewsSource source, String? title, String? url, String? body, int? score, int? commentCount, String? authorName, DateTime? createdAt, List<String>? tags, Map<String, dynamic> metadata, dynamic originalData
});




}
/// @nodoc
class _$NewsItemCopyWithImpl<$Res>
    implements $NewsItemCopyWith<$Res> {
  _$NewsItemCopyWithImpl(this._self, this._then);

  final NewsItem _self;
  final $Res Function(NewsItem) _then;

/// Create a copy of NewsItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? source = null,Object? title = freezed,Object? url = freezed,Object? body = freezed,Object? score = freezed,Object? commentCount = freezed,Object? authorName = freezed,Object? createdAt = freezed,Object? tags = freezed,Object? metadata = null,Object? originalData = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as NewsSource,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,score: freezed == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int?,commentCount: freezed == commentCount ? _self.commentCount : commentCount // ignore: cast_nullable_to_non_nullable
as int?,authorName: freezed == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,tags: freezed == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>?,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,originalData: freezed == originalData ? _self.originalData : originalData // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}

}


/// @nodoc


class _NewsItem implements NewsItem {
  const _NewsItem({required this.id, required this.source, this.title, this.url, this.body, this.score, this.commentCount, this.authorName, this.createdAt, final  List<String>? tags, final  Map<String, dynamic> metadata = const {}, this.originalData}): _tags = tags,_metadata = metadata;
  

@override final  String id;
@override final  NewsSource source;
@override final  String? title;
@override final  String? url;
@override final  String? body;
// Could be plain text, HTML, or Markdown
@override final  int? score;
@override final  int? commentCount;
@override final  String? authorName;
@override final  DateTime? createdAt;
 final  List<String>? _tags;
@override List<String>? get tags {
  final value = _tags;
  if (value == null) return null;
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  Map<String, dynamic> _metadata;
@override@JsonKey() Map<String, dynamic> get metadata {
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_metadata);
}

// For source-specific data
@override final  dynamic originalData;

/// Create a copy of NewsItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NewsItemCopyWith<_NewsItem> get copyWith => __$NewsItemCopyWithImpl<_NewsItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NewsItem&&(identical(other.id, id) || other.id == id)&&(identical(other.source, source) || other.source == source)&&(identical(other.title, title) || other.title == title)&&(identical(other.url, url) || other.url == url)&&(identical(other.body, body) || other.body == body)&&(identical(other.score, score) || other.score == score)&&(identical(other.commentCount, commentCount) || other.commentCount == commentCount)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._tags, _tags)&&const DeepCollectionEquality().equals(other._metadata, _metadata)&&const DeepCollectionEquality().equals(other.originalData, originalData));
}


@override
int get hashCode => Object.hash(runtimeType,id,source,title,url,body,score,commentCount,authorName,createdAt,const DeepCollectionEquality().hash(_tags),const DeepCollectionEquality().hash(_metadata),const DeepCollectionEquality().hash(originalData));

@override
String toString() {
  return 'NewsItem(id: $id, source: $source, title: $title, url: $url, body: $body, score: $score, commentCount: $commentCount, authorName: $authorName, createdAt: $createdAt, tags: $tags, metadata: $metadata, originalData: $originalData)';
}


}

/// @nodoc
abstract mixin class _$NewsItemCopyWith<$Res> implements $NewsItemCopyWith<$Res> {
  factory _$NewsItemCopyWith(_NewsItem value, $Res Function(_NewsItem) _then) = __$NewsItemCopyWithImpl;
@override @useResult
$Res call({
 String id, NewsSource source, String? title, String? url, String? body, int? score, int? commentCount, String? authorName, DateTime? createdAt, List<String>? tags, Map<String, dynamic> metadata, dynamic originalData
});




}
/// @nodoc
class __$NewsItemCopyWithImpl<$Res>
    implements _$NewsItemCopyWith<$Res> {
  __$NewsItemCopyWithImpl(this._self, this._then);

  final _NewsItem _self;
  final $Res Function(_NewsItem) _then;

/// Create a copy of NewsItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? source = null,Object? title = freezed,Object? url = freezed,Object? body = freezed,Object? score = freezed,Object? commentCount = freezed,Object? authorName = freezed,Object? createdAt = freezed,Object? tags = freezed,Object? metadata = null,Object? originalData = freezed,}) {
  return _then(_NewsItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as NewsSource,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,score: freezed == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int?,commentCount: freezed == commentCount ? _self.commentCount : commentCount // ignore: cast_nullable_to_non_nullable
as int?,authorName: freezed == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,tags: freezed == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>?,metadata: null == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,originalData: freezed == originalData ? _self.originalData : originalData // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}


}

/// @nodoc
mixin _$NewsComment {

 String get id; NewsSource get source; String? get text; String? get authorName; DateTime? get createdAt; int? get score; int? get depth; List<NewsComment> get replies; Map<String, dynamic> get metadata; dynamic get originalData;
/// Create a copy of NewsComment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NewsCommentCopyWith<NewsComment> get copyWith => _$NewsCommentCopyWithImpl<NewsComment>(this as NewsComment, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NewsComment&&(identical(other.id, id) || other.id == id)&&(identical(other.source, source) || other.source == source)&&(identical(other.text, text) || other.text == text)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.score, score) || other.score == score)&&(identical(other.depth, depth) || other.depth == depth)&&const DeepCollectionEquality().equals(other.replies, replies)&&const DeepCollectionEquality().equals(other.metadata, metadata)&&const DeepCollectionEquality().equals(other.originalData, originalData));
}


@override
int get hashCode => Object.hash(runtimeType,id,source,text,authorName,createdAt,score,depth,const DeepCollectionEquality().hash(replies),const DeepCollectionEquality().hash(metadata),const DeepCollectionEquality().hash(originalData));

@override
String toString() {
  return 'NewsComment(id: $id, source: $source, text: $text, authorName: $authorName, createdAt: $createdAt, score: $score, depth: $depth, replies: $replies, metadata: $metadata, originalData: $originalData)';
}


}

/// @nodoc
abstract mixin class $NewsCommentCopyWith<$Res>  {
  factory $NewsCommentCopyWith(NewsComment value, $Res Function(NewsComment) _then) = _$NewsCommentCopyWithImpl;
@useResult
$Res call({
 String id, NewsSource source, String? text, String? authorName, DateTime? createdAt, int? score, int? depth, List<NewsComment> replies, Map<String, dynamic> metadata, dynamic originalData
});




}
/// @nodoc
class _$NewsCommentCopyWithImpl<$Res>
    implements $NewsCommentCopyWith<$Res> {
  _$NewsCommentCopyWithImpl(this._self, this._then);

  final NewsComment _self;
  final $Res Function(NewsComment) _then;

/// Create a copy of NewsComment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? source = null,Object? text = freezed,Object? authorName = freezed,Object? createdAt = freezed,Object? score = freezed,Object? depth = freezed,Object? replies = null,Object? metadata = null,Object? originalData = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as NewsSource,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,authorName: freezed == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,score: freezed == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int?,depth: freezed == depth ? _self.depth : depth // ignore: cast_nullable_to_non_nullable
as int?,replies: null == replies ? _self.replies : replies // ignore: cast_nullable_to_non_nullable
as List<NewsComment>,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,originalData: freezed == originalData ? _self.originalData : originalData // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}

}


/// @nodoc


class _NewsComment implements NewsComment {
  const _NewsComment({required this.id, required this.source, this.text, this.authorName, this.createdAt, this.score, this.depth, final  List<NewsComment> replies = const [], final  Map<String, dynamic> metadata = const {}, this.originalData}): _replies = replies,_metadata = metadata;
  

@override final  String id;
@override final  NewsSource source;
@override final  String? text;
@override final  String? authorName;
@override final  DateTime? createdAt;
@override final  int? score;
@override final  int? depth;
 final  List<NewsComment> _replies;
@override@JsonKey() List<NewsComment> get replies {
  if (_replies is EqualUnmodifiableListView) return _replies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_replies);
}

 final  Map<String, dynamic> _metadata;
@override@JsonKey() Map<String, dynamic> get metadata {
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_metadata);
}

@override final  dynamic originalData;

/// Create a copy of NewsComment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NewsCommentCopyWith<_NewsComment> get copyWith => __$NewsCommentCopyWithImpl<_NewsComment>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NewsComment&&(identical(other.id, id) || other.id == id)&&(identical(other.source, source) || other.source == source)&&(identical(other.text, text) || other.text == text)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.score, score) || other.score == score)&&(identical(other.depth, depth) || other.depth == depth)&&const DeepCollectionEquality().equals(other._replies, _replies)&&const DeepCollectionEquality().equals(other._metadata, _metadata)&&const DeepCollectionEquality().equals(other.originalData, originalData));
}


@override
int get hashCode => Object.hash(runtimeType,id,source,text,authorName,createdAt,score,depth,const DeepCollectionEquality().hash(_replies),const DeepCollectionEquality().hash(_metadata),const DeepCollectionEquality().hash(originalData));

@override
String toString() {
  return 'NewsComment(id: $id, source: $source, text: $text, authorName: $authorName, createdAt: $createdAt, score: $score, depth: $depth, replies: $replies, metadata: $metadata, originalData: $originalData)';
}


}

/// @nodoc
abstract mixin class _$NewsCommentCopyWith<$Res> implements $NewsCommentCopyWith<$Res> {
  factory _$NewsCommentCopyWith(_NewsComment value, $Res Function(_NewsComment) _then) = __$NewsCommentCopyWithImpl;
@override @useResult
$Res call({
 String id, NewsSource source, String? text, String? authorName, DateTime? createdAt, int? score, int? depth, List<NewsComment> replies, Map<String, dynamic> metadata, dynamic originalData
});




}
/// @nodoc
class __$NewsCommentCopyWithImpl<$Res>
    implements _$NewsCommentCopyWith<$Res> {
  __$NewsCommentCopyWithImpl(this._self, this._then);

  final _NewsComment _self;
  final $Res Function(_NewsComment) _then;

/// Create a copy of NewsComment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? source = null,Object? text = freezed,Object? authorName = freezed,Object? createdAt = freezed,Object? score = freezed,Object? depth = freezed,Object? replies = null,Object? metadata = null,Object? originalData = freezed,}) {
  return _then(_NewsComment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as NewsSource,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,authorName: freezed == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,score: freezed == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int?,depth: freezed == depth ? _self.depth : depth // ignore: cast_nullable_to_non_nullable
as int?,replies: null == replies ? _self._replies : replies // ignore: cast_nullable_to_non_nullable
as List<NewsComment>,metadata: null == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,originalData: freezed == originalData ? _self.originalData : originalData // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}


}

// dart format on
