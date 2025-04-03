// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'content_tab.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ContentTab {

 String get id; String get title; String get initialRouteName;// e.g., 'catalog', 'thread', 'favorites'
 Map<String, String> get pathParameters;@IconDataConverter() IconData get icon; bool get isActive;
/// Create a copy of ContentTab
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContentTabCopyWith<ContentTab> get copyWith => _$ContentTabCopyWithImpl<ContentTab>(this as ContentTab, _$identity);

  /// Serializes this ContentTab to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContentTab&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.initialRouteName, initialRouteName) || other.initialRouteName == initialRouteName)&&const DeepCollectionEquality().equals(other.pathParameters, pathParameters)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,initialRouteName,const DeepCollectionEquality().hash(pathParameters),icon,isActive);

@override
String toString() {
  return 'ContentTab(id: $id, title: $title, initialRouteName: $initialRouteName, pathParameters: $pathParameters, icon: $icon, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $ContentTabCopyWith<$Res>  {
  factory $ContentTabCopyWith(ContentTab value, $Res Function(ContentTab) _then) = _$ContentTabCopyWithImpl;
@useResult
$Res call({
 String id, String title, String initialRouteName, Map<String, String> pathParameters,@IconDataConverter() IconData icon, bool isActive
});




}
/// @nodoc
class _$ContentTabCopyWithImpl<$Res>
    implements $ContentTabCopyWith<$Res> {
  _$ContentTabCopyWithImpl(this._self, this._then);

  final ContentTab _self;
  final $Res Function(ContentTab) _then;

/// Create a copy of ContentTab
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? initialRouteName = null,Object? pathParameters = null,Object? icon = null,Object? isActive = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,initialRouteName: null == initialRouteName ? _self.initialRouteName : initialRouteName // ignore: cast_nullable_to_non_nullable
as String,pathParameters: null == pathParameters ? _self.pathParameters : pathParameters // ignore: cast_nullable_to_non_nullable
as Map<String, String>,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _ContentTab implements ContentTab {
  const _ContentTab({required this.id, required this.title, required this.initialRouteName, required final  Map<String, String> pathParameters, @IconDataConverter() this.icon = Icons.web, this.isActive = false}): _pathParameters = pathParameters;
  factory _ContentTab.fromJson(Map<String, dynamic> json) => _$ContentTabFromJson(json);

@override final  String id;
@override final  String title;
@override final  String initialRouteName;
// e.g., 'catalog', 'thread', 'favorites'
 final  Map<String, String> _pathParameters;
// e.g., 'catalog', 'thread', 'favorites'
@override Map<String, String> get pathParameters {
  if (_pathParameters is EqualUnmodifiableMapView) return _pathParameters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_pathParameters);
}

@override@JsonKey()@IconDataConverter() final  IconData icon;
@override@JsonKey() final  bool isActive;

/// Create a copy of ContentTab
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContentTabCopyWith<_ContentTab> get copyWith => __$ContentTabCopyWithImpl<_ContentTab>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContentTabToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContentTab&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.initialRouteName, initialRouteName) || other.initialRouteName == initialRouteName)&&const DeepCollectionEquality().equals(other._pathParameters, _pathParameters)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,initialRouteName,const DeepCollectionEquality().hash(_pathParameters),icon,isActive);

@override
String toString() {
  return 'ContentTab(id: $id, title: $title, initialRouteName: $initialRouteName, pathParameters: $pathParameters, icon: $icon, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$ContentTabCopyWith<$Res> implements $ContentTabCopyWith<$Res> {
  factory _$ContentTabCopyWith(_ContentTab value, $Res Function(_ContentTab) _then) = __$ContentTabCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String initialRouteName, Map<String, String> pathParameters,@IconDataConverter() IconData icon, bool isActive
});




}
/// @nodoc
class __$ContentTabCopyWithImpl<$Res>
    implements _$ContentTabCopyWith<$Res> {
  __$ContentTabCopyWithImpl(this._self, this._then);

  final _ContentTab _self;
  final $Res Function(_ContentTab) _then;

/// Create a copy of ContentTab
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? initialRouteName = null,Object? pathParameters = null,Object? icon = null,Object? isActive = null,}) {
  return _then(_ContentTab(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,initialRouteName: null == initialRouteName ? _self.initialRouteName : initialRouteName // ignore: cast_nullable_to_non_nullable
as String,pathParameters: null == pathParameters ? _self._pathParameters : pathParameters // ignore: cast_nullable_to_non_nullable
as Map<String, String>,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
