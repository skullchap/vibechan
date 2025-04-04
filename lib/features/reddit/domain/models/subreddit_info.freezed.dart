// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subreddit_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SubredditInfo {

 String get id; String get displayName;// e.g., flutterdev
 String get title;// e.g., Flutter Development
 String get displayNamePrefixed;// e.g., r/flutterdev
 String? get description; String? get publicDescription;@JsonKey(name: 'subscribers') int get subscriberCount;@JsonKey(name: 'active_user_count') int? get activeUserCount; String? get iconImg;// URL for icon
 String? get headerImg;// URL for banner
 double? get createdUtc; bool get over18;
/// Create a copy of SubredditInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubredditInfoCopyWith<SubredditInfo> get copyWith => _$SubredditInfoCopyWithImpl<SubredditInfo>(this as SubredditInfo, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubredditInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.title, title) || other.title == title)&&(identical(other.displayNamePrefixed, displayNamePrefixed) || other.displayNamePrefixed == displayNamePrefixed)&&(identical(other.description, description) || other.description == description)&&(identical(other.publicDescription, publicDescription) || other.publicDescription == publicDescription)&&(identical(other.subscriberCount, subscriberCount) || other.subscriberCount == subscriberCount)&&(identical(other.activeUserCount, activeUserCount) || other.activeUserCount == activeUserCount)&&(identical(other.iconImg, iconImg) || other.iconImg == iconImg)&&(identical(other.headerImg, headerImg) || other.headerImg == headerImg)&&(identical(other.createdUtc, createdUtc) || other.createdUtc == createdUtc)&&(identical(other.over18, over18) || other.over18 == over18));
}


@override
int get hashCode => Object.hash(runtimeType,id,displayName,title,displayNamePrefixed,description,publicDescription,subscriberCount,activeUserCount,iconImg,headerImg,createdUtc,over18);

@override
String toString() {
  return 'SubredditInfo(id: $id, displayName: $displayName, title: $title, displayNamePrefixed: $displayNamePrefixed, description: $description, publicDescription: $publicDescription, subscriberCount: $subscriberCount, activeUserCount: $activeUserCount, iconImg: $iconImg, headerImg: $headerImg, createdUtc: $createdUtc, over18: $over18)';
}


}

/// @nodoc
abstract mixin class $SubredditInfoCopyWith<$Res>  {
  factory $SubredditInfoCopyWith(SubredditInfo value, $Res Function(SubredditInfo) _then) = _$SubredditInfoCopyWithImpl;
@useResult
$Res call({
 String id, String displayName, String title, String displayNamePrefixed, String? description, String? publicDescription,@JsonKey(name: 'subscribers') int subscriberCount,@JsonKey(name: 'active_user_count') int? activeUserCount, String? iconImg, String? headerImg, double? createdUtc, bool over18
});




}
/// @nodoc
class _$SubredditInfoCopyWithImpl<$Res>
    implements $SubredditInfoCopyWith<$Res> {
  _$SubredditInfoCopyWithImpl(this._self, this._then);

  final SubredditInfo _self;
  final $Res Function(SubredditInfo) _then;

/// Create a copy of SubredditInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? displayName = null,Object? title = null,Object? displayNamePrefixed = null,Object? description = freezed,Object? publicDescription = freezed,Object? subscriberCount = null,Object? activeUserCount = freezed,Object? iconImg = freezed,Object? headerImg = freezed,Object? createdUtc = freezed,Object? over18 = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,displayNamePrefixed: null == displayNamePrefixed ? _self.displayNamePrefixed : displayNamePrefixed // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,publicDescription: freezed == publicDescription ? _self.publicDescription : publicDescription // ignore: cast_nullable_to_non_nullable
as String?,subscriberCount: null == subscriberCount ? _self.subscriberCount : subscriberCount // ignore: cast_nullable_to_non_nullable
as int,activeUserCount: freezed == activeUserCount ? _self.activeUserCount : activeUserCount // ignore: cast_nullable_to_non_nullable
as int?,iconImg: freezed == iconImg ? _self.iconImg : iconImg // ignore: cast_nullable_to_non_nullable
as String?,headerImg: freezed == headerImg ? _self.headerImg : headerImg // ignore: cast_nullable_to_non_nullable
as String?,createdUtc: freezed == createdUtc ? _self.createdUtc : createdUtc // ignore: cast_nullable_to_non_nullable
as double?,over18: null == over18 ? _self.over18 : over18 // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _SubredditInfo implements SubredditInfo {
  const _SubredditInfo({required this.id, required this.displayName, required this.title, required this.displayNamePrefixed, this.description, this.publicDescription, @JsonKey(name: 'subscribers') required this.subscriberCount, @JsonKey(name: 'active_user_count') this.activeUserCount, this.iconImg, this.headerImg, this.createdUtc, this.over18 = false});
  

@override final  String id;
@override final  String displayName;
// e.g., flutterdev
@override final  String title;
// e.g., Flutter Development
@override final  String displayNamePrefixed;
// e.g., r/flutterdev
@override final  String? description;
@override final  String? publicDescription;
@override@JsonKey(name: 'subscribers') final  int subscriberCount;
@override@JsonKey(name: 'active_user_count') final  int? activeUserCount;
@override final  String? iconImg;
// URL for icon
@override final  String? headerImg;
// URL for banner
@override final  double? createdUtc;
@override@JsonKey() final  bool over18;

/// Create a copy of SubredditInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubredditInfoCopyWith<_SubredditInfo> get copyWith => __$SubredditInfoCopyWithImpl<_SubredditInfo>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubredditInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.title, title) || other.title == title)&&(identical(other.displayNamePrefixed, displayNamePrefixed) || other.displayNamePrefixed == displayNamePrefixed)&&(identical(other.description, description) || other.description == description)&&(identical(other.publicDescription, publicDescription) || other.publicDescription == publicDescription)&&(identical(other.subscriberCount, subscriberCount) || other.subscriberCount == subscriberCount)&&(identical(other.activeUserCount, activeUserCount) || other.activeUserCount == activeUserCount)&&(identical(other.iconImg, iconImg) || other.iconImg == iconImg)&&(identical(other.headerImg, headerImg) || other.headerImg == headerImg)&&(identical(other.createdUtc, createdUtc) || other.createdUtc == createdUtc)&&(identical(other.over18, over18) || other.over18 == over18));
}


@override
int get hashCode => Object.hash(runtimeType,id,displayName,title,displayNamePrefixed,description,publicDescription,subscriberCount,activeUserCount,iconImg,headerImg,createdUtc,over18);

@override
String toString() {
  return 'SubredditInfo(id: $id, displayName: $displayName, title: $title, displayNamePrefixed: $displayNamePrefixed, description: $description, publicDescription: $publicDescription, subscriberCount: $subscriberCount, activeUserCount: $activeUserCount, iconImg: $iconImg, headerImg: $headerImg, createdUtc: $createdUtc, over18: $over18)';
}


}

/// @nodoc
abstract mixin class _$SubredditInfoCopyWith<$Res> implements $SubredditInfoCopyWith<$Res> {
  factory _$SubredditInfoCopyWith(_SubredditInfo value, $Res Function(_SubredditInfo) _then) = __$SubredditInfoCopyWithImpl;
@override @useResult
$Res call({
 String id, String displayName, String title, String displayNamePrefixed, String? description, String? publicDescription,@JsonKey(name: 'subscribers') int subscriberCount,@JsonKey(name: 'active_user_count') int? activeUserCount, String? iconImg, String? headerImg, double? createdUtc, bool over18
});




}
/// @nodoc
class __$SubredditInfoCopyWithImpl<$Res>
    implements _$SubredditInfoCopyWith<$Res> {
  __$SubredditInfoCopyWithImpl(this._self, this._then);

  final _SubredditInfo _self;
  final $Res Function(_SubredditInfo) _then;

/// Create a copy of SubredditInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? displayName = null,Object? title = null,Object? displayNamePrefixed = null,Object? description = freezed,Object? publicDescription = freezed,Object? subscriberCount = null,Object? activeUserCount = freezed,Object? iconImg = freezed,Object? headerImg = freezed,Object? createdUtc = freezed,Object? over18 = null,}) {
  return _then(_SubredditInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,displayNamePrefixed: null == displayNamePrefixed ? _self.displayNamePrefixed : displayNamePrefixed // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,publicDescription: freezed == publicDescription ? _self.publicDescription : publicDescription // ignore: cast_nullable_to_non_nullable
as String?,subscriberCount: null == subscriberCount ? _self.subscriberCount : subscriberCount // ignore: cast_nullable_to_non_nullable
as int,activeUserCount: freezed == activeUserCount ? _self.activeUserCount : activeUserCount // ignore: cast_nullable_to_non_nullable
as int?,iconImg: freezed == iconImg ? _self.iconImg : iconImg // ignore: cast_nullable_to_non_nullable
as String?,headerImg: freezed == headerImg ? _self.headerImg : headerImg // ignore: cast_nullable_to_non_nullable
as String?,createdUtc: freezed == createdUtc ? _self.createdUtc : createdUtc // ignore: cast_nullable_to_non_nullable
as double?,over18: null == over18 ? _self.over18 : over18 // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
