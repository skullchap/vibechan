import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/models/board.dart';
import '../../domain/repositories/board_repository.dart';

part 'board_providers.g.dart';

@Riverpod(keepAlive: true)
BoardRepository boardRepository(Ref ref) {
  throw UnimplementedError('Provider must be overridden with a specific implementation');
}

@riverpod
class BoardsNotifier extends _$BoardsNotifier {
  @override
  Future<List<Board>> build() async {
    return ref.watch(boardRepositoryProvider).getAll();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(boardRepositoryProvider).getAll());
  }
}

@riverpod
class WorksafeBoardsNotifier extends _$WorksafeBoardsNotifier {
  @override
  Future<List<Board>> build() async {
    return ref.watch(boardRepositoryProvider).getWorkSafeBoards();
  }
}

@riverpod
class NsfwBoardsNotifier extends _$NsfwBoardsNotifier {
  @override
  Future<List<Board>> build() async {
    return ref.watch(boardRepositoryProvider).getNSFWBoards();
  }
}