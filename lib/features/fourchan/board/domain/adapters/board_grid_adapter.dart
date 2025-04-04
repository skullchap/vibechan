import 'package:vibechan/features/fourchan/domain/models/board.dart';
import 'package:vibechan/shared/models/grid_item.dart';

/// Extension to adapt a 4chan [Board] to the generic [GridItem] interface.
extension BoardGridAdapter on Board {
  GridItem toGridItem() {
    return _FourchanGridItemAdapter(this);
  }
}

// Private implementation class for the adapter
class _FourchanGridItemAdapter implements GridItem {
  final Board _board;

  _FourchanGridItemAdapter(this._board);

  @override
  String get id => _board.id;

  @override
  String get title => _board.title;

  @override
  String? get subtitle => _board.description;

  @override
  bool get isSensitive => !_board.isWorksafe;
}
