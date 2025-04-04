import 'package:injectable/injectable.dart';
import 'package:vibechan/features/fourchan/data/repositories/fourchan_repository.dart';

import '../../features/fourchan/domain/repositories/board_repository.dart';
import '../../features/fourchan/domain/repositories/thread_repository.dart';

@module
abstract class ProvidersModule {
  @lazySingleton
  @Named('4chan')
  BoardRepository provideBoardRepository(
    @Named('4chan') FourChanRepository repository,
  ) => repository;

  @lazySingleton
  @Named('4chan')
  ThreadRepository provideThreadRepository(
    @Named('4chan') FourChanRepository repository,
  ) => repository;
}
