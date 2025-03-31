import '../../domain/models/board.dart';
import '../../domain/models/thread.dart';
import '../../domain/models/post.dart';

abstract class ChanDataSource {
  /// The base URL for the API
  String get baseUrl;
  
  /// The base URL for media files
  String get mediaUrl;

  /// Fetch list of all available boards
  Future<List<Board>> getBoards();

  /// Fetch thread catalog for a board
  Future<List<Thread>> getBoardCatalog(String boardId);

  /// Fetch complete thread with all replies
  Future<Thread> getThread(String boardId, String threadId);

  /// Fetch archive of threads
  Future<List<Thread>> getArchive(String boardId);

  /// Create a new reply in a thread
  Future<Post> createReply(String boardId, String threadId, Post post);

  /// Upload media to the server
  Future<String> uploadMedia(String path, String boardId);

  /// Get the URL for a media file
  String getMediaUrl(String boardId, String filename);

  /// Get the URL for a thumbnail
  String getThumbnailUrl(String boardId, String filename);
}