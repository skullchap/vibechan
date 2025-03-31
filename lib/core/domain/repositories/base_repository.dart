import 'package:vibechan/core/domain/models/board.dart';
import 'package:vibechan/core/domain/models/thread.dart';

// Base repository interfaces
abstract class BaseRepository<T> {
  Future<List<T>> getAll();
  Future<T?> getById(String id);
  Future<void> create(T item);
  Future<void> update(T item);
  Future<void> delete(String id);
}

// Board-specific repository interface
abstract class BaseBoardRepository {
  Future<List<Board>> getBoards();
  Future<Board?> getBoardById(String id);
}

// Thread-specific repository interface
abstract class BaseThreadRepository {
  Future<List<Thread>> getThreads(String boardId);
  Future<Thread?> getThreadById(String boardId, String threadId);
}
