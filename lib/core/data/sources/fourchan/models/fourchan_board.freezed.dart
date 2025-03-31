// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fourchan_board.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FourChanBoard {

 String get board; String get title;@JsonKey(name: 'ws_board') int get workSafe; int get perPage; int get pages;@JsonKey(name: 'max_filesize') int get maxFilesize; String get metaDescription;
/// Create a copy of FourChanBoard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FourChanBoardCopyWith<FourChanBoard> get copyWith => _$FourChanBoardCopyWithImpl<FourChanBoard>(this as FourChanBoard, _$identity);

  /// Serializes this FourChanBoard to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FourChanBoard&&(identical(other.board, board) || other.board == board)&&(identical(other.title, title) || other.title == title)&&(identical(other.workSafe, workSafe) || other.workSafe == workSafe)&&(identical(other.perPage, perPage) || other.perPage == perPage)&&(identical(other.pages, pages) || other.pages == pages)&&(identical(other.maxFilesize, maxFilesize) || other.maxFilesize == maxFilesize)&&(identical(other.metaDescription, metaDescription) || other.metaDescription == metaDescription));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,board,title,workSafe,perPage,pages,maxFilesize,metaDescription);

@override
String toString() {
  return 'FourChanBoard(board: $board, title: $title, workSafe: $workSafe, perPage: $perPage, pages: $pages, maxFilesize: $maxFilesize, metaDescription: $metaDescription)';
}


}

/// @nodoc
abstract mixin class $FourChanBoardCopyWith<$Res>  {
  factory $FourChanBoardCopyWith(FourChanBoard value, $Res Function(FourChanBoard) _then) = _$FourChanBoardCopyWithImpl;
@useResult
$Res call({
 String board, String title,@JsonKey(name: 'ws_board') int workSafe, int perPage, int pages,@JsonKey(name: 'max_filesize') int maxFilesize, String metaDescription
});




}
/// @nodoc
class _$FourChanBoardCopyWithImpl<$Res>
    implements $FourChanBoardCopyWith<$Res> {
  _$FourChanBoardCopyWithImpl(this._self, this._then);

  final FourChanBoard _self;
  final $Res Function(FourChanBoard) _then;

/// Create a copy of FourChanBoard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? board = null,Object? title = null,Object? workSafe = null,Object? perPage = null,Object? pages = null,Object? maxFilesize = null,Object? metaDescription = null,}) {
  return _then(_self.copyWith(
board: null == board ? _self.board : board // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,workSafe: null == workSafe ? _self.workSafe : workSafe // ignore: cast_nullable_to_non_nullable
as int,perPage: null == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int,pages: null == pages ? _self.pages : pages // ignore: cast_nullable_to_non_nullable
as int,maxFilesize: null == maxFilesize ? _self.maxFilesize : maxFilesize // ignore: cast_nullable_to_non_nullable
as int,metaDescription: null == metaDescription ? _self.metaDescription : metaDescription // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _FourChanBoard extends FourChanBoard {
  const _FourChanBoard({required this.board, required this.title, @JsonKey(name: 'ws_board') required this.workSafe, required this.perPage, required this.pages, @JsonKey(name: 'max_filesize') required this.maxFilesize, this.metaDescription = ''}): super._();
  factory _FourChanBoard.fromJson(Map<String, dynamic> json) => _$FourChanBoardFromJson(json);

@override final  String board;
@override final  String title;
@override@JsonKey(name: 'ws_board') final  int workSafe;
@override final  int perPage;
@override final  int pages;
@override@JsonKey(name: 'max_filesize') final  int maxFilesize;
@override@JsonKey() final  String metaDescription;

/// Create a copy of FourChanBoard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FourChanBoardCopyWith<_FourChanBoard> get copyWith => __$FourChanBoardCopyWithImpl<_FourChanBoard>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FourChanBoardToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FourChanBoard&&(identical(other.board, board) || other.board == board)&&(identical(other.title, title) || other.title == title)&&(identical(other.workSafe, workSafe) || other.workSafe == workSafe)&&(identical(other.perPage, perPage) || other.perPage == perPage)&&(identical(other.pages, pages) || other.pages == pages)&&(identical(other.maxFilesize, maxFilesize) || other.maxFilesize == maxFilesize)&&(identical(other.metaDescription, metaDescription) || other.metaDescription == metaDescription));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,board,title,workSafe,perPage,pages,maxFilesize,metaDescription);

@override
String toString() {
  return 'FourChanBoard(board: $board, title: $title, workSafe: $workSafe, perPage: $perPage, pages: $pages, maxFilesize: $maxFilesize, metaDescription: $metaDescription)';
}


}

/// @nodoc
abstract mixin class _$FourChanBoardCopyWith<$Res> implements $FourChanBoardCopyWith<$Res> {
  factory _$FourChanBoardCopyWith(_FourChanBoard value, $Res Function(_FourChanBoard) _then) = __$FourChanBoardCopyWithImpl;
@override @useResult
$Res call({
 String board, String title,@JsonKey(name: 'ws_board') int workSafe, int perPage, int pages,@JsonKey(name: 'max_filesize') int maxFilesize, String metaDescription
});




}
/// @nodoc
class __$FourChanBoardCopyWithImpl<$Res>
    implements _$FourChanBoardCopyWith<$Res> {
  __$FourChanBoardCopyWithImpl(this._self, this._then);

  final _FourChanBoard _self;
  final $Res Function(_FourChanBoard) _then;

/// Create a copy of FourChanBoard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? board = null,Object? title = null,Object? workSafe = null,Object? perPage = null,Object? pages = null,Object? maxFilesize = null,Object? metaDescription = null,}) {
  return _then(_FourChanBoard(
board: null == board ? _self.board : board // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,workSafe: null == workSafe ? _self.workSafe : workSafe // ignore: cast_nullable_to_non_nullable
as int,perPage: null == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int,pages: null == pages ? _self.pages : pages // ignore: cast_nullable_to_non_nullable
as int,maxFilesize: null == maxFilesize ? _self.maxFilesize : maxFilesize // ignore: cast_nullable_to_non_nullable
as int,metaDescription: null == metaDescription ? _self.metaDescription : metaDescription // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
