// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reddit_comment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RedditComment {

 String get id; String get author; String get body; int get score; double get createdUtc; int get depth; RedditCommentListing? get replies;
/// Create a copy of RedditComment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RedditCommentCopyWith<RedditComment> get copyWith => _$RedditCommentCopyWithImpl<RedditComment>(this as RedditComment, _$identity);

  /// Serializes this RedditComment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RedditComment&&(identical(other.id, id) || other.id == id)&&(identical(other.author, author) || other.author == author)&&(identical(other.body, body) || other.body == body)&&(identical(other.score, score) || other.score == score)&&(identical(other.createdUtc, createdUtc) || other.createdUtc == createdUtc)&&(identical(other.depth, depth) || other.depth == depth)&&(identical(other.replies, replies) || other.replies == replies));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,author,body,score,createdUtc,depth,replies);

@override
String toString() {
  return 'RedditComment(id: $id, author: $author, body: $body, score: $score, createdUtc: $createdUtc, depth: $depth, replies: $replies)';
}


}

/// @nodoc
abstract mixin class $RedditCommentCopyWith<$Res>  {
  factory $RedditCommentCopyWith(RedditComment value, $Res Function(RedditComment) _then) = _$RedditCommentCopyWithImpl;
@useResult
$Res call({
 String id, String author, String body, int score, double createdUtc, int depth, RedditCommentListing? replies
});


$RedditCommentListingCopyWith<$Res>? get replies;

}
/// @nodoc
class _$RedditCommentCopyWithImpl<$Res>
    implements $RedditCommentCopyWith<$Res> {
  _$RedditCommentCopyWithImpl(this._self, this._then);

  final RedditComment _self;
  final $Res Function(RedditComment) _then;

/// Create a copy of RedditComment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? author = null,Object? body = null,Object? score = null,Object? createdUtc = null,Object? depth = null,Object? replies = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,createdUtc: null == createdUtc ? _self.createdUtc : createdUtc // ignore: cast_nullable_to_non_nullable
as double,depth: null == depth ? _self.depth : depth // ignore: cast_nullable_to_non_nullable
as int,replies: freezed == replies ? _self.replies : replies // ignore: cast_nullable_to_non_nullable
as RedditCommentListing?,
  ));
}
/// Create a copy of RedditComment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RedditCommentListingCopyWith<$Res>? get replies {
    if (_self.replies == null) {
    return null;
  }

  return $RedditCommentListingCopyWith<$Res>(_self.replies!, (value) {
    return _then(_self.copyWith(replies: value));
  });
}
}


/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _RedditComment implements RedditComment {
  const _RedditComment({required this.id, required this.author, required this.body, required this.score, required this.createdUtc, this.depth = 0, this.replies});
  factory _RedditComment.fromJson(Map<String, dynamic> json) => _$RedditCommentFromJson(json);

@override final  String id;
@override final  String author;
@override final  String body;
@override final  int score;
@override final  double createdUtc;
@override@JsonKey() final  int depth;
@override final  RedditCommentListing? replies;

/// Create a copy of RedditComment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RedditCommentCopyWith<_RedditComment> get copyWith => __$RedditCommentCopyWithImpl<_RedditComment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RedditCommentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RedditComment&&(identical(other.id, id) || other.id == id)&&(identical(other.author, author) || other.author == author)&&(identical(other.body, body) || other.body == body)&&(identical(other.score, score) || other.score == score)&&(identical(other.createdUtc, createdUtc) || other.createdUtc == createdUtc)&&(identical(other.depth, depth) || other.depth == depth)&&(identical(other.replies, replies) || other.replies == replies));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,author,body,score,createdUtc,depth,replies);

@override
String toString() {
  return 'RedditComment(id: $id, author: $author, body: $body, score: $score, createdUtc: $createdUtc, depth: $depth, replies: $replies)';
}


}

/// @nodoc
abstract mixin class _$RedditCommentCopyWith<$Res> implements $RedditCommentCopyWith<$Res> {
  factory _$RedditCommentCopyWith(_RedditComment value, $Res Function(_RedditComment) _then) = __$RedditCommentCopyWithImpl;
@override @useResult
$Res call({
 String id, String author, String body, int score, double createdUtc, int depth, RedditCommentListing? replies
});


@override $RedditCommentListingCopyWith<$Res>? get replies;

}
/// @nodoc
class __$RedditCommentCopyWithImpl<$Res>
    implements _$RedditCommentCopyWith<$Res> {
  __$RedditCommentCopyWithImpl(this._self, this._then);

  final _RedditComment _self;
  final $Res Function(_RedditComment) _then;

/// Create a copy of RedditComment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? author = null,Object? body = null,Object? score = null,Object? createdUtc = null,Object? depth = null,Object? replies = freezed,}) {
  return _then(_RedditComment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,createdUtc: null == createdUtc ? _self.createdUtc : createdUtc // ignore: cast_nullable_to_non_nullable
as double,depth: null == depth ? _self.depth : depth // ignore: cast_nullable_to_non_nullable
as int,replies: freezed == replies ? _self.replies : replies // ignore: cast_nullable_to_non_nullable
as RedditCommentListing?,
  ));
}

/// Create a copy of RedditComment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RedditCommentListingCopyWith<$Res>? get replies {
    if (_self.replies == null) {
    return null;
  }

  return $RedditCommentListingCopyWith<$Res>(_self.replies!, (value) {
    return _then(_self.copyWith(replies: value));
  });
}
}

// dart format on
