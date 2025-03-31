import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/models/board.dart';
import '../../domain/repositories/board_repository.dart';

part 'board_providers.g.dart';

@Riverpod(keepAlive: true)
BoardRepository boardRepository(Ref ref) {
  throw UnimplementedError('Provider must be overridden with a specific implementation');
}

@Riverpod(keepAlive: true)
class BoardsNotifier extends _$BoardsNotifier {
  @override
  Future<List<Board>> build() async {
    // Use getBoards() (defined in BaseBoardRepository) instead of getAll()
    return ref.watch(boardRepositoryProvider).getBoards();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(boardRepositoryProvider).getBoards());
  }
}

@Riverpod(keepAlive: true)
class WorksafeBoardsNotifier extends _$WorksafeBoardsNotifier {
  @override
  Future<List<Board>> build() async {
    return ref.watch(boardRepositoryProvider).getWorkSafeBoards();
  }
}

@Riverpod(keepAlive: true)
class NSFWBoardsNotifier extends _$NSFWBoardsNotifier {
  @override
  Future<List<Board>> build() async {
    return ref.watch(boardRepositoryProvider).getNSFWBoards();
  }
}
