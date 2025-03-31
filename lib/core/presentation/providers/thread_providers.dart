import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/models/thread.dart';
import '../../domain/repositories/thread_repository.dart';

part 'thread_providers.g.dart';

@Riverpod(keepAlive: true)
ThreadRepository threadRepository(Ref ref) {
  throw UnimplementedError('Provider must be overridden with a specific implementation');
}

@riverpod
class CatalogNotifier extends _$CatalogNotifier {
  @override
  Future<List<Thread>> build(String boardId) async {
    return ref.watch(threadRepositoryProvider).getCatalog(boardId);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(threadRepositoryProvider).getCatalog(boardId));
  }
}

@riverpod
class ThreadNotifier extends _$ThreadNotifier {
  @override
  Future<Thread> build(String boardId, String threadId) async {
    return ref.watch(threadRepositoryProvider).getThreadWithReplies(boardId, threadId);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(threadRepositoryProvider).getThreadWithReplies(boardId, threadId));
  }

  Future<void> toggleWatch() async {
    final thread = await future;
    if (thread.isWatched) {
      await ref.read(threadRepositoryProvider).unwatchThread(boardId, threadId);
    } else {
      await ref.read(threadRepositoryProvider).watchThread(boardId, threadId);
    }
    refresh();
  }
}