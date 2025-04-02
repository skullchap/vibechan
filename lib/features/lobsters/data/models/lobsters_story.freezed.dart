// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lobsters_story.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LobstersStory {

 String get shortId; DateTime get createdAt; String get title; String get url; int get score; int get commentCount; String? get description; String get commentsUrl; List<String> get tags; String get submitterUser;
/// Create a copy of LobstersStory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LobstersStoryCopyWith<LobstersStory> get copyWith => _$LobstersStoryCopyWithImpl<LobstersStory>(this as LobstersStory, _$identity);

  /// Serializes this LobstersStory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LobstersStory&&(identical(other.shortId, shortId) || other.shortId == shortId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.title, title) || other.title == title)&&(identical(other.url, url) || other.url == url)&&(identical(other.score, score) || other.score == score)&&(identical(other.commentCount, commentCount) || other.commentCount == commentCount)&&(identical(other.description, description) || other.description == description)&&(identical(other.commentsUrl, commentsUrl) || other.commentsUrl == commentsUrl)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.submitterUser, submitterUser) || other.submitterUser == submitterUser));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,shortId,createdAt,title,url,score,commentCount,description,commentsUrl,const DeepCollectionEquality().hash(tags),submitterUser);

@override
String toString() {
  return 'LobstersStory(shortId: $shortId, createdAt: $createdAt, title: $title, url: $url, score: $score, commentCount: $commentCount, description: $description, commentsUrl: $commentsUrl, tags: $tags, submitterUser: $submitterUser)';
}


}

/// @nodoc
abstract mixin class $LobstersStoryCopyWith<$Res>  {
  factory $LobstersStoryCopyWith(LobstersStory value, $Res Function(LobstersStory) _then) = _$LobstersStoryCopyWithImpl;
@useResult
$Res call({
 String shortId, DateTime createdAt, String title, String url, int score, int commentCount, String? description, String commentsUrl, List<String> tags, String submitterUser
});




}
/// @nodoc
class _$LobstersStoryCopyWithImpl<$Res>
    implements $LobstersStoryCopyWith<$Res> {
  _$LobstersStoryCopyWithImpl(this._self, this._then);

  final LobstersStory _self;
  final $Res Function(LobstersStory) _then;

/// Create a copy of LobstersStory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? shortId = null,Object? createdAt = null,Object? title = null,Object? url = null,Object? score = null,Object? commentCount = null,Object? description = freezed,Object? commentsUrl = null,Object? tags = null,Object? submitterUser = null,}) {
  return _then(_self.copyWith(
shortId: null == shortId ? _self.shortId : shortId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,commentCount: null == commentCount ? _self.commentCount : commentCount // ignore: cast_nullable_to_non_nullable
as int,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,commentsUrl: null == commentsUrl ? _self.commentsUrl : commentsUrl // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,submitterUser: null == submitterUser ? _self.submitterUser : submitterUser // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _LobstersStory implements LobstersStory {
  const _LobstersStory({required this.shortId, required this.createdAt, required this.title, required this.url, required this.score, required this.commentCount, this.description, required this.commentsUrl, required final  List<String> tags, required this.submitterUser}): _tags = tags;
  factory _LobstersStory.fromJson(Map<String, dynamic> json) => _$LobstersStoryFromJson(json);

@override final  String shortId;
@override final  DateTime createdAt;
@override final  String title;
@override final  String url;
@override final  int score;
@override final  int commentCount;
@override final  String? description;
@override final  String commentsUrl;
 final  List<String> _tags;
@override List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override final  String submitterUser;

/// Create a copy of LobstersStory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LobstersStoryCopyWith<_LobstersStory> get copyWith => __$LobstersStoryCopyWithImpl<_LobstersStory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LobstersStoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LobstersStory&&(identical(other.shortId, shortId) || other.shortId == shortId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.title, title) || other.title == title)&&(identical(other.url, url) || other.url == url)&&(identical(other.score, score) || other.score == score)&&(identical(other.commentCount, commentCount) || other.commentCount == commentCount)&&(identical(other.description, description) || other.description == description)&&(identical(other.commentsUrl, commentsUrl) || other.commentsUrl == commentsUrl)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.submitterUser, submitterUser) || other.submitterUser == submitterUser));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,shortId,createdAt,title,url,score,commentCount,description,commentsUrl,const DeepCollectionEquality().hash(_tags),submitterUser);

@override
String toString() {
  return 'LobstersStory(shortId: $shortId, createdAt: $createdAt, title: $title, url: $url, score: $score, commentCount: $commentCount, description: $description, commentsUrl: $commentsUrl, tags: $tags, submitterUser: $submitterUser)';
}


}

/// @nodoc
abstract mixin class _$LobstersStoryCopyWith<$Res> implements $LobstersStoryCopyWith<$Res> {
  factory _$LobstersStoryCopyWith(_LobstersStory value, $Res Function(_LobstersStory) _then) = __$LobstersStoryCopyWithImpl;
@override @useResult
$Res call({
 String shortId, DateTime createdAt, String title, String url, int score, int commentCount, String? description, String commentsUrl, List<String> tags, String submitterUser
});




}
/// @nodoc
class __$LobstersStoryCopyWithImpl<$Res>
    implements _$LobstersStoryCopyWith<$Res> {
  __$LobstersStoryCopyWithImpl(this._self, this._then);

  final _LobstersStory _self;
  final $Res Function(_LobstersStory) _then;

/// Create a copy of LobstersStory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? shortId = null,Object? createdAt = null,Object? title = null,Object? url = null,Object? score = null,Object? commentCount = null,Object? description = freezed,Object? commentsUrl = null,Object? tags = null,Object? submitterUser = null,}) {
  return _then(_LobstersStory(
shortId: null == shortId ? _self.shortId : shortId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,commentCount: null == commentCount ? _self.commentCount : commentCount // ignore: cast_nullable_to_non_nullable
as int,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,commentsUrl: null == commentsUrl ? _self.commentsUrl : commentsUrl // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,submitterUser: null == submitterUser ? _self.submitterUser : submitterUser // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
