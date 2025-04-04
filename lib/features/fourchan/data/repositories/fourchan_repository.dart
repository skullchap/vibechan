import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibechan/features/fourchan/data/sources/fourchan/chan_data_source.dart';
import 'package:vibechan/features/fourchan/domain/models/board.dart';
import 'package:vibechan/features/fourchan/domain/models/post.dart';
import 'package:vibechan/features/fourchan/domain/models/thread.dart';
import 'package:vibechan/features/fourchan/domain/models/media.dart';
import 'package:vibechan/features/fourchan/domain/repositories/board_repository.dart';
import 'package:vibechan/features/fourchan/domain/repositories/thread_repository.dart';

@LazySingleton()
@Named('4chan')
class FourChanRepository implements BoardRepository, ThreadRepository {
  final ChanDataSource _dataSource;
  final SharedPreferences _prefs;
  static const String _watchedThreadsKey = '4chan_watched_threads';
  List<Board>? _cachedBoards;

  FourChanRepository(@Named('4chan') this._dataSource, this._prefs);

  // --------------------
  // BaseBoardRepository implementation
  // --------------------
  @override
  Future<List<Board>> getBoards() async {
    _cachedBoards ??= await _dataSource.getBoards();
    return _cachedBoards!;
  }

  @override
  Future<Board?> getBoardById(String id) async {
    final boards = await getBoards();
    try {
      return boards.firstWhere((b) => b.id == id);
    } catch (e) {
      return null;
    }
  }

  // BoardRepository specific methods
  @override
  Future<List<Board>> getWorkSafeBoards() async {
    final boards = await getBoards();
    return boards.where((b) => b.isWorksafe).toList();
  }

  @override
  Future<List<Board>> getNSFWBoards() async {
    final boards = await getBoards();
    return boards.where((b) => !b.isWorksafe).toList();
  }

  @override
  Future<void> refreshBoards() async {
    _cachedBoards = null;
    await getBoards();
  }

  @override
  Future<List<Media>> getAllMediaFromBoard(String boardId) async {
    final threads = await getThreads(boardId); // Get all threads (catalog)
    final List<Media> allMedia = [];
    for (final thread in threads) {
      if (thread.originalPost.media != null) {
        allMedia.add(thread.originalPost.media!);
      }
    }
    return allMedia;
  }

  // --------------------
  // BaseThreadRepository implementation
  // --------------------
  @override
  Future<List<Thread>> getThreads(String boardId) async {
    final threads = await _dataSource.getBoardCatalog(boardId);
    final watchedThreads = _getWatchedThreads();
    return threads
        .map(
          (t) => t.copyWith(
            isWatched: watchedThreads.contains('${boardId}_${t.id}'),
          ),
        )
        .toList();
  }

  @override
  Future<Thread?> getThreadById(String boardId, String threadId) async {
    final thread = await _dataSource.getThread(boardId, threadId);
    final watchedThreads = _getWatchedThreads();
    return thread.copyWith(
      isWatched: watchedThreads.contains('${boardId}_$threadId'),
    );
  }

  // ThreadRepository specific methods
  @override
  Future<List<Thread>> getCatalog(String boardId) => getThreads(boardId);

  @override
  Future<Thread> getThreadWithReplies(String boardId, String threadId) async {
    final thread = await getThreadById(boardId, threadId);
    if (thread == null) {
      throw Exception("Thread not found");
    }
    return thread;
  }

  @override
  Future<List<Thread>> getArchive(String boardId) =>
      _dataSource.getArchive(boardId);

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

  @override
  Future<List<Media>> getAllMediaFromThreadContext(
    String boardId,
    String threadId,
  ) async {
    final thread = await getThreadWithReplies(boardId, threadId);
    final List<Media> allMedia = [];

    // Add media from the original post
    if (thread.originalPost.media != null) {
      allMedia.add(thread.originalPost.media!);
    }

    // Add media from replies
    for (final reply in thread.replies) {
      if (reply.media != null) {
        allMedia.add(reply.media!);
      }
    }

    return allMedia;
  }

  @override
  Future<bool> boardHasMedia(String boardId) async {
    final media = await getAllMediaFromBoard(boardId);
    return media.isNotEmpty;
  }

  @override
  Future<bool> threadHasMedia(String boardId, String threadId) async {
    final media = await getAllMediaFromThreadContext(boardId, threadId);
    return media.isNotEmpty;
  }

  List<String> _getWatchedThreads() {
    return _prefs.getStringList(_watchedThreadsKey) ?? [];
  }
}
