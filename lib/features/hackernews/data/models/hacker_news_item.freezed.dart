// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hacker_news_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HackerNewsItem {

 int get id; bool get deleted; String? get type;// "job", "story", "comment", "poll", or "pollopt"
 String? get by;// The username of the item's author.
 int? get time;// Creation date of the item, in Unix Time.
 String? get text;// The comment, story or poll text. HTML.
 bool get dead; int? get parent;// The comment's parent: either another comment or the story.
 int? get poll;// The pollopt's associated poll.
 List<int>? get kids;// The ids of the item's comments, in ranked display order.
 String? get url;// The URL of the story.
 int? get score;// The story's score, or the votes for a pollopt.
 String? get title;// The title of the story, poll or job.
 List<int>? get parts;// A list of related pollopts, descending ordered by score.
 int? get descendants;// In the case of stories or polls, the total comment count.
 List<HackerNewsItem>? get comments;
/// Create a copy of HackerNewsItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HackerNewsItemCopyWith<HackerNewsItem> get copyWith => _$HackerNewsItemCopyWithImpl<HackerNewsItem>(this as HackerNewsItem, _$identity);

  /// Serializes this HackerNewsItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HackerNewsItem&&(identical(other.id, id) || other.id == id)&&(identical(other.deleted, deleted) || other.deleted == deleted)&&(identical(other.type, type) || other.type == type)&&(identical(other.by, by) || other.by == by)&&(identical(other.time, time) || other.time == time)&&(identical(other.text, text) || other.text == text)&&(identical(other.dead, dead) || other.dead == dead)&&(identical(other.parent, parent) || other.parent == parent)&&(identical(other.poll, poll) || other.poll == poll)&&const DeepCollectionEquality().equals(other.kids, kids)&&(identical(other.url, url) || other.url == url)&&(identical(other.score, score) || other.score == score)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.parts, parts)&&(identical(other.descendants, descendants) || other.descendants == descendants)&&const DeepCollectionEquality().equals(other.comments, comments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,deleted,type,by,time,text,dead,parent,poll,const DeepCollectionEquality().hash(kids),url,score,title,const DeepCollectionEquality().hash(parts),descendants,const DeepCollectionEquality().hash(comments));

@override
String toString() {
  return 'HackerNewsItem(id: $id, deleted: $deleted, type: $type, by: $by, time: $time, text: $text, dead: $dead, parent: $parent, poll: $poll, kids: $kids, url: $url, score: $score, title: $title, parts: $parts, descendants: $descendants, comments: $comments)';
}


}

/// @nodoc
abstract mixin class $HackerNewsItemCopyWith<$Res>  {
  factory $HackerNewsItemCopyWith(HackerNewsItem value, $Res Function(HackerNewsItem) _then) = _$HackerNewsItemCopyWithImpl;
@useResult
$Res call({
 int id, bool deleted, String? type, String? by, int? time, String? text, bool dead, int? parent, int? poll, List<int>? kids, String? url, int? score, String? title, List<int>? parts, int? descendants, List<HackerNewsItem>? comments
});




}
/// @nodoc
class _$HackerNewsItemCopyWithImpl<$Res>
    implements $HackerNewsItemCopyWith<$Res> {
  _$HackerNewsItemCopyWithImpl(this._self, this._then);

  final HackerNewsItem _self;
  final $Res Function(HackerNewsItem) _then;

/// Create a copy of HackerNewsItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? deleted = null,Object? type = freezed,Object? by = freezed,Object? time = freezed,Object? text = freezed,Object? dead = null,Object? parent = freezed,Object? poll = freezed,Object? kids = freezed,Object? url = freezed,Object? score = freezed,Object? title = freezed,Object? parts = freezed,Object? descendants = freezed,Object? comments = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,deleted: null == deleted ? _self.deleted : deleted // ignore: cast_nullable_to_non_nullable
as bool,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,by: freezed == by ? _self.by : by // ignore: cast_nullable_to_non_nullable
as String?,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as int?,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,dead: null == dead ? _self.dead : dead // ignore: cast_nullable_to_non_nullable
as bool,parent: freezed == parent ? _self.parent : parent // ignore: cast_nullable_to_non_nullable
as int?,poll: freezed == poll ? _self.poll : poll // ignore: cast_nullable_to_non_nullable
as int?,kids: freezed == kids ? _self.kids : kids // ignore: cast_nullable_to_non_nullable
as List<int>?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,score: freezed == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,parts: freezed == parts ? _self.parts : parts // ignore: cast_nullable_to_non_nullable
as List<int>?,descendants: freezed == descendants ? _self.descendants : descendants // ignore: cast_nullable_to_non_nullable
as int?,comments: freezed == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as List<HackerNewsItem>?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _HackerNewsItem implements HackerNewsItem {
  const _HackerNewsItem({required this.id, this.deleted = false, this.type, this.by, this.time, this.text, this.dead = false, this.parent, this.poll, final  List<int>? kids, this.url, this.score, this.title, final  List<int>? parts, this.descendants, final  List<HackerNewsItem>? comments}): _kids = kids,_parts = parts,_comments = comments;
  factory _HackerNewsItem.fromJson(Map<String, dynamic> json) => _$HackerNewsItemFromJson(json);

@override final  int id;
@override@JsonKey() final  bool deleted;
@override final  String? type;
// "job", "story", "comment", "poll", or "pollopt"
@override final  String? by;
// The username of the item's author.
@override final  int? time;
// Creation date of the item, in Unix Time.
@override final  String? text;
// The comment, story or poll text. HTML.
@override@JsonKey() final  bool dead;
@override final  int? parent;
// The comment's parent: either another comment or the story.
@override final  int? poll;
// The pollopt's associated poll.
 final  List<int>? _kids;
// The pollopt's associated poll.
@override List<int>? get kids {
  final value = _kids;
  if (value == null) return null;
  if (_kids is EqualUnmodifiableListView) return _kids;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

// The ids of the item's comments, in ranked display order.
@override final  String? url;
// The URL of the story.
@override final  int? score;
// The story's score, or the votes for a pollopt.
@override final  String? title;
// The title of the story, poll or job.
 final  List<int>? _parts;
// The title of the story, poll or job.
@override List<int>? get parts {
  final value = _parts;
  if (value == null) return null;
  if (_parts is EqualUnmodifiableListView) return _parts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

// A list of related pollopts, descending ordered by score.
@override final  int? descendants;
// In the case of stories or polls, the total comment count.
 final  List<HackerNewsItem>? _comments;
// In the case of stories or polls, the total comment count.
@override List<HackerNewsItem>? get comments {
  final value = _comments;
  if (value == null) return null;
  if (_comments is EqualUnmodifiableListView) return _comments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of HackerNewsItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HackerNewsItemCopyWith<_HackerNewsItem> get copyWith => __$HackerNewsItemCopyWithImpl<_HackerNewsItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HackerNewsItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HackerNewsItem&&(identical(other.id, id) || other.id == id)&&(identical(other.deleted, deleted) || other.deleted == deleted)&&(identical(other.type, type) || other.type == type)&&(identical(other.by, by) || other.by == by)&&(identical(other.time, time) || other.time == time)&&(identical(other.text, text) || other.text == text)&&(identical(other.dead, dead) || other.dead == dead)&&(identical(other.parent, parent) || other.parent == parent)&&(identical(other.poll, poll) || other.poll == poll)&&const DeepCollectionEquality().equals(other._kids, _kids)&&(identical(other.url, url) || other.url == url)&&(identical(other.score, score) || other.score == score)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._parts, _parts)&&(identical(other.descendants, descendants) || other.descendants == descendants)&&const DeepCollectionEquality().equals(other._comments, _comments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,deleted,type,by,time,text,dead,parent,poll,const DeepCollectionEquality().hash(_kids),url,score,title,const DeepCollectionEquality().hash(_parts),descendants,const DeepCollectionEquality().hash(_comments));

@override
String toString() {
  return 'HackerNewsItem(id: $id, deleted: $deleted, type: $type, by: $by, time: $time, text: $text, dead: $dead, parent: $parent, poll: $poll, kids: $kids, url: $url, score: $score, title: $title, parts: $parts, descendants: $descendants, comments: $comments)';
}


}

/// @nodoc
abstract mixin class _$HackerNewsItemCopyWith<$Res> implements $HackerNewsItemCopyWith<$Res> {
  factory _$HackerNewsItemCopyWith(_HackerNewsItem value, $Res Function(_HackerNewsItem) _then) = __$HackerNewsItemCopyWithImpl;
@override @useResult
$Res call({
 int id, bool deleted, String? type, String? by, int? time, String? text, bool dead, int? parent, int? poll, List<int>? kids, String? url, int? score, String? title, List<int>? parts, int? descendants, List<HackerNewsItem>? comments
});




}
/// @nodoc
class __$HackerNewsItemCopyWithImpl<$Res>
    implements _$HackerNewsItemCopyWith<$Res> {
  __$HackerNewsItemCopyWithImpl(this._self, this._then);

  final _HackerNewsItem _self;
  final $Res Function(_HackerNewsItem) _then;

/// Create a copy of HackerNewsItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? deleted = null,Object? type = freezed,Object? by = freezed,Object? time = freezed,Object? text = freezed,Object? dead = null,Object? parent = freezed,Object? poll = freezed,Object? kids = freezed,Object? url = freezed,Object? score = freezed,Object? title = freezed,Object? parts = freezed,Object? descendants = freezed,Object? comments = freezed,}) {
  return _then(_HackerNewsItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,deleted: null == deleted ? _self.deleted : deleted // ignore: cast_nullable_to_non_nullable
as bool,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,by: freezed == by ? _self.by : by // ignore: cast_nullable_to_non_nullable
as String?,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as int?,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,dead: null == dead ? _self.dead : dead // ignore: cast_nullable_to_non_nullable
as bool,parent: freezed == parent ? _self.parent : parent // ignore: cast_nullable_to_non_nullable
as int?,poll: freezed == poll ? _self.poll : poll // ignore: cast_nullable_to_non_nullable
as int?,kids: freezed == kids ? _self._kids : kids // ignore: cast_nullable_to_non_nullable
as List<int>?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,score: freezed == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,parts: freezed == parts ? _self._parts : parts // ignore: cast_nullable_to_non_nullable
as List<int>?,descendants: freezed == descendants ? _self.descendants : descendants // ignore: cast_nullable_to_non_nullable
as int?,comments: freezed == comments ? _self._comments : comments // ignore: cast_nullable_to_non_nullable
as List<HackerNewsItem>?,
  ));
}


}

// dart format on
