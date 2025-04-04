// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$boardRepositoryHash() => r'cecc6b1e6ad901526f01ef45d8ef674d345baa65';

/// See also [boardRepository].
@ProviderFor(boardRepository)
final boardRepositoryProvider = Provider<BoardRepository>.internal(
  boardRepository,
  name: r'boardRepositoryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$boardRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BoardRepositoryRef = ProviderRef<BoardRepository>;
String _$boardsNotifierHash() => r'2a9289b6c48b87a4297ac528cf3129e627ad667d';

/// See also [BoardsNotifier].
@ProviderFor(BoardsNotifier)
final boardsNotifierProvider =
    AsyncNotifierProvider<BoardsNotifier, List<Board>>.internal(
      BoardsNotifier.new,
      name: r'boardsNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$boardsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$BoardsNotifier = AsyncNotifier<List<Board>>;
String _$worksafeBoardsNotifierHash() =>
    r'f2b7c89013018acd1b44750f63eb06884950d4a9';

/// See also [WorksafeBoardsNotifier].
@ProviderFor(WorksafeBoardsNotifier)
final worksafeBoardsNotifierProvider =
    AsyncNotifierProvider<WorksafeBoardsNotifier, List<Board>>.internal(
      WorksafeBoardsNotifier.new,
      name: r'worksafeBoardsNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$worksafeBoardsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$WorksafeBoardsNotifier = AsyncNotifier<List<Board>>;
String _$nSFWBoardsNotifierHash() =>
    r'fd9e7c8840e6da3ee709a372d58a783c8a499214';

/// See also [NSFWBoardsNotifier].
@ProviderFor(NSFWBoardsNotifier)
final nSFWBoardsNotifierProvider =
    AsyncNotifierProvider<NSFWBoardsNotifier, List<Board>>.internal(
      NSFWBoardsNotifier.new,
      name: r'nSFWBoardsNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$nSFWBoardsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$NSFWBoardsNotifier = AsyncNotifier<List<Board>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
