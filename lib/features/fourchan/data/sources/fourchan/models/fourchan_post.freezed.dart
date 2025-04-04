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

// Core IDs
 int get no;// post number
 int get resto;// thread number if this is a reply; 0 if OP
// Thread settings
 int get sticky; int get closed;// Timestamps
 String? get now;// "MM/DD/YY(Day)HH:MM"
 int get time;// Unix timestamp
// Poster Info
 String get name; String? get trip; String? get id; String? get capcode; String? get country; String? get countryName; String? get boardFlag; String? get flagName;// Content
 String? get sub; String get com;// Image / Attachment
 int get tim;// 4chan's unique image timestamp
 String? get filename; String? get ext; int get fsize; String? get md5; int get w; int get h;@JsonKey(name: 'tn_w') int get tnW;@JsonKey(name: 'tn_h') int get tnH; int get filedeleted; int get spoiler;@JsonKey(name: 'custom_spoiler') int get customSpoiler;// Thread aggregates (for OP posts)
 int get omittedPosts; int get omittedImages; int get replies; int get images; int get bumplimit; int get imagelimit; String? get semanticUrl; int get since4pass; int get mImg; int get archived; int get archivedOn;
/// Create a copy of FourChanPost
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FourChanPostCopyWith<FourChanPost> get copyWith => _$FourChanPostCopyWithImpl<FourChanPost>(this as FourChanPost, _$identity);

  /// Serializes this FourChanPost to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FourChanPost&&(identical(other.no, no) || other.no == no)&&(identical(other.resto, resto) || other.resto == resto)&&(identical(other.sticky, sticky) || other.sticky == sticky)&&(identical(other.closed, closed) || other.closed == closed)&&(identical(other.now, now) || other.now == now)&&(identical(other.time, time) || other.time == time)&&(identical(other.name, name) || other.name == name)&&(identical(other.trip, trip) || other.trip == trip)&&(identical(other.id, id) || other.id == id)&&(identical(other.capcode, capcode) || other.capcode == capcode)&&(identical(other.country, country) || other.country == country)&&(identical(other.countryName, countryName) || other.countryName == countryName)&&(identical(other.boardFlag, boardFlag) || other.boardFlag == boardFlag)&&(identical(other.flagName, flagName) || other.flagName == flagName)&&(identical(other.sub, sub) || other.sub == sub)&&(identical(other.com, com) || other.com == com)&&(identical(other.tim, tim) || other.tim == tim)&&(identical(other.filename, filename) || other.filename == filename)&&(identical(other.ext, ext) || other.ext == ext)&&(identical(other.fsize, fsize) || other.fsize == fsize)&&(identical(other.md5, md5) || other.md5 == md5)&&(identical(other.w, w) || other.w == w)&&(identical(other.h, h) || other.h == h)&&(identical(other.tnW, tnW) || other.tnW == tnW)&&(identical(other.tnH, tnH) || other.tnH == tnH)&&(identical(other.filedeleted, filedeleted) || other.filedeleted == filedeleted)&&(identical(other.spoiler, spoiler) || other.spoiler == spoiler)&&(identical(other.customSpoiler, customSpoiler) || other.customSpoiler == customSpoiler)&&(identical(other.omittedPosts, omittedPosts) || other.omittedPosts == omittedPosts)&&(identical(other.omittedImages, omittedImages) || other.omittedImages == omittedImages)&&(identical(other.replies, replies) || other.replies == replies)&&(identical(other.images, images) || other.images == images)&&(identical(other.bumplimit, bumplimit) || other.bumplimit == bumplimit)&&(identical(other.imagelimit, imagelimit) || other.imagelimit == imagelimit)&&(identical(other.semanticUrl, semanticUrl) || other.semanticUrl == semanticUrl)&&(identical(other.since4pass, since4pass) || other.since4pass == since4pass)&&(identical(other.mImg, mImg) || other.mImg == mImg)&&(identical(other.archived, archived) || other.archived == archived)&&(identical(other.archivedOn, archivedOn) || other.archivedOn == archivedOn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,no,resto,sticky,closed,now,time,name,trip,id,capcode,country,countryName,boardFlag,flagName,sub,com,tim,filename,ext,fsize,md5,w,h,tnW,tnH,filedeleted,spoiler,customSpoiler,omittedPosts,omittedImages,replies,images,bumplimit,imagelimit,semanticUrl,since4pass,mImg,archived,archivedOn]);

@override
String toString() {
  return 'FourChanPost(no: $no, resto: $resto, sticky: $sticky, closed: $closed, now: $now, time: $time, name: $name, trip: $trip, id: $id, capcode: $capcode, country: $country, countryName: $countryName, boardFlag: $boardFlag, flagName: $flagName, sub: $sub, com: $com, tim: $tim, filename: $filename, ext: $ext, fsize: $fsize, md5: $md5, w: $w, h: $h, tnW: $tnW, tnH: $tnH, filedeleted: $filedeleted, spoiler: $spoiler, customSpoiler: $customSpoiler, omittedPosts: $omittedPosts, omittedImages: $omittedImages, replies: $replies, images: $images, bumplimit: $bumplimit, imagelimit: $imagelimit, semanticUrl: $semanticUrl, since4pass: $since4pass, mImg: $mImg, archived: $archived, archivedOn: $archivedOn)';
}


}

/// @nodoc
abstract mixin class $FourChanPostCopyWith<$Res>  {
  factory $FourChanPostCopyWith(FourChanPost value, $Res Function(FourChanPost) _then) = _$FourChanPostCopyWithImpl;
@useResult
$Res call({
 int no, int resto, int sticky, int closed, String? now, int time, String name, String? trip, String? id, String? capcode, String? country, String? countryName, String? boardFlag, String? flagName, String? sub, String com, int tim, String? filename, String? ext, int fsize, String? md5, int w, int h,@JsonKey(name: 'tn_w') int tnW,@JsonKey(name: 'tn_h') int tnH, int filedeleted, int spoiler,@JsonKey(name: 'custom_spoiler') int customSpoiler, int omittedPosts, int omittedImages, int replies, int images, int bumplimit, int imagelimit, String? semanticUrl, int since4pass, int mImg, int archived, int archivedOn
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
@pragma('vm:prefer-inline') @override $Res call({Object? no = null,Object? resto = null,Object? sticky = null,Object? closed = null,Object? now = freezed,Object? time = null,Object? name = null,Object? trip = freezed,Object? id = freezed,Object? capcode = freezed,Object? country = freezed,Object? countryName = freezed,Object? boardFlag = freezed,Object? flagName = freezed,Object? sub = freezed,Object? com = null,Object? tim = null,Object? filename = freezed,Object? ext = freezed,Object? fsize = null,Object? md5 = freezed,Object? w = null,Object? h = null,Object? tnW = null,Object? tnH = null,Object? filedeleted = null,Object? spoiler = null,Object? customSpoiler = null,Object? omittedPosts = null,Object? omittedImages = null,Object? replies = null,Object? images = null,Object? bumplimit = null,Object? imagelimit = null,Object? semanticUrl = freezed,Object? since4pass = null,Object? mImg = null,Object? archived = null,Object? archivedOn = null,}) {
  return _then(_self.copyWith(
no: null == no ? _self.no : no // ignore: cast_nullable_to_non_nullable
as int,resto: null == resto ? _self.resto : resto // ignore: cast_nullable_to_non_nullable
as int,sticky: null == sticky ? _self.sticky : sticky // ignore: cast_nullable_to_non_nullable
as int,closed: null == closed ? _self.closed : closed // ignore: cast_nullable_to_non_nullable
as int,now: freezed == now ? _self.now : now // ignore: cast_nullable_to_non_nullable
as String?,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,trip: freezed == trip ? _self.trip : trip // ignore: cast_nullable_to_non_nullable
as String?,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,capcode: freezed == capcode ? _self.capcode : capcode // ignore: cast_nullable_to_non_nullable
as String?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,countryName: freezed == countryName ? _self.countryName : countryName // ignore: cast_nullable_to_non_nullable
as String?,boardFlag: freezed == boardFlag ? _self.boardFlag : boardFlag // ignore: cast_nullable_to_non_nullable
as String?,flagName: freezed == flagName ? _self.flagName : flagName // ignore: cast_nullable_to_non_nullable
as String?,sub: freezed == sub ? _self.sub : sub // ignore: cast_nullable_to_non_nullable
as String?,com: null == com ? _self.com : com // ignore: cast_nullable_to_non_nullable
as String,tim: null == tim ? _self.tim : tim // ignore: cast_nullable_to_non_nullable
as int,filename: freezed == filename ? _self.filename : filename // ignore: cast_nullable_to_non_nullable
as String?,ext: freezed == ext ? _self.ext : ext // ignore: cast_nullable_to_non_nullable
as String?,fsize: null == fsize ? _self.fsize : fsize // ignore: cast_nullable_to_non_nullable
as int,md5: freezed == md5 ? _self.md5 : md5 // ignore: cast_nullable_to_non_nullable
as String?,w: null == w ? _self.w : w // ignore: cast_nullable_to_non_nullable
as int,h: null == h ? _self.h : h // ignore: cast_nullable_to_non_nullable
as int,tnW: null == tnW ? _self.tnW : tnW // ignore: cast_nullable_to_non_nullable
as int,tnH: null == tnH ? _self.tnH : tnH // ignore: cast_nullable_to_non_nullable
as int,filedeleted: null == filedeleted ? _self.filedeleted : filedeleted // ignore: cast_nullable_to_non_nullable
as int,spoiler: null == spoiler ? _self.spoiler : spoiler // ignore: cast_nullable_to_non_nullable
as int,customSpoiler: null == customSpoiler ? _self.customSpoiler : customSpoiler // ignore: cast_nullable_to_non_nullable
as int,omittedPosts: null == omittedPosts ? _self.omittedPosts : omittedPosts // ignore: cast_nullable_to_non_nullable
as int,omittedImages: null == omittedImages ? _self.omittedImages : omittedImages // ignore: cast_nullable_to_non_nullable
as int,replies: null == replies ? _self.replies : replies // ignore: cast_nullable_to_non_nullable
as int,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as int,bumplimit: null == bumplimit ? _self.bumplimit : bumplimit // ignore: cast_nullable_to_non_nullable
as int,imagelimit: null == imagelimit ? _self.imagelimit : imagelimit // ignore: cast_nullable_to_non_nullable
as int,semanticUrl: freezed == semanticUrl ? _self.semanticUrl : semanticUrl // ignore: cast_nullable_to_non_nullable
as String?,since4pass: null == since4pass ? _self.since4pass : since4pass // ignore: cast_nullable_to_non_nullable
as int,mImg: null == mImg ? _self.mImg : mImg // ignore: cast_nullable_to_non_nullable
as int,archived: null == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as int,archivedOn: null == archivedOn ? _self.archivedOn : archivedOn // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _FourChanPost extends FourChanPost {
  const _FourChanPost({this.no = 0, this.resto = 0, this.sticky = 0, this.closed = 0, this.now, this.time = 0, this.name = 'Anonymous', this.trip, this.id, this.capcode, this.country, this.countryName, this.boardFlag, this.flagName, this.sub, this.com = '', this.tim = 0, this.filename, this.ext, this.fsize = 0, this.md5, this.w = 0, this.h = 0, @JsonKey(name: 'tn_w') this.tnW = 0, @JsonKey(name: 'tn_h') this.tnH = 0, this.filedeleted = 0, this.spoiler = 0, @JsonKey(name: 'custom_spoiler') this.customSpoiler = 0, this.omittedPosts = 0, this.omittedImages = 0, this.replies = 0, this.images = 0, this.bumplimit = 0, this.imagelimit = 0, this.semanticUrl, this.since4pass = 0, this.mImg = 0, this.archived = 0, this.archivedOn = 0}): super._();
  factory _FourChanPost.fromJson(Map<String, dynamic> json) => _$FourChanPostFromJson(json);

// Core IDs
@override@JsonKey() final  int no;
// post number
@override@JsonKey() final  int resto;
// thread number if this is a reply; 0 if OP
// Thread settings
@override@JsonKey() final  int sticky;
@override@JsonKey() final  int closed;
// Timestamps
@override final  String? now;
// "MM/DD/YY(Day)HH:MM"
@override@JsonKey() final  int time;
// Unix timestamp
// Poster Info
@override@JsonKey() final  String name;
@override final  String? trip;
@override final  String? id;
@override final  String? capcode;
@override final  String? country;
@override final  String? countryName;
@override final  String? boardFlag;
@override final  String? flagName;
// Content
@override final  String? sub;
@override@JsonKey() final  String com;
// Image / Attachment
@override@JsonKey() final  int tim;
// 4chan's unique image timestamp
@override final  String? filename;
@override final  String? ext;
@override@JsonKey() final  int fsize;
@override final  String? md5;
@override@JsonKey() final  int w;
@override@JsonKey() final  int h;
@override@JsonKey(name: 'tn_w') final  int tnW;
@override@JsonKey(name: 'tn_h') final  int tnH;
@override@JsonKey() final  int filedeleted;
@override@JsonKey() final  int spoiler;
@override@JsonKey(name: 'custom_spoiler') final  int customSpoiler;
// Thread aggregates (for OP posts)
@override@JsonKey() final  int omittedPosts;
@override@JsonKey() final  int omittedImages;
@override@JsonKey() final  int replies;
@override@JsonKey() final  int images;
@override@JsonKey() final  int bumplimit;
@override@JsonKey() final  int imagelimit;
@override final  String? semanticUrl;
@override@JsonKey() final  int since4pass;
@override@JsonKey() final  int mImg;
@override@JsonKey() final  int archived;
@override@JsonKey() final  int archivedOn;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FourChanPost&&(identical(other.no, no) || other.no == no)&&(identical(other.resto, resto) || other.resto == resto)&&(identical(other.sticky, sticky) || other.sticky == sticky)&&(identical(other.closed, closed) || other.closed == closed)&&(identical(other.now, now) || other.now == now)&&(identical(other.time, time) || other.time == time)&&(identical(other.name, name) || other.name == name)&&(identical(other.trip, trip) || other.trip == trip)&&(identical(other.id, id) || other.id == id)&&(identical(other.capcode, capcode) || other.capcode == capcode)&&(identical(other.country, country) || other.country == country)&&(identical(other.countryName, countryName) || other.countryName == countryName)&&(identical(other.boardFlag, boardFlag) || other.boardFlag == boardFlag)&&(identical(other.flagName, flagName) || other.flagName == flagName)&&(identical(other.sub, sub) || other.sub == sub)&&(identical(other.com, com) || other.com == com)&&(identical(other.tim, tim) || other.tim == tim)&&(identical(other.filename, filename) || other.filename == filename)&&(identical(other.ext, ext) || other.ext == ext)&&(identical(other.fsize, fsize) || other.fsize == fsize)&&(identical(other.md5, md5) || other.md5 == md5)&&(identical(other.w, w) || other.w == w)&&(identical(other.h, h) || other.h == h)&&(identical(other.tnW, tnW) || other.tnW == tnW)&&(identical(other.tnH, tnH) || other.tnH == tnH)&&(identical(other.filedeleted, filedeleted) || other.filedeleted == filedeleted)&&(identical(other.spoiler, spoiler) || other.spoiler == spoiler)&&(identical(other.customSpoiler, customSpoiler) || other.customSpoiler == customSpoiler)&&(identical(other.omittedPosts, omittedPosts) || other.omittedPosts == omittedPosts)&&(identical(other.omittedImages, omittedImages) || other.omittedImages == omittedImages)&&(identical(other.replies, replies) || other.replies == replies)&&(identical(other.images, images) || other.images == images)&&(identical(other.bumplimit, bumplimit) || other.bumplimit == bumplimit)&&(identical(other.imagelimit, imagelimit) || other.imagelimit == imagelimit)&&(identical(other.semanticUrl, semanticUrl) || other.semanticUrl == semanticUrl)&&(identical(other.since4pass, since4pass) || other.since4pass == since4pass)&&(identical(other.mImg, mImg) || other.mImg == mImg)&&(identical(other.archived, archived) || other.archived == archived)&&(identical(other.archivedOn, archivedOn) || other.archivedOn == archivedOn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,no,resto,sticky,closed,now,time,name,trip,id,capcode,country,countryName,boardFlag,flagName,sub,com,tim,filename,ext,fsize,md5,w,h,tnW,tnH,filedeleted,spoiler,customSpoiler,omittedPosts,omittedImages,replies,images,bumplimit,imagelimit,semanticUrl,since4pass,mImg,archived,archivedOn]);

@override
String toString() {
  return 'FourChanPost(no: $no, resto: $resto, sticky: $sticky, closed: $closed, now: $now, time: $time, name: $name, trip: $trip, id: $id, capcode: $capcode, country: $country, countryName: $countryName, boardFlag: $boardFlag, flagName: $flagName, sub: $sub, com: $com, tim: $tim, filename: $filename, ext: $ext, fsize: $fsize, md5: $md5, w: $w, h: $h, tnW: $tnW, tnH: $tnH, filedeleted: $filedeleted, spoiler: $spoiler, customSpoiler: $customSpoiler, omittedPosts: $omittedPosts, omittedImages: $omittedImages, replies: $replies, images: $images, bumplimit: $bumplimit, imagelimit: $imagelimit, semanticUrl: $semanticUrl, since4pass: $since4pass, mImg: $mImg, archived: $archived, archivedOn: $archivedOn)';
}


}

/// @nodoc
abstract mixin class _$FourChanPostCopyWith<$Res> implements $FourChanPostCopyWith<$Res> {
  factory _$FourChanPostCopyWith(_FourChanPost value, $Res Function(_FourChanPost) _then) = __$FourChanPostCopyWithImpl;
@override @useResult
$Res call({
 int no, int resto, int sticky, int closed, String? now, int time, String name, String? trip, String? id, String? capcode, String? country, String? countryName, String? boardFlag, String? flagName, String? sub, String com, int tim, String? filename, String? ext, int fsize, String? md5, int w, int h,@JsonKey(name: 'tn_w') int tnW,@JsonKey(name: 'tn_h') int tnH, int filedeleted, int spoiler,@JsonKey(name: 'custom_spoiler') int customSpoiler, int omittedPosts, int omittedImages, int replies, int images, int bumplimit, int imagelimit, String? semanticUrl, int since4pass, int mImg, int archived, int archivedOn
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
@override @pragma('vm:prefer-inline') $Res call({Object? no = null,Object? resto = null,Object? sticky = null,Object? closed = null,Object? now = freezed,Object? time = null,Object? name = null,Object? trip = freezed,Object? id = freezed,Object? capcode = freezed,Object? country = freezed,Object? countryName = freezed,Object? boardFlag = freezed,Object? flagName = freezed,Object? sub = freezed,Object? com = null,Object? tim = null,Object? filename = freezed,Object? ext = freezed,Object? fsize = null,Object? md5 = freezed,Object? w = null,Object? h = null,Object? tnW = null,Object? tnH = null,Object? filedeleted = null,Object? spoiler = null,Object? customSpoiler = null,Object? omittedPosts = null,Object? omittedImages = null,Object? replies = null,Object? images = null,Object? bumplimit = null,Object? imagelimit = null,Object? semanticUrl = freezed,Object? since4pass = null,Object? mImg = null,Object? archived = null,Object? archivedOn = null,}) {
  return _then(_FourChanPost(
no: null == no ? _self.no : no // ignore: cast_nullable_to_non_nullable
as int,resto: null == resto ? _self.resto : resto // ignore: cast_nullable_to_non_nullable
as int,sticky: null == sticky ? _self.sticky : sticky // ignore: cast_nullable_to_non_nullable
as int,closed: null == closed ? _self.closed : closed // ignore: cast_nullable_to_non_nullable
as int,now: freezed == now ? _self.now : now // ignore: cast_nullable_to_non_nullable
as String?,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,trip: freezed == trip ? _self.trip : trip // ignore: cast_nullable_to_non_nullable
as String?,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,capcode: freezed == capcode ? _self.capcode : capcode // ignore: cast_nullable_to_non_nullable
as String?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,countryName: freezed == countryName ? _self.countryName : countryName // ignore: cast_nullable_to_non_nullable
as String?,boardFlag: freezed == boardFlag ? _self.boardFlag : boardFlag // ignore: cast_nullable_to_non_nullable
as String?,flagName: freezed == flagName ? _self.flagName : flagName // ignore: cast_nullable_to_non_nullable
as String?,sub: freezed == sub ? _self.sub : sub // ignore: cast_nullable_to_non_nullable
as String?,com: null == com ? _self.com : com // ignore: cast_nullable_to_non_nullable
as String,tim: null == tim ? _self.tim : tim // ignore: cast_nullable_to_non_nullable
as int,filename: freezed == filename ? _self.filename : filename // ignore: cast_nullable_to_non_nullable
as String?,ext: freezed == ext ? _self.ext : ext // ignore: cast_nullable_to_non_nullable
as String?,fsize: null == fsize ? _self.fsize : fsize // ignore: cast_nullable_to_non_nullable
as int,md5: freezed == md5 ? _self.md5 : md5 // ignore: cast_nullable_to_non_nullable
as String?,w: null == w ? _self.w : w // ignore: cast_nullable_to_non_nullable
as int,h: null == h ? _self.h : h // ignore: cast_nullable_to_non_nullable
as int,tnW: null == tnW ? _self.tnW : tnW // ignore: cast_nullable_to_non_nullable
as int,tnH: null == tnH ? _self.tnH : tnH // ignore: cast_nullable_to_non_nullable
as int,filedeleted: null == filedeleted ? _self.filedeleted : filedeleted // ignore: cast_nullable_to_non_nullable
as int,spoiler: null == spoiler ? _self.spoiler : spoiler // ignore: cast_nullable_to_non_nullable
as int,customSpoiler: null == customSpoiler ? _self.customSpoiler : customSpoiler // ignore: cast_nullable_to_non_nullable
as int,omittedPosts: null == omittedPosts ? _self.omittedPosts : omittedPosts // ignore: cast_nullable_to_non_nullable
as int,omittedImages: null == omittedImages ? _self.omittedImages : omittedImages // ignore: cast_nullable_to_non_nullable
as int,replies: null == replies ? _self.replies : replies // ignore: cast_nullable_to_non_nullable
as int,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as int,bumplimit: null == bumplimit ? _self.bumplimit : bumplimit // ignore: cast_nullable_to_non_nullable
as int,imagelimit: null == imagelimit ? _self.imagelimit : imagelimit // ignore: cast_nullable_to_non_nullable
as int,semanticUrl: freezed == semanticUrl ? _self.semanticUrl : semanticUrl // ignore: cast_nullable_to_non_nullable
as String?,since4pass: null == since4pass ? _self.since4pass : since4pass // ignore: cast_nullable_to_non_nullable
as int,mImg: null == mImg ? _self.mImg : mImg // ignore: cast_nullable_to_non_nullable
as int,archived: null == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as int,archivedOn: null == archivedOn ? _self.archivedOn : archivedOn // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
