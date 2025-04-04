// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'generic_list_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GenericListItem {

 String get id; ItemSource get source; String? get title; String? get body;// Could be plain text, HTML, or Markdown depending on source
 String? get thumbnailUrl; String? get mediaUrl; MediaType get mediaType; DateTime? get timestamp; Map<String, dynamic> get metadata;// For source-specific data (score, replies, author etc.)
 Object? get originalData;
/// Create a copy of GenericListItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GenericListItemCopyWith<GenericListItem> get copyWith => _$GenericListItemCopyWithImpl<GenericListItem>(this as GenericListItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GenericListItem&&(identical(other.id, id) || other.id == id)&&(identical(other.source, source) || other.source == source)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.mediaUrl, mediaUrl) || other.mediaUrl == mediaUrl)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&const DeepCollectionEquality().equals(other.metadata, metadata)&&const DeepCollectionEquality().equals(other.originalData, originalData));
}


@override
int get hashCode => Object.hash(runtimeType,id,source,title,body,thumbnailUrl,mediaUrl,mediaType,timestamp,const DeepCollectionEquality().hash(metadata),const DeepCollectionEquality().hash(originalData));

@override
String toString() {
  return 'GenericListItem(id: $id, source: $source, title: $title, body: $body, thumbnailUrl: $thumbnailUrl, mediaUrl: $mediaUrl, mediaType: $mediaType, timestamp: $timestamp, metadata: $metadata, originalData: $originalData)';
}


}

/// @nodoc
abstract mixin class $GenericListItemCopyWith<$Res>  {
  factory $GenericListItemCopyWith(GenericListItem value, $Res Function(GenericListItem) _then) = _$GenericListItemCopyWithImpl;
@useResult
$Res call({
 String id, ItemSource source, String? title, String? body, String? thumbnailUrl, String? mediaUrl, MediaType mediaType, DateTime? timestamp, Map<String, dynamic> metadata, Object? originalData
});




}
/// @nodoc
class _$GenericListItemCopyWithImpl<$Res>
    implements $GenericListItemCopyWith<$Res> {
  _$GenericListItemCopyWithImpl(this._self, this._then);

  final GenericListItem _self;
  final $Res Function(GenericListItem) _then;

/// Create a copy of GenericListItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? source = null,Object? title = freezed,Object? body = freezed,Object? thumbnailUrl = freezed,Object? mediaUrl = freezed,Object? mediaType = null,Object? timestamp = freezed,Object? metadata = null,Object? originalData = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as ItemSource,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,mediaUrl: freezed == mediaUrl ? _self.mediaUrl : mediaUrl // ignore: cast_nullable_to_non_nullable
as String?,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as MediaType,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,originalData: freezed == originalData ? _self.originalData : originalData ,
  ));
}

}


/// @nodoc


class _GenericListItem implements GenericListItem {
  const _GenericListItem({required this.id, required this.source, this.title, this.body, this.thumbnailUrl, this.mediaUrl, this.mediaType = MediaType.none, this.timestamp, final  Map<String, dynamic> metadata = const {}, this.originalData}): _metadata = metadata;
  

@override final  String id;
@override final  ItemSource source;
@override final  String? title;
@override final  String? body;
// Could be plain text, HTML, or Markdown depending on source
@override final  String? thumbnailUrl;
@override final  String? mediaUrl;
@override@JsonKey() final  MediaType mediaType;
@override final  DateTime? timestamp;
 final  Map<String, dynamic> _metadata;
@override@JsonKey() Map<String, dynamic> get metadata {
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_metadata);
}

// For source-specific data (score, replies, author etc.)
@override final  Object? originalData;

/// Create a copy of GenericListItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GenericListItemCopyWith<_GenericListItem> get copyWith => __$GenericListItemCopyWithImpl<_GenericListItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GenericListItem&&(identical(other.id, id) || other.id == id)&&(identical(other.source, source) || other.source == source)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.mediaUrl, mediaUrl) || other.mediaUrl == mediaUrl)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&const DeepCollectionEquality().equals(other._metadata, _metadata)&&const DeepCollectionEquality().equals(other.originalData, originalData));
}


@override
int get hashCode => Object.hash(runtimeType,id,source,title,body,thumbnailUrl,mediaUrl,mediaType,timestamp,const DeepCollectionEquality().hash(_metadata),const DeepCollectionEquality().hash(originalData));

@override
String toString() {
  return 'GenericListItem(id: $id, source: $source, title: $title, body: $body, thumbnailUrl: $thumbnailUrl, mediaUrl: $mediaUrl, mediaType: $mediaType, timestamp: $timestamp, metadata: $metadata, originalData: $originalData)';
}


}

/// @nodoc
abstract mixin class _$GenericListItemCopyWith<$Res> implements $GenericListItemCopyWith<$Res> {
  factory _$GenericListItemCopyWith(_GenericListItem value, $Res Function(_GenericListItem) _then) = __$GenericListItemCopyWithImpl;
@override @useResult
$Res call({
 String id, ItemSource source, String? title, String? body, String? thumbnailUrl, String? mediaUrl, MediaType mediaType, DateTime? timestamp, Map<String, dynamic> metadata, Object? originalData
});




}
/// @nodoc
class __$GenericListItemCopyWithImpl<$Res>
    implements _$GenericListItemCopyWith<$Res> {
  __$GenericListItemCopyWithImpl(this._self, this._then);

  final _GenericListItem _self;
  final $Res Function(_GenericListItem) _then;

/// Create a copy of GenericListItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? source = null,Object? title = freezed,Object? body = freezed,Object? thumbnailUrl = freezed,Object? mediaUrl = freezed,Object? mediaType = null,Object? timestamp = freezed,Object? metadata = null,Object? originalData = freezed,}) {
  return _then(_GenericListItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as ItemSource,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,mediaUrl: freezed == mediaUrl ? _self.mediaUrl : mediaUrl // ignore: cast_nullable_to_non_nullable
as String?,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as MediaType,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,metadata: null == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,originalData: freezed == originalData ? _self.originalData : originalData ,
  ));
}


}

// dart format on
