import 'package:injectable/injectable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/repositories/board_repository.dart';
import '../domain/repositories/thread_repository.dart';
import '../data/repositories/fourchan_repository.dart';
import '../presentation/providers/board_providers.dart';
import '../presentation/providers/thread_providers.dart';

@module
abstract class ProvidersModule {
  @lazySingleton
  @Named('4chan')
  BoardRepository provideBoardRepository(
    @Named('4chan') FourChanRepository repository,
  ) =>
      repository;

  @lazySingleton
  @Named('4chan')
  ThreadRepository provideThreadRepository(
    @Named('4chan') FourChanRepository repository,
  ) =>
      repository;

  @singleton
  ProviderContainer provideContainer(
    @Named('4chan') BoardRepository boardRepository,
    @Named('4chan') ThreadRepository threadRepository,
  ) {
    final container = ProviderContainer(
      overrides: [
        boardRepositoryProvider.overrideWithValue(boardRepository),
        threadRepositoryProvider.overrideWithValue(threadRepository),
      ],
    );
    return container;
  }
}