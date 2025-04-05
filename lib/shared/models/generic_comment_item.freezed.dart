// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'generic_comment_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GenericCommentItem {

 String get id; String? get author; String? get body; DateTime? get timestamp; int? get score; int? get depth; int? get replyCount;// Placeholder specific fields
 bool get isPlaceholder; PlaceholderType? get placeholderType; Map<String, dynamic>? get placeholderData;// Optional link to original data source model
 dynamic get originalData;
/// Create a copy of GenericCommentItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GenericCommentItemCopyWith<GenericCommentItem> get copyWith => _$GenericCommentItemCopyWithImpl<GenericCommentItem>(this as GenericCommentItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GenericCommentItem&&(identical(other.id, id) || other.id == id)&&(identical(other.author, author) || other.author == author)&&(identical(other.body, body) || other.body == body)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.score, score) || other.score == score)&&(identical(other.depth, depth) || other.depth == depth)&&(identical(other.replyCount, replyCount) || other.replyCount == replyCount)&&(identical(other.isPlaceholder, isPlaceholder) || other.isPlaceholder == isPlaceholder)&&(identical(other.placeholderType, placeholderType) || other.placeholderType == placeholderType)&&const DeepCollectionEquality().equals(other.placeholderData, placeholderData)&&const DeepCollectionEquality().equals(other.originalData, originalData));
}


@override
int get hashCode => Object.hash(runtimeType,id,author,body,timestamp,score,depth,replyCount,isPlaceholder,placeholderType,const DeepCollectionEquality().hash(placeholderData),const DeepCollectionEquality().hash(originalData));

@override
String toString() {
  return 'GenericCommentItem(id: $id, author: $author, body: $body, timestamp: $timestamp, score: $score, depth: $depth, replyCount: $replyCount, isPlaceholder: $isPlaceholder, placeholderType: $placeholderType, placeholderData: $placeholderData, originalData: $originalData)';
}


}

/// @nodoc
abstract mixin class $GenericCommentItemCopyWith<$Res>  {
  factory $GenericCommentItemCopyWith(GenericCommentItem value, $Res Function(GenericCommentItem) _then) = _$GenericCommentItemCopyWithImpl;
@useResult
$Res call({
 String id, String? author, String? body, DateTime? timestamp, int? score, int? depth, int? replyCount, bool isPlaceholder, PlaceholderType? placeholderType, Map<String, dynamic>? placeholderData, dynamic originalData
});




}
/// @nodoc
class _$GenericCommentItemCopyWithImpl<$Res>
    implements $GenericCommentItemCopyWith<$Res> {
  _$GenericCommentItemCopyWithImpl(this._self, this._then);

  final GenericCommentItem _self;
  final $Res Function(GenericCommentItem) _then;

/// Create a copy of GenericCommentItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? author = freezed,Object? body = freezed,Object? timestamp = freezed,Object? score = freezed,Object? depth = freezed,Object? replyCount = freezed,Object? isPlaceholder = null,Object? placeholderType = freezed,Object? placeholderData = freezed,Object? originalData = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,score: freezed == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int?,depth: freezed == depth ? _self.depth : depth // ignore: cast_nullable_to_non_nullable
as int?,replyCount: freezed == replyCount ? _self.replyCount : replyCount // ignore: cast_nullable_to_non_nullable
as int?,isPlaceholder: null == isPlaceholder ? _self.isPlaceholder : isPlaceholder // ignore: cast_nullable_to_non_nullable
as bool,placeholderType: freezed == placeholderType ? _self.placeholderType : placeholderType // ignore: cast_nullable_to_non_nullable
as PlaceholderType?,placeholderData: freezed == placeholderData ? _self.placeholderData : placeholderData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,originalData: freezed == originalData ? _self.originalData : originalData // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}

}


/// @nodoc


class _GenericCommentItem implements GenericCommentItem {
  const _GenericCommentItem({required this.id, this.author, this.body, this.timestamp, this.score, this.depth, this.replyCount, this.isPlaceholder = false, this.placeholderType, final  Map<String, dynamic>? placeholderData, this.originalData}): _placeholderData = placeholderData;
  

@override final  String id;
@override final  String? author;
@override final  String? body;
@override final  DateTime? timestamp;
@override final  int? score;
@override final  int? depth;
@override final  int? replyCount;
// Placeholder specific fields
@override@JsonKey() final  bool isPlaceholder;
@override final  PlaceholderType? placeholderType;
 final  Map<String, dynamic>? _placeholderData;
@override Map<String, dynamic>? get placeholderData {
  final value = _placeholderData;
  if (value == null) return null;
  if (_placeholderData is EqualUnmodifiableMapView) return _placeholderData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

// Optional link to original data source model
@override final  dynamic originalData;

/// Create a copy of GenericCommentItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GenericCommentItemCopyWith<_GenericCommentItem> get copyWith => __$GenericCommentItemCopyWithImpl<_GenericCommentItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GenericCommentItem&&(identical(other.id, id) || other.id == id)&&(identical(other.author, author) || other.author == author)&&(identical(other.body, body) || other.body == body)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.score, score) || other.score == score)&&(identical(other.depth, depth) || other.depth == depth)&&(identical(other.replyCount, replyCount) || other.replyCount == replyCount)&&(identical(other.isPlaceholder, isPlaceholder) || other.isPlaceholder == isPlaceholder)&&(identical(other.placeholderType, placeholderType) || other.placeholderType == placeholderType)&&const DeepCollectionEquality().equals(other._placeholderData, _placeholderData)&&const DeepCollectionEquality().equals(other.originalData, originalData));
}


@override
int get hashCode => Object.hash(runtimeType,id,author,body,timestamp,score,depth,replyCount,isPlaceholder,placeholderType,const DeepCollectionEquality().hash(_placeholderData),const DeepCollectionEquality().hash(originalData));

@override
String toString() {
  return 'GenericCommentItem(id: $id, author: $author, body: $body, timestamp: $timestamp, score: $score, depth: $depth, replyCount: $replyCount, isPlaceholder: $isPlaceholder, placeholderType: $placeholderType, placeholderData: $placeholderData, originalData: $originalData)';
}


}

/// @nodoc
abstract mixin class _$GenericCommentItemCopyWith<$Res> implements $GenericCommentItemCopyWith<$Res> {
  factory _$GenericCommentItemCopyWith(_GenericCommentItem value, $Res Function(_GenericCommentItem) _then) = __$GenericCommentItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String? author, String? body, DateTime? timestamp, int? score, int? depth, int? replyCount, bool isPlaceholder, PlaceholderType? placeholderType, Map<String, dynamic>? placeholderData, dynamic originalData
});




}
/// @nodoc
class __$GenericCommentItemCopyWithImpl<$Res>
    implements _$GenericCommentItemCopyWith<$Res> {
  __$GenericCommentItemCopyWithImpl(this._self, this._then);

  final _GenericCommentItem _self;
  final $Res Function(_GenericCommentItem) _then;

/// Create a copy of GenericCommentItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? author = freezed,Object? body = freezed,Object? timestamp = freezed,Object? score = freezed,Object? depth = freezed,Object? replyCount = freezed,Object? isPlaceholder = null,Object? placeholderType = freezed,Object? placeholderData = freezed,Object? originalData = freezed,}) {
  return _then(_GenericCommentItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,score: freezed == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int?,depth: freezed == depth ? _self.depth : depth // ignore: cast_nullable_to_non_nullable
as int?,replyCount: freezed == replyCount ? _self.replyCount : replyCount // ignore: cast_nullable_to_non_nullable
as int?,isPlaceholder: null == isPlaceholder ? _self.isPlaceholder : isPlaceholder // ignore: cast_nullable_to_non_nullable
as bool,placeholderType: freezed == placeholderType ? _self.placeholderType : placeholderType // ignore: cast_nullable_to_non_nullable
as PlaceholderType?,placeholderData: freezed == placeholderData ? _self._placeholderData : placeholderData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,originalData: freezed == originalData ? _self.originalData : originalData // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}


}

// dart format on
