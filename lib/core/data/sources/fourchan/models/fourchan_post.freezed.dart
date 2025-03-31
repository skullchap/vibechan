// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fourchan_post.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FourChanPost {

 int get no; int get time; String get com; String? get name; String? get trip; String? get sub; String? get filename; String? get ext; int? get w; int? get h; int? get fsize; List<String> get repliesTo;
/// Create a copy of FourChanPost
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FourChanPostCopyWith<FourChanPost> get copyWith => _$FourChanPostCopyWithImpl<FourChanPost>(this as FourChanPost, _$identity);

  /// Serializes this FourChanPost to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FourChanPost&&(identical(other.no, no) || other.no == no)&&(identical(other.time, time) || other.time == time)&&(identical(other.com, com) || other.com == com)&&(identical(other.name, name) || other.name == name)&&(identical(other.trip, trip) || other.trip == trip)&&(identical(other.sub, sub) || other.sub == sub)&&(identical(other.filename, filename) || other.filename == filename)&&(identical(other.ext, ext) || other.ext == ext)&&(identical(other.w, w) || other.w == w)&&(identical(other.h, h) || other.h == h)&&(identical(other.fsize, fsize) || other.fsize == fsize)&&const DeepCollectionEquality().equals(other.repliesTo, repliesTo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,no,time,com,name,trip,sub,filename,ext,w,h,fsize,const DeepCollectionEquality().hash(repliesTo));

@override
String toString() {
  return 'FourChanPost(no: $no, time: $time, com: $com, name: $name, trip: $trip, sub: $sub, filename: $filename, ext: $ext, w: $w, h: $h, fsize: $fsize, repliesTo: $repliesTo)';
}


}

/// @nodoc
abstract mixin class $FourChanPostCopyWith<$Res>  {
  factory $FourChanPostCopyWith(FourChanPost value, $Res Function(FourChanPost) _then) = _$FourChanPostCopyWithImpl;
@useResult
$Res call({
 int no, int time, String com, String? name, String? trip, String? sub, String? filename, String? ext, int? w, int? h, int? fsize, List<String> repliesTo
});




}
/// @nodoc
class _$FourChanPostCopyWithImpl<$Res>
    implements $FourChanPostCopyWith<$Res> {
  _$FourChanPostCopyWithImpl(this._self, this._then);

  final FourChanPost _self;
  final $Res Function(FourChanPost) _then;

/// Create a copy of FourChanPost
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? no = null,Object? time = null,Object? com = null,Object? name = freezed,Object? trip = freezed,Object? sub = freezed,Object? filename = freezed,Object? ext = freezed,Object? w = freezed,Object? h = freezed,Object? fsize = freezed,Object? repliesTo = null,}) {
  return _then(_self.copyWith(
no: null == no ? _self.no : no // ignore: cast_nullable_to_non_nullable
as int,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as int,com: null == com ? _self.com : com // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,trip: freezed == trip ? _self.trip : trip // ignore: cast_nullable_to_non_nullable
as String?,sub: freezed == sub ? _self.sub : sub // ignore: cast_nullable_to_non_nullable
as String?,filename: freezed == filename ? _self.filename : filename // ignore: cast_nullable_to_non_nullable
as String?,ext: freezed == ext ? _self.ext : ext // ignore: cast_nullable_to_non_nullable
as String?,w: freezed == w ? _self.w : w // ignore: cast_nullable_to_non_nullable
as int?,h: freezed == h ? _self.h : h // ignore: cast_nullable_to_non_nullable
as int?,fsize: freezed == fsize ? _self.fsize : fsize // ignore: cast_nullable_to_non_nullable
as int?,repliesTo: null == repliesTo ? _self.repliesTo : repliesTo // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _FourChanPost extends FourChanPost {
  const _FourChanPost({required this.no, required this.time, required this.com, this.name, this.trip, this.sub, this.filename, this.ext, this.w, this.h, this.fsize, final  List<String> repliesTo = const []}): _repliesTo = repliesTo,super._();
  factory _FourChanPost.fromJson(Map<String, dynamic> json) => _$FourChanPostFromJson(json);

@override final  int no;
@override final  int time;
@override final  String com;
@override final  String? name;
@override final  String? trip;
@override final  String? sub;
@override final  String? filename;
@override final  String? ext;
@override final  int? w;
@override final  int? h;
@override final  int? fsize;
 final  List<String> _repliesTo;
@override@JsonKey() List<String> get repliesTo {
  if (_repliesTo is EqualUnmodifiableListView) return _repliesTo;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_repliesTo);
}


/// Create a copy of FourChanPost
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FourChanPostCopyWith<_FourChanPost> get copyWith => __$FourChanPostCopyWithImpl<_FourChanPost>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FourChanPostToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FourChanPost&&(identical(other.no, no) || other.no == no)&&(identical(other.time, time) || other.time == time)&&(identical(other.com, com) || other.com == com)&&(identical(other.name, name) || other.name == name)&&(identical(other.trip, trip) || other.trip == trip)&&(identical(other.sub, sub) || other.sub == sub)&&(identical(other.filename, filename) || other.filename == filename)&&(identical(other.ext, ext) || other.ext == ext)&&(identical(other.w, w) || other.w == w)&&(identical(other.h, h) || other.h == h)&&(identical(other.fsize, fsize) || other.fsize == fsize)&&const DeepCollectionEquality().equals(other._repliesTo, _repliesTo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,no,time,com,name,trip,sub,filename,ext,w,h,fsize,const DeepCollectionEquality().hash(_repliesTo));

@override
String toString() {
  return 'FourChanPost(no: $no, time: $time, com: $com, name: $name, trip: $trip, sub: $sub, filename: $filename, ext: $ext, w: $w, h: $h, fsize: $fsize, repliesTo: $repliesTo)';
}


}

/// @nodoc
abstract mixin class _$FourChanPostCopyWith<$Res> implements $FourChanPostCopyWith<$Res> {
  factory _$FourChanPostCopyWith(_FourChanPost value, $Res Function(_FourChanPost) _then) = __$FourChanPostCopyWithImpl;
@override @useResult
$Res call({
 int no, int time, String com, String? name, String? trip, String? sub, String? filename, String? ext, int? w, int? h, int? fsize, List<String> repliesTo
});




}
/// @nodoc
class __$FourChanPostCopyWithImpl<$Res>
    implements _$FourChanPostCopyWith<$Res> {
  __$FourChanPostCopyWithImpl(this._self, this._then);

  final _FourChanPost _self;
  final $Res Function(_FourChanPost) _then;

/// Create a copy of FourChanPost
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? no = null,Object? time = null,Object? com = null,Object? name = freezed,Object? trip = freezed,Object? sub = freezed,Object? filename = freezed,Object? ext = freezed,Object? w = freezed,Object? h = freezed,Object? fsize = freezed,Object? repliesTo = null,}) {
  return _then(_FourChanPost(
no: null == no ? _self.no : no // ignore: cast_nullable_to_non_nullable
as int,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as int,com: null == com ? _self.com : com // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,trip: freezed == trip ? _self.trip : trip // ignore: cast_nullable_to_non_nullable
as String?,sub: freezed == sub ? _self.sub : sub // ignore: cast_nullable_to_non_nullable
as String?,filename: freezed == filename ? _self.filename : filename // ignore: cast_nullable_to_non_nullable
as String?,ext: freezed == ext ? _self.ext : ext // ignore: cast_nullable_to_non_nullable
as String?,w: freezed == w ? _self.w : w // ignore: cast_nullable_to_non_nullable
as int?,h: freezed == h ? _self.h : h // ignore: cast_nullable_to_non_nullable
as int?,fsize: freezed == fsize ? _self.fsize : fsize // ignore: cast_nullable_to_non_nullable
as int?,repliesTo: null == repliesTo ? _self._repliesTo : repliesTo // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
