// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Media {

 String get filename; String get url; String get thumbnailUrl; MediaType get type; int get width; int get height; int get size; int? get thumbnailWidth; int? get thumbnailHeight; String? get mimeType;
/// Create a copy of Media
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaCopyWith<Media> get copyWith => _$MediaCopyWithImpl<Media>(this as Media, _$identity);

  /// Serializes this Media to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Media&&(identical(other.filename, filename) || other.filename == filename)&&(identical(other.url, url) || other.url == url)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.type, type) || other.type == type)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.size, size) || other.size == size)&&(identical(other.thumbnailWidth, thumbnailWidth) || other.thumbnailWidth == thumbnailWidth)&&(identical(other.thumbnailHeight, thumbnailHeight) || other.thumbnailHeight == thumbnailHeight)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,filename,url,thumbnailUrl,type,width,height,size,thumbnailWidth,thumbnailHeight,mimeType);

@override
String toString() {
  return 'Media(filename: $filename, url: $url, thumbnailUrl: $thumbnailUrl, type: $type, width: $width, height: $height, size: $size, thumbnailWidth: $thumbnailWidth, thumbnailHeight: $thumbnailHeight, mimeType: $mimeType)';
}


}

/// @nodoc
abstract mixin class $MediaCopyWith<$Res>  {
  factory $MediaCopyWith(Media value, $Res Function(Media) _then) = _$MediaCopyWithImpl;
@useResult
$Res call({
 String filename, String url, String thumbnailUrl, MediaType type, int width, int height, int size, int? thumbnailWidth, int? thumbnailHeight, String? mimeType
});




}
/// @nodoc
class _$MediaCopyWithImpl<$Res>
    implements $MediaCopyWith<$Res> {
  _$MediaCopyWithImpl(this._self, this._then);

  final Media _self;
  final $Res Function(Media) _then;

/// Create a copy of Media
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? filename = null,Object? url = null,Object? thumbnailUrl = null,Object? type = null,Object? width = null,Object? height = null,Object? size = null,Object? thumbnailWidth = freezed,Object? thumbnailHeight = freezed,Object? mimeType = freezed,}) {
  return _then(_self.copyWith(
filename: null == filename ? _self.filename : filename // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: null == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MediaType,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,thumbnailWidth: freezed == thumbnailWidth ? _self.thumbnailWidth : thumbnailWidth // ignore: cast_nullable_to_non_nullable
as int?,thumbnailHeight: freezed == thumbnailHeight ? _self.thumbnailHeight : thumbnailHeight // ignore: cast_nullable_to_non_nullable
as int?,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _Media implements Media {
  const _Media({required this.filename, required this.url, required this.thumbnailUrl, required this.type, required this.width, required this.height, required this.size, this.thumbnailWidth, this.thumbnailHeight, this.mimeType});
  factory _Media.fromJson(Map<String, dynamic> json) => _$MediaFromJson(json);

@override final  String filename;
@override final  String url;
@override final  String thumbnailUrl;
@override final  MediaType type;
@override final  int width;
@override final  int height;
@override final  int size;
@override final  int? thumbnailWidth;
@override final  int? thumbnailHeight;
@override final  String? mimeType;

/// Create a copy of Media
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MediaCopyWith<_Media> get copyWith => __$MediaCopyWithImpl<_Media>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MediaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Media&&(identical(other.filename, filename) || other.filename == filename)&&(identical(other.url, url) || other.url == url)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.type, type) || other.type == type)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.size, size) || other.size == size)&&(identical(other.thumbnailWidth, thumbnailWidth) || other.thumbnailWidth == thumbnailWidth)&&(identical(other.thumbnailHeight, thumbnailHeight) || other.thumbnailHeight == thumbnailHeight)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,filename,url,thumbnailUrl,type,width,height,size,thumbnailWidth,thumbnailHeight,mimeType);

@override
String toString() {
  return 'Media(filename: $filename, url: $url, thumbnailUrl: $thumbnailUrl, type: $type, width: $width, height: $height, size: $size, thumbnailWidth: $thumbnailWidth, thumbnailHeight: $thumbnailHeight, mimeType: $mimeType)';
}


}

/// @nodoc
abstract mixin class _$MediaCopyWith<$Res> implements $MediaCopyWith<$Res> {
  factory _$MediaCopyWith(_Media value, $Res Function(_Media) _then) = __$MediaCopyWithImpl;
@override @useResult
$Res call({
 String filename, String url, String thumbnailUrl, MediaType type, int width, int height, int size, int? thumbnailWidth, int? thumbnailHeight, String? mimeType
});




}
/// @nodoc
class __$MediaCopyWithImpl<$Res>
    implements _$MediaCopyWith<$Res> {
  __$MediaCopyWithImpl(this._self, this._then);

  final _Media _self;
  final $Res Function(_Media) _then;

/// Create a copy of Media
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? filename = null,Object? url = null,Object? thumbnailUrl = null,Object? type = null,Object? width = null,Object? height = null,Object? size = null,Object? thumbnailWidth = freezed,Object? thumbnailHeight = freezed,Object? mimeType = freezed,}) {
  return _then(_Media(
filename: null == filename ? _self.filename : filename // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: null == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MediaType,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,thumbnailWidth: freezed == thumbnailWidth ? _self.thumbnailWidth : thumbnailWidth // ignore: cast_nullable_to_non_nullable
as int?,thumbnailHeight: freezed == thumbnailHeight ? _self.thumbnailHeight : thumbnailHeight // ignore: cast_nullable_to_non_nullable
as int?,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
