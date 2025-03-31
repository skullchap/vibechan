import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../domain/models/board.dart';

part 'fourchan_board.freezed.dart';
part 'fourchan_board.g.dart';

@freezed
abstract class FourChanBoard with _$FourChanBoard {
  const FourChanBoard._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory FourChanBoard({
    required String board,
    required String title,
    @JsonKey(name: 'ws_board') required int workSafe,
    required int perPage,
    required int pages,
    @JsonKey(name: 'max_filesize') required int maxFilesize,
    @Default('') String metaDescription,
  }) = _FourChanBoard;

  factory FourChanBoard.fromJson(Map<String, dynamic> json) =>
      _$FourChanBoardFromJson(json);

  Board toBoard() => Board(
        id: board,
        title: title,
        description: metaDescription,
        isWorksafe: workSafe == 1,
        threadsCount: pages * perPage,
      );
}
