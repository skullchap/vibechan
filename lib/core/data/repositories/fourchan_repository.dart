import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/models/board.dart';
import '../../domain/models/thread.dart';
import '../../domain/models/post.dart';
import '../../domain/repositories/board_repository.dart';
import '../../domain/repositories/thread_repository.dart';
import '../sources/chan_data_source.dart';

@LazySingleton()
@Named('4chan')
class FourChanRepository implements BoardRepository, ThreadRepository {
  final ChanDataSource _dataSource;
  final SharedPreferences _prefs;
  static const String _watchedThreadsKey = '4chan_watched_threads';
  List<Board>? _cachedBoards;

  FourChanRepository(
    @Named('4chan') this._dataSource,
    this._prefs,
  );

  // BaseBoardRepository implementation
  @override
  Future<List<Board>> getAll() async {
    _cachedBoards ??= await _dataSource.getBoards();
    return _cachedBoards!;
  }

  @override
  Future<Board?> getById(String id) async {
    final boards = await getAll();
    try {
      return boards.firstWhere((b) => b.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> create(Board board) {
    throw UnimplementedError('Direct board creation not supported');
  }

  @override
  Future<void> update(Board board) {
    throw UnimplementedError('Direct board update not supported');
  }

  @override
  Future<void> delete(String id) {
    throw UnimplementedError('Direct board deletion not supported');
  }

  // BoardRepository specific methods
  @override
  Future<List<Board>> getWorkSafeBoards() async {
    final boards = await getAll();
    return boards.where((b) => b.isWorksafe).toList();
  }

  @override
  Future<List<Board>> getNSFWBoards() async {
    final boards = await getAll();
    return boards.where((b) => !b.isWorksafe).toList();
  }

  @override
  Future<void> refreshBoards() async {
    _cachedBoards = null;
    await getAll();
  }

  // BaseThreadRepository implementation
  @override
  Future<List<Thread>> getCatalog(String boardId) async {
    final threads = await _dataSource.getBoardCatalog(boardId);
    final watchedThreads = _getWatchedThreads();
    return threads.map((t) => t.copyWith(
      isWatched: watchedThreads.contains('${boardId}_${t.id}')
    )).toList();
  }

  @override
  Future<Thread> getThreadWithReplies(String boardId, String threadId) async {
    final thread = await _dataSource.getThread(boardId, threadId);
    final watchedThreads = _getWatchedThreads();
    return thread.copyWith(
      isWatched: watchedThreads.contains('${boardId}_${threadId}')
    );
  }

  @override
  Future<List<Thread>> getAll() => throw UnimplementedError('Use getCatalog(boardId) instead');

  @override
  Future<Thread?> getById(String id) => throw UnimplementedError('Use getThreadWithReplies(boardId, threadId) instead');

  @override
  Future<void> create(Thread thread) => throw UnimplementedError('Use createReply instead');

  @override
  Future<void> update(Thread thread) => throw UnimplementedError('Thread updates not supported');

  @override
  Future<void> delete(String id) => throw UnimplementedError('Thread deletion not supported');

  // ThreadRepository specific methods
  @override
  Future<List<Thread>> getArchive(String boardId) => _dataSource.getArchive(boardId);

  @override
  Future<void> refreshThread(String boardId, String threadId) async {
    await getThreadWithReplies(boardId, threadId);
  }

  @override
  Future<Post> createReply(String boardId, String threadId, Post post) =>
      _dataSource.createReply(boardId, threadId, post);

  @override
  Future<void> watchThread(String boardId, String threadId) async {
    final watchedThreads = _getWatchedThreads();
    final threadKey = '${boardId}_$threadId';
    if (!watchedThreads.contains(threadKey)) {
      watchedThreads.add(threadKey);
      await _prefs.setStringList(_watchedThreadsKey, watchedThreads);
    }
  }

  @override
  Future<void> unwatchThread(String boardId, String threadId) async {
    final watchedThreads = _getWatchedThreads();
    final threadKey = '${boardId}_$threadId';
    if (watchedThreads.contains(threadKey)) {
      watchedThreads.remove(threadKey);
      await _prefs.setStringList(_watchedThreadsKey, watchedThreads);
    }
  }

  List<String> _getWatchedThreads() {
    return _prefs.getStringList(_watchedThreadsKey) ?? [];
  }
}