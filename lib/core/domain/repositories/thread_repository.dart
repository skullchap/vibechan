import '../models/thread.dart';
import '../models/post.dart';
import 'base_repository.dart';

abstract class ThreadRepository extends BaseThreadRepository {
  Future<List<Thread>> getCatalog(String boardId);
  Future<Thread> getThreadWithReplies(String boardId, String threadId);
  Future<List<Thread>> getArchive(String boardId);
  Future<void> refreshThread(String boardId, String threadId);
  Future<Post> createReply(String boardId, String threadId, Post post);
  Future<void> watchThread(String boardId, String threadId);
  Future<void> unwatchThread(String boardId, String threadId);
}