import 'package:freezed_annotation/freezed_annotation.dart';

part 'board.freezed.dart';
part 'board.g.dart';

@freezed
abstract class Board with _$Board {
  const factory Board({
    required String id,
    required String title,
    required String description,
    @Default(false) bool isWorksafe,
    @Default(0) int threadsCount,
    String? iconUrl,
  }) = _Board;

  factory Board.fromJson(Map<String, dynamic> json) => _$BoardFromJson(json);
}