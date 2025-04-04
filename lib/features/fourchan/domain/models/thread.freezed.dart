// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'thread.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Thread {

 String get id; String get boardId; Post get originalPost; List<Post> get replies; bool get isSticky; bool get isClosed; bool get isWatched; DateTime? get lastModified; int? get repliesCount; int? get imagesCount;
/// Create a copy of Thread
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ThreadCopyWith<Thread> get copyWith => _$ThreadCopyWithImpl<Thread>(this as Thread, _$identity);

  /// Serializes this Thread to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Thread&&(identical(other.id, id) || other.id == id)&&(identical(other.boardId, boardId) || other.boardId == boardId)&&(identical(other.originalPost, originalPost) || other.originalPost == originalPost)&&const DeepCollectionEquality().equals(other.replies, replies)&&(identical(other.isSticky, isSticky) || other.isSticky == isSticky)&&(identical(other.isClosed, isClosed) || other.isClosed == isClosed)&&(identical(other.isWatched, isWatched) || other.isWatched == isWatched)&&(identical(other.lastModified, lastModified) || other.lastModified == lastModified)&&(identical(other.repliesCount, repliesCount) || other.repliesCount == repliesCount)&&(identical(other.imagesCount, imagesCount) || other.imagesCount == imagesCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,boardId,originalPost,const DeepCollectionEquality().hash(replies),isSticky,isClosed,isWatched,lastModified,repliesCount,imagesCount);

@override
String toString() {
  return 'Thread(id: $id, boardId: $boardId, originalPost: $originalPost, replies: $replies, isSticky: $isSticky, isClosed: $isClosed, isWatched: $isWatched, lastModified: $lastModified, repliesCount: $repliesCount, imagesCount: $imagesCount)';
}


}

/// @nodoc
abstract mixin class $ThreadCopyWith<$Res>  {
  factory $ThreadCopyWith(Thread value, $Res Function(Thread) _then) = _$ThreadCopyWithImpl;
@useResult
$Res call({
 String id, String boardId, Post originalPost, List<Post> replies, bool isSticky, bool isClosed, bool isWatched, DateTime? lastModified, int? repliesCount, int? imagesCount
});


$PostCopyWith<$Res> get originalPost;

}
/// @nodoc
class _$ThreadCopyWithImpl<$Res>
    implements $ThreadCopyWith<$Res> {
  _$ThreadCopyWithImpl(this._self, this._then);

  final Thread _self;
  final $Res Function(Thread) _then;

/// Create a copy of Thread
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? boardId = null,Object? originalPost = null,Object? replies = null,Object? isSticky = null,Object? isClosed = null,Object? isWatched = null,Object? lastModified = freezed,Object? repliesCount = freezed,Object? imagesCount = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,boardId: null == boardId ? _self.boardId : boardId // ignore: cast_nullable_to_non_nullable
as String,originalPost: null == originalPost ? _self.originalPost : originalPost // ignore: cast_nullable_to_non_nullable
as Post,replies: null == replies ? _self.replies : replies // ignore: cast_nullable_to_non_nullable
as List<Post>,isSticky: null == isSticky ? _self.isSticky : isSticky // ignore: cast_nullable_to_non_nullable
as bool,isClosed: null == isClosed ? _self.isClosed : isClosed // ignore: cast_nullable_to_non_nullable
as bool,isWatched: null == isWatched ? _self.isWatched : isWatched // ignore: cast_nullable_to_non_nullable
as bool,lastModified: freezed == lastModified ? _self.lastModified : lastModified // ignore: cast_nullable_to_non_nullable
as DateTime?,repliesCount: freezed == repliesCount ? _self.repliesCount : repliesCount // ignore: cast_nullable_to_non_nullable
as int?,imagesCount: freezed == imagesCount ? _self.imagesCount : imagesCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of Thread
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostCopyWith<$Res> get originalPost {
  
  return $PostCopyWith<$Res>(_self.originalPost, (value) {
    return _then(_self.copyWith(originalPost: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _Thread implements Thread {
  const _Thread({required this.id, required this.boardId, required this.originalPost, final  List<Post> replies = const [], this.isSticky = false, this.isClosed = false, this.isWatched = false, this.lastModified, this.repliesCount, this.imagesCount}): _replies = replies;
  factory _Thread.fromJson(Map<String, dynamic> json) => _$ThreadFromJson(json);

@override final  String id;
@override final  String boardId;
@override final  Post originalPost;
 final  List<Post> _replies;
@override@JsonKey() List<Post> get replies {
  if (_replies is EqualUnmodifiableListView) return _replies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_replies);
}

@override@JsonKey() final  bool isSticky;
@override@JsonKey() final  bool isClosed;
@override@JsonKey() final  bool isWatched;
@override final  DateTime? lastModified;
@override final  int? repliesCount;
@override final  int? imagesCount;

/// Create a copy of Thread
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ThreadCopyWith<_Thread> get copyWith => __$ThreadCopyWithImpl<_Thread>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ThreadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Thread&&(identical(other.id, id) || other.id == id)&&(identical(other.boardId, boardId) || other.boardId == boardId)&&(identical(other.originalPost, originalPost) || other.originalPost == originalPost)&&const DeepCollectionEquality().equals(other._replies, _replies)&&(identical(other.isSticky, isSticky) || other.isSticky == isSticky)&&(identical(other.isClosed, isClosed) || other.isClosed == isClosed)&&(identical(other.isWatched, isWatched) || other.isWatched == isWatched)&&(identical(other.lastModified, lastModified) || other.lastModified == lastModified)&&(identical(other.repliesCount, repliesCount) || other.repliesCount == repliesCount)&&(identical(other.imagesCount, imagesCount) || other.imagesCount == imagesCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,boardId,originalPost,const DeepCollectionEquality().hash(_replies),isSticky,isClosed,isWatched,lastModified,repliesCount,imagesCount);

@override
String toString() {
  return 'Thread(id: $id, boardId: $boardId, originalPost: $originalPost, replies: $replies, isSticky: $isSticky, isClosed: $isClosed, isWatched: $isWatched, lastModified: $lastModified, repliesCount: $repliesCount, imagesCount: $imagesCount)';
}


}

/// @nodoc
abstract mixin class _$ThreadCopyWith<$Res> implements $ThreadCopyWith<$Res> {
  factory _$ThreadCopyWith(_Thread value, $Res Function(_Thread) _then) = __$ThreadCopyWithImpl;
@override @useResult
$Res call({
 String id, String boardId, Post originalPost, List<Post> replies, bool isSticky, bool isClosed, bool isWatched, DateTime? lastModified, int? repliesCount, int? imagesCount
});


@override $PostCopyWith<$Res> get originalPost;

}
/// @nodoc
class __$ThreadCopyWithImpl<$Res>
    implements _$ThreadCopyWith<$Res> {
  __$ThreadCopyWithImpl(this._self, this._then);

  final _Thread _self;
  final $Res Function(_Thread) _then;

/// Create a copy of Thread
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? boardId = null,Object? originalPost = null,Object? replies = null,Object? isSticky = null,Object? isClosed = null,Object? isWatched = null,Object? lastModified = freezed,Object? repliesCount = freezed,Object? imagesCount = freezed,}) {
  return _then(_Thread(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,boardId: null == boardId ? _self.boardId : boardId // ignore: cast_nullable_to_non_nullable
as String,originalPost: null == originalPost ? _self.originalPost : originalPost // ignore: cast_nullable_to_non_nullable
as Post,replies: null == replies ? _self._replies : replies // ignore: cast_nullable_to_non_nullable
as List<Post>,isSticky: null == isSticky ? _self.isSticky : isSticky // ignore: cast_nullable_to_non_nullable
as bool,isClosed: null == isClosed ? _self.isClosed : isClosed // ignore: cast_nullable_to_non_nullable
as bool,isWatched: null == isWatched ? _self.isWatched : isWatched // ignore: cast_nullable_to_non_nullable
as bool,lastModified: freezed == lastModified ? _self.lastModified : lastModified // ignore: cast_nullable_to_non_nullable
as DateTime?,repliesCount: freezed == repliesCount ? _self.repliesCount : repliesCount // ignore: cast_nullable_to_non_nullable
as int?,imagesCount: freezed == imagesCount ? _self.imagesCount : imagesCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of Thread
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostCopyWith<$Res> get originalPost {
  
  return $PostCopyWith<$Res>(_self.originalPost, (value) {
    return _then(_self.copyWith(originalPost: value));
  });
}
}

// dart format on
