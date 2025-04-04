// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Post {

 String get id; String get boardId; String? get threadId; DateTime get timestamp; String? get name; String? get tripcode; String? get subject; String get comment; Media? get media; List<String> get referencedPosts; bool get isOp;
/// Create a copy of Post
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostCopyWith<Post> get copyWith => _$PostCopyWithImpl<Post>(this as Post, _$identity);

  /// Serializes this Post to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Post&&(identical(other.id, id) || other.id == id)&&(identical(other.boardId, boardId) || other.boardId == boardId)&&(identical(other.threadId, threadId) || other.threadId == threadId)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.name, name) || other.name == name)&&(identical(other.tripcode, tripcode) || other.tripcode == tripcode)&&(identical(other.subject, subject) || other.subject == subject)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.media, media) || other.media == media)&&const DeepCollectionEquality().equals(other.referencedPosts, referencedPosts)&&(identical(other.isOp, isOp) || other.isOp == isOp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,boardId,threadId,timestamp,name,tripcode,subject,comment,media,const DeepCollectionEquality().hash(referencedPosts),isOp);

@override
String toString() {
  return 'Post(id: $id, boardId: $boardId, threadId: $threadId, timestamp: $timestamp, name: $name, tripcode: $tripcode, subject: $subject, comment: $comment, media: $media, referencedPosts: $referencedPosts, isOp: $isOp)';
}


}

/// @nodoc
abstract mixin class $PostCopyWith<$Res>  {
  factory $PostCopyWith(Post value, $Res Function(Post) _then) = _$PostCopyWithImpl;
@useResult
$Res call({
 String id, String boardId, String? threadId, DateTime timestamp, String? name, String? tripcode, String? subject, String comment, Media? media, List<String> referencedPosts, bool isOp
});


$MediaCopyWith<$Res>? get media;

}
/// @nodoc
class _$PostCopyWithImpl<$Res>
    implements $PostCopyWith<$Res> {
  _$PostCopyWithImpl(this._self, this._then);

  final Post _self;
  final $Res Function(Post) _then;

/// Create a copy of Post
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? boardId = null,Object? threadId = freezed,Object? timestamp = null,Object? name = freezed,Object? tripcode = freezed,Object? subject = freezed,Object? comment = null,Object? media = freezed,Object? referencedPosts = null,Object? isOp = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,boardId: null == boardId ? _self.boardId : boardId // ignore: cast_nullable_to_non_nullable
as String,threadId: freezed == threadId ? _self.threadId : threadId // ignore: cast_nullable_to_non_nullable
as String?,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,tripcode: freezed == tripcode ? _self.tripcode : tripcode // ignore: cast_nullable_to_non_nullable
as String?,subject: freezed == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String?,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,media: freezed == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as Media?,referencedPosts: null == referencedPosts ? _self.referencedPosts : referencedPosts // ignore: cast_nullable_to_non_nullable
as List<String>,isOp: null == isOp ? _self.isOp : isOp // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of Post
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MediaCopyWith<$Res>? get media {
    if (_self.media == null) {
    return null;
  }

  return $MediaCopyWith<$Res>(_self.media!, (value) {
    return _then(_self.copyWith(media: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _Post implements Post {
  const _Post({required this.id, required this.boardId, this.threadId, required this.timestamp, this.name, this.tripcode, this.subject, required this.comment, this.media, final  List<String> referencedPosts = const [], this.isOp = false}): _referencedPosts = referencedPosts;
  factory _Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

@override final  String id;
@override final  String boardId;
@override final  String? threadId;
@override final  DateTime timestamp;
@override final  String? name;
@override final  String? tripcode;
@override final  String? subject;
@override final  String comment;
@override final  Media? media;
 final  List<String> _referencedPosts;
@override@JsonKey() List<String> get referencedPosts {
  if (_referencedPosts is EqualUnmodifiableListView) return _referencedPosts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_referencedPosts);
}

@override@JsonKey() final  bool isOp;

/// Create a copy of Post
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostCopyWith<_Post> get copyWith => __$PostCopyWithImpl<_Post>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Post&&(identical(other.id, id) || other.id == id)&&(identical(other.boardId, boardId) || other.boardId == boardId)&&(identical(other.threadId, threadId) || other.threadId == threadId)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.name, name) || other.name == name)&&(identical(other.tripcode, tripcode) || other.tripcode == tripcode)&&(identical(other.subject, subject) || other.subject == subject)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.media, media) || other.media == media)&&const DeepCollectionEquality().equals(other._referencedPosts, _referencedPosts)&&(identical(other.isOp, isOp) || other.isOp == isOp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,boardId,threadId,timestamp,name,tripcode,subject,comment,media,const DeepCollectionEquality().hash(_referencedPosts),isOp);

@override
String toString() {
  return 'Post(id: $id, boardId: $boardId, threadId: $threadId, timestamp: $timestamp, name: $name, tripcode: $tripcode, subject: $subject, comment: $comment, media: $media, referencedPosts: $referencedPosts, isOp: $isOp)';
}


}

/// @nodoc
abstract mixin class _$PostCopyWith<$Res> implements $PostCopyWith<$Res> {
  factory _$PostCopyWith(_Post value, $Res Function(_Post) _then) = __$PostCopyWithImpl;
@override @useResult
$Res call({
 String id, String boardId, String? threadId, DateTime timestamp, String? name, String? tripcode, String? subject, String comment, Media? media, List<String> referencedPosts, bool isOp
});


@override $MediaCopyWith<$Res>? get media;

}
/// @nodoc
class __$PostCopyWithImpl<$Res>
    implements _$PostCopyWith<$Res> {
  __$PostCopyWithImpl(this._self, this._then);

  final _Post _self;
  final $Res Function(_Post) _then;

/// Create a copy of Post
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? boardId = null,Object? threadId = freezed,Object? timestamp = null,Object? name = freezed,Object? tripcode = freezed,Object? subject = freezed,Object? comment = null,Object? media = freezed,Object? referencedPosts = null,Object? isOp = null,}) {
  return _then(_Post(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,boardId: null == boardId ? _self.boardId : boardId // ignore: cast_nullable_to_non_nullable
as String,threadId: freezed == threadId ? _self.threadId : threadId // ignore: cast_nullable_to_non_nullable
as String?,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,tripcode: freezed == tripcode ? _self.tripcode : tripcode // ignore: cast_nullable_to_non_nullable
as String?,subject: freezed == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String?,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,media: freezed == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as Media?,referencedPosts: null == referencedPosts ? _self._referencedPosts : referencedPosts // ignore: cast_nullable_to_non_nullable
as List<String>,isOp: null == isOp ? _self.isOp : isOp // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of Post
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MediaCopyWith<$Res>? get media {
    if (_self.media == null) {
    return null;
  }

  return $MediaCopyWith<$Res>(_self.media!, (value) {
    return _then(_self.copyWith(media: value));
  });
}
}

// dart format on
