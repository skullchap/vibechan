// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$boardRepositoryHash() => r'108809e30bed6f4e62b205e2b0ff3ede1fb27f65';

/// See also [boardRepository].
@ProviderFor(boardRepository)
final boardRepositoryProvider = AutoDisposeProvider<BoardRepository>.internal(
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
typedef BoardRepositoryRef = AutoDisposeProviderRef<BoardRepository>;
String _$boardsNotifierHash() => r'23cc66b1da0bcb2079bd7d0e5c362f70dc0cb654';

/// See also [BoardsNotifier].
@ProviderFor(BoardsNotifier)
final boardsNotifierProvider =
    AutoDisposeAsyncNotifierProvider<BoardsNotifier, List<Board>>.internal(
      BoardsNotifier.new,
      name: r'boardsNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$boardsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$BoardsNotifier = AutoDisposeAsyncNotifier<List<Board>>;
String _$worksafeBoardsNotifierHash() =>
    r'a875066334eb6245bb842ea8f56addc5cbf998ae';

/// See also [WorksafeBoardsNotifier].
@ProviderFor(WorksafeBoardsNotifier)
final worksafeBoardsNotifierProvider = AutoDisposeAsyncNotifierProvider<
  WorksafeBoardsNotifier,
  List<Board>
>.internal(
  WorksafeBoardsNotifier.new,
  name: r'worksafeBoardsNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$worksafeBoardsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$WorksafeBoardsNotifier = AutoDisposeAsyncNotifier<List<Board>>;
String _$nSFWBoardsNotifierHash() =>
    r'424397f75241c99b3a230cc654ea88079957fb28';

/// See also [NSFWBoardsNotifier].
@ProviderFor(NSFWBoardsNotifier)
final nSFWBoardsNotifierProvider =
    AutoDisposeAsyncNotifierProvider<NSFWBoardsNotifier, List<Board>>.internal(
      NSFWBoardsNotifier.new,
      name: r'nSFWBoardsNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$nSFWBoardsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$NSFWBoardsNotifier = AutoDisposeAsyncNotifier<List<Board>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
