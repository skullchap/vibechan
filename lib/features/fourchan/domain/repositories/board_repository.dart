import '../models/board.dart';
import 'base_repository.dart';

abstract class BoardRepository extends BaseBoardRepository {
  Future<List<Board>> getWorkSafeBoards();
  Future<List<Board>> getNSFWBoards();
  Future<void> refreshBoards();
}