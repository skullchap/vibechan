import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/models/board.dart';
import '../../../domain/models/thread.dart';
import '../../../domain/models/post.dart';
import '../chan_data_source.dart';
import 'fourchan_config.dart';
import 'models/fourchan_board.dart';
import 'models/fourchan_thread.dart';
import 'models/fourchan_post.dart';

@LazySingleton(as: ChanDataSource)
@Named('4chan')
class FourChanDataSource implements ChanDataSource {
  final Dio _dio;
  DateTime? _lastRequestTime;

  FourChanDataSource(this._dio) {
    _dio.options.headers.addAll(FourChanConfig.defaultHeaders);
    _dio.options.sendTimeout = FourChanConfig.defaultTimeout;
    _dio.options.receiveTimeout = FourChanConfig.defaultTimeout;
    _dio.options.baseUrl = baseUrl;
  }

  @override
  String get baseUrl => FourChanConfig.apiBaseUrl;

  @override
  String get mediaUrl => FourChanConfig.mediaBaseUrl;

  Future<void> _throttleRequest() async {
    if (_lastRequestTime != null) {
      final timeSinceLastRequest = DateTime.now().difference(_lastRequestTime!);
      if (timeSinceLastRequest < FourChanConfig.minRequestInterval) {
        await Future.delayed(FourChanConfig.minRequestInterval - timeSinceLastRequest);
      }
    }
    _lastRequestTime = DateTime.now();
  }

  @override
  Future<List<Board>> getBoards() async {
    await _throttleRequest();
    final response = await _dio.get('/boards.json');
    final List<dynamic> boards = response.data['boards'];
    return boards.map((b) => FourChanBoard.fromJson(b).toBoard()).toList();
  }

  @override
  Future<List<Thread>> getBoardCatalog(String boardId) async {
    await _throttleRequest();
    final response = await _dio.get('/$boardId/catalog.json');
    final List<dynamic> pages = response.data;
    return pages
        .expand((page) => page['threads'])
        .map((t) => FourChanThread.fromJson(t).toThread(boardId))
        .toList();
  }

  @override
  Future<Thread> getThread(String boardId, String threadId) async {
    await _throttleRequest();
    final response = await _dio.get('/$boardId/thread/$threadId.json');
    final Map<String, dynamic> threadData = response.data;
    return FourChanThread.fromJson(threadData).toThread(boardId);
  }

  @override
  Future<List<Thread>> getArchive(String boardId) async {
    await _throttleRequest();
    final response = await _dio.get('/$boardId/archive.json');
    final List<dynamic> threadIds = response.data;
    return threadIds.map((id) => Thread(
      id: id.toString(),
      boardId: boardId,
      originalPost: Post(
        id: id.toString(),
        boardId: boardId,
        timestamp: DateTime.now(),
        comment: '',
      ),
    )).toList();
  }

  @override
  Future<Post> createReply(String boardId, String threadId, Post post) async {
    throw UnimplementedError('Posting is not yet implemented');
  }

  @override
  Future<String> uploadMedia(String path, String boardId) async {
    throw UnimplementedError('Media upload is not yet implemented');
  }

  @override
  String getMediaUrl(String boardId, String filename) {
    return '$mediaUrl/$boardId/$filename';
  }

  @override
  String getThumbnailUrl(String boardId, String filename) {
    return '$mediaUrl/$boardId/${filename}s.jpg';
  }
}