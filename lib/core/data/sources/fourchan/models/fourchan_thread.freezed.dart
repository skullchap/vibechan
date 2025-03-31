// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fourchan_thread.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FourChanThread {

 int get no;@JsonKey(name: 'sticky') int get isSticky;@JsonKey(name: 'closed') int get isClosed; int get time; List<FourChanPost> get posts; int get replies; int get images; String get com; String? get sub; String? get filename; String? get ext; int? get w; int? get h; int? get fsize;
/// Create a copy of FourChanThread
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FourChanThreadCopyWith<FourChanThread> get copyWith => _$FourChanThreadCopyWithImpl<FourChanThread>(this as FourChanThread, _$identity);

  /// Serializes this FourChanThread to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FourChanThread&&(identical(other.no, no) || other.no == no)&&(identical(other.isSticky, isSticky) || other.isSticky == isSticky)&&(identical(other.isClosed, isClosed) || other.isClosed == isClosed)&&(identical(other.time, time) || other.time == time)&&const DeepCollectionEquality().equals(other.posts, posts)&&(identical(other.replies, replies) || other.replies == replies)&&(identical(other.images, images) || other.images == images)&&(identical(other.com, com) || other.com == com)&&(identical(other.sub, sub) || other.sub == sub)&&(identical(other.filename, filename) || other.filename == filename)&&(identical(other.ext, ext) || other.ext == ext)&&(identical(other.w, w) || other.w == w)&&(identical(other.h, h) || other.h == h)&&(identical(other.fsize, fsize) || other.fsize == fsize));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,no,isSticky,isClosed,time,const DeepCollectionEquality().hash(posts),replies,images,com,sub,filename,ext,w,h,fsize);

@override
String toString() {
  return 'FourChanThread(no: $no, isSticky: $isSticky, isClosed: $isClosed, time: $time, posts: $posts, replies: $replies, images: $images, com: $com, sub: $sub, filename: $filename, ext: $ext, w: $w, h: $h, fsize: $fsize)';
}


}

/// @nodoc
abstract mixin class $FourChanThreadCopyWith<$Res>  {
  factory $FourChanThreadCopyWith(FourChanThread value, $Res Function(FourChanThread) _then) = _$FourChanThreadCopyWithImpl;
@useResult
$Res call({
 int no,@JsonKey(name: 'sticky') int isSticky,@JsonKey(name: 'closed') int isClosed, int time, List<FourChanPost> posts, int replies, int images, String com, String? sub, String? filename, String? ext, int? w, int? h, int? fsize
});




}
/// @nodoc
class _$FourChanThreadCopyWithImpl<$Res>
    implements $FourChanThreadCopyWith<$Res> {
  _$FourChanThreadCopyWithImpl(this._self, this._then);

  final FourChanThread _self;
  final $Res Function(FourChanThread) _then;

/// Create a copy of FourChanThread
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? no = null,Object? isSticky = null,Object? isClosed = null,Object? time = null,Object? posts = null,Object? replies = null,Object? images = null,Object? com = null,Object? sub = freezed,Object? filename = freezed,Object? ext = freezed,Object? w = freezed,Object? h = freezed,Object? fsize = freezed,}) {
  return _then(_self.copyWith(
no: null == no ? _self.no : no // ignore: cast_nullable_to_non_nullable
as int,isSticky: null == isSticky ? _self.isSticky : isSticky // ignore: cast_nullable_to_non_nullable
as int,isClosed: null == isClosed ? _self.isClosed : isClosed // ignore: cast_nullable_to_non_nullable
as int,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as int,posts: null == posts ? _self.posts : posts // ignore: cast_nullable_to_non_nullable
as List<FourChanPost>,replies: null == replies ? _self.replies : replies // ignore: cast_nullable_to_non_nullable
as int,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as int,com: null == com ? _self.com : com // ignore: cast_nullable_to_non_nullable
as String,sub: freezed == sub ? _self.sub : sub // ignore: cast_nullable_to_non_nullable
as String?,filename: freezed == filename ? _self.filename : filename // ignore: cast_nullable_to_non_nullable
as String?,ext: freezed == ext ? _self.ext : ext // ignore: cast_nullable_to_non_nullable
as String?,w: freezed == w ? _self.w : w // ignore: cast_nullable_to_non_nullable
as int?,h: freezed == h ? _self.h : h // ignore: cast_nullable_to_non_nullable
as int?,fsize: freezed == fsize ? _self.fsize : fsize // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _FourChanThread extends FourChanThread {
  const _FourChanThread({required this.no, @JsonKey(name: 'sticky') this.isSticky = 0, @JsonKey(name: 'closed') this.isClosed = 0, required this.time, final  List<FourChanPost> posts = const [], this.replies = 0, this.images = 0, required this.com, this.sub, this.filename, this.ext, this.w, this.h, this.fsize}): _posts = posts,super._();
  factory _FourChanThread.fromJson(Map<String, dynamic> json) => _$FourChanThreadFromJson(json);

@override final  int no;
@override@JsonKey(name: 'sticky') final  int isSticky;
@override@JsonKey(name: 'closed') final  int isClosed;
@override final  int time;
 final  List<FourChanPost> _posts;
@override@JsonKey() List<FourChanPost> get posts {
  if (_posts is EqualUnmodifiableListView) return _posts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_posts);
}

@override@JsonKey() final  int replies;
@override@JsonKey() final  int images;
@override final  String com;
@override final  String? sub;
@override final  String? filename;
@override final  String? ext;
@override final  int? w;
@override final  int? h;
@override final  int? fsize;

/// Create a copy of FourChanThread
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FourChanThreadCopyWith<_FourChanThread> get copyWith => __$FourChanThreadCopyWithImpl<_FourChanThread>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FourChanThreadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FourChanThread&&(identical(other.no, no) || other.no == no)&&(identical(other.isSticky, isSticky) || other.isSticky == isSticky)&&(identical(other.isClosed, isClosed) || other.isClosed == isClosed)&&(identical(other.time, time) || other.time == time)&&const DeepCollectionEquality().equals(other._posts, _posts)&&(identical(other.replies, replies) || other.replies == replies)&&(identical(other.images, images) || other.images == images)&&(identical(other.com, com) || other.com == com)&&(identical(other.sub, sub) || other.sub == sub)&&(identical(other.filename, filename) || other.filename == filename)&&(identical(other.ext, ext) || other.ext == ext)&&(identical(other.w, w) || other.w == w)&&(identical(other.h, h) || other.h == h)&&(identical(other.fsize, fsize) || other.fsize == fsize));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,no,isSticky,isClosed,time,const DeepCollectionEquality().hash(_posts),replies,images,com,sub,filename,ext,w,h,fsize);

@override
String toString() {
  return 'FourChanThread(no: $no, isSticky: $isSticky, isClosed: $isClosed, time: $time, posts: $posts, replies: $replies, images: $images, com: $com, sub: $sub, filename: $filename, ext: $ext, w: $w, h: $h, fsize: $fsize)';
}


}

/// @nodoc
abstract mixin class _$FourChanThreadCopyWith<$Res> implements $FourChanThreadCopyWith<$Res> {
  factory _$FourChanThreadCopyWith(_FourChanThread value, $Res Function(_FourChanThread) _then) = __$FourChanThreadCopyWithImpl;
@override @useResult
$Res call({
 int no,@JsonKey(name: 'sticky') int isSticky,@JsonKey(name: 'closed') int isClosed, int time, List<FourChanPost> posts, int replies, int images, String com, String? sub, String? filename, String? ext, int? w, int? h, int? fsize
});




}
/// @nodoc
class __$FourChanThreadCopyWithImpl<$Res>
    implements _$FourChanThreadCopyWith<$Res> {
  __$FourChanThreadCopyWithImpl(this._self, this._then);

  final _FourChanThread _self;
  final $Res Function(_FourChanThread) _then;

/// Create a copy of FourChanThread
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? no = null,Object? isSticky = null,Object? isClosed = null,Object? time = null,Object? posts = null,Object? replies = null,Object? images = null,Object? com = null,Object? sub = freezed,Object? filename = freezed,Object? ext = freezed,Object? w = freezed,Object? h = freezed,Object? fsize = freezed,}) {
  return _then(_FourChanThread(
no: null == no ? _self.no : no // ignore: cast_nullable_to_non_nullable
as int,isSticky: null == isSticky ? _self.isSticky : isSticky // ignore: cast_nullable_to_non_nullable
as int,isClosed: null == isClosed ? _self.isClosed : isClosed // ignore: cast_nullable_to_non_nullable
as int,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as int,posts: null == posts ? _self._posts : posts // ignore: cast_nullable_to_non_nullable
as List<FourChanPost>,replies: null == replies ? _self.replies : replies // ignore: cast_nullable_to_non_nullable
as int,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as int,com: null == com ? _self.com : com // ignore: cast_nullable_to_non_nullable
as String,sub: freezed == sub ? _self.sub : sub // ignore: cast_nullable_to_non_nullable
as String?,filename: freezed == filename ? _self.filename : filename // ignore: cast_nullable_to_non_nullable
as String?,ext: freezed == ext ? _self.ext : ext // ignore: cast_nullable_to_non_nullable
as String?,w: freezed == w ? _self.w : w // ignore: cast_nullable_to_non_nullable
as int?,h: freezed == h ? _self.h : h // ignore: cast_nullable_to_non_nullable
as int?,fsize: freezed == fsize ? _self.fsize : fsize // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
