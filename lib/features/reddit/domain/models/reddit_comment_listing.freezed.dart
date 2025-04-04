// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reddit_comment_listing.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RedditCommentListing {

 String get kind;// Should be "Listing"
 RedditCommentListingData get data;
/// Create a copy of RedditCommentListing
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RedditCommentListingCopyWith<RedditCommentListing> get copyWith => _$RedditCommentListingCopyWithImpl<RedditCommentListing>(this as RedditCommentListing, _$identity);

  /// Serializes this RedditCommentListing to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RedditCommentListing&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kind,data);

@override
String toString() {
  return 'RedditCommentListing(kind: $kind, data: $data)';
}


}

/// @nodoc
abstract mixin class $RedditCommentListingCopyWith<$Res>  {
  factory $RedditCommentListingCopyWith(RedditCommentListing value, $Res Function(RedditCommentListing) _then) = _$RedditCommentListingCopyWithImpl;
@useResult
$Res call({
 String kind, RedditCommentListingData data
});


$RedditCommentListingDataCopyWith<$Res> get data;

}
/// @nodoc
class _$RedditCommentListingCopyWithImpl<$Res>
    implements $RedditCommentListingCopyWith<$Res> {
  _$RedditCommentListingCopyWithImpl(this._self, this._then);

  final RedditCommentListing _self;
  final $Res Function(RedditCommentListing) _then;

/// Create a copy of RedditCommentListing
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? data = null,}) {
  return _then(_self.copyWith(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as RedditCommentListingData,
  ));
}
/// Create a copy of RedditCommentListing
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RedditCommentListingDataCopyWith<$Res> get data {
  
  return $RedditCommentListingDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _RedditCommentListing implements RedditCommentListing {
  const _RedditCommentListing({required this.kind, required this.data});
  factory _RedditCommentListing.fromJson(Map<String, dynamic> json) => _$RedditCommentListingFromJson(json);

@override final  String kind;
// Should be "Listing"
@override final  RedditCommentListingData data;

/// Create a copy of RedditCommentListing
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RedditCommentListingCopyWith<_RedditCommentListing> get copyWith => __$RedditCommentListingCopyWithImpl<_RedditCommentListing>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RedditCommentListingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RedditCommentListing&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kind,data);

@override
String toString() {
  return 'RedditCommentListing(kind: $kind, data: $data)';
}


}

/// @nodoc
abstract mixin class _$RedditCommentListingCopyWith<$Res> implements $RedditCommentListingCopyWith<$Res> {
  factory _$RedditCommentListingCopyWith(_RedditCommentListing value, $Res Function(_RedditCommentListing) _then) = __$RedditCommentListingCopyWithImpl;
@override @useResult
$Res call({
 String kind, RedditCommentListingData data
});


@override $RedditCommentListingDataCopyWith<$Res> get data;

}
/// @nodoc
class __$RedditCommentListingCopyWithImpl<$Res>
    implements _$RedditCommentListingCopyWith<$Res> {
  __$RedditCommentListingCopyWithImpl(this._self, this._then);

  final _RedditCommentListing _self;
  final $Res Function(_RedditCommentListing) _then;

/// Create a copy of RedditCommentListing
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? data = null,}) {
  return _then(_RedditCommentListing(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as RedditCommentListingData,
  ));
}

/// Create a copy of RedditCommentListing
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RedditCommentListingDataCopyWith<$Res> get data {
  
  return $RedditCommentListingDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$RedditCommentListingData {

 String? get after; String? get before;@RedditCommentConverter() List<RedditComment> get children;
/// Create a copy of RedditCommentListingData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RedditCommentListingDataCopyWith<RedditCommentListingData> get copyWith => _$RedditCommentListingDataCopyWithImpl<RedditCommentListingData>(this as RedditCommentListingData, _$identity);

  /// Serializes this RedditCommentListingData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RedditCommentListingData&&(identical(other.after, after) || other.after == after)&&(identical(other.before, before) || other.before == before)&&const DeepCollectionEquality().equals(other.children, children));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,after,before,const DeepCollectionEquality().hash(children));

@override
String toString() {
  return 'RedditCommentListingData(after: $after, before: $before, children: $children)';
}


}

/// @nodoc
abstract mixin class $RedditCommentListingDataCopyWith<$Res>  {
  factory $RedditCommentListingDataCopyWith(RedditCommentListingData value, $Res Function(RedditCommentListingData) _then) = _$RedditCommentListingDataCopyWithImpl;
@useResult
$Res call({
 String? after, String? before,@RedditCommentConverter() List<RedditComment> children
});




}
/// @nodoc
class _$RedditCommentListingDataCopyWithImpl<$Res>
    implements $RedditCommentListingDataCopyWith<$Res> {
  _$RedditCommentListingDataCopyWithImpl(this._self, this._then);

  final RedditCommentListingData _self;
  final $Res Function(RedditCommentListingData) _then;

/// Create a copy of RedditCommentListingData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? after = freezed,Object? before = freezed,Object? children = null,}) {
  return _then(_self.copyWith(
after: freezed == after ? _self.after : after // ignore: cast_nullable_to_non_nullable
as String?,before: freezed == before ? _self.before : before // ignore: cast_nullable_to_non_nullable
as String?,children: null == children ? _self.children : children // ignore: cast_nullable_to_non_nullable
as List<RedditComment>,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _RedditCommentListingData implements RedditCommentListingData {
  const _RedditCommentListingData({this.after, this.before, @RedditCommentConverter() required final  List<RedditComment> children}): _children = children;
  factory _RedditCommentListingData.fromJson(Map<String, dynamic> json) => _$RedditCommentListingDataFromJson(json);

@override final  String? after;
@override final  String? before;
 final  List<RedditComment> _children;
@override@RedditCommentConverter() List<RedditComment> get children {
  if (_children is EqualUnmodifiableListView) return _children;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_children);
}


/// Create a copy of RedditCommentListingData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RedditCommentListingDataCopyWith<_RedditCommentListingData> get copyWith => __$RedditCommentListingDataCopyWithImpl<_RedditCommentListingData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RedditCommentListingDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RedditCommentListingData&&(identical(other.after, after) || other.after == after)&&(identical(other.before, before) || other.before == before)&&const DeepCollectionEquality().equals(other._children, _children));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,after,before,const DeepCollectionEquality().hash(_children));

@override
String toString() {
  return 'RedditCommentListingData(after: $after, before: $before, children: $children)';
}


}

/// @nodoc
abstract mixin class _$RedditCommentListingDataCopyWith<$Res> implements $RedditCommentListingDataCopyWith<$Res> {
  factory _$RedditCommentListingDataCopyWith(_RedditCommentListingData value, $Res Function(_RedditCommentListingData) _then) = __$RedditCommentListingDataCopyWithImpl;
@override @useResult
$Res call({
 String? after, String? before,@RedditCommentConverter() List<RedditComment> children
});




}
/// @nodoc
class __$RedditCommentListingDataCopyWithImpl<$Res>
    implements _$RedditCommentListingDataCopyWith<$Res> {
  __$RedditCommentListingDataCopyWithImpl(this._self, this._then);

  final _RedditCommentListingData _self;
  final $Res Function(_RedditCommentListingData) _then;

/// Create a copy of RedditCommentListingData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? after = freezed,Object? before = freezed,Object? children = null,}) {
  return _then(_RedditCommentListingData(
after: freezed == after ? _self.after : after // ignore: cast_nullable_to_non_nullable
as String?,before: freezed == before ? _self.before : before // ignore: cast_nullable_to_non_nullable
as String?,children: null == children ? _self._children : children // ignore: cast_nullable_to_non_nullable
as List<RedditComment>,
  ));
}


}

// dart format on
