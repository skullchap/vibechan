// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thread_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$threadRepositoryHash() => r'60612995ed4a4d2199acdedbe5b9b63b4aa8d86d';

/// See also [threadRepository].
@ProviderFor(threadRepository)
final threadRepositoryProvider = Provider<ThreadRepository>.internal(
  threadRepository,
  name: r'threadRepositoryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$threadRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ThreadRepositoryRef = ProviderRef<ThreadRepository>;
String _$catalogNotifierHash() => r'87d0a1ed4746a4b0b3575bd06ec46ae272701f5f';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$CatalogNotifier
    extends BuildlessAutoDisposeAsyncNotifier<List<Thread>> {
  late final String boardId;

  FutureOr<List<Thread>> build(String boardId);
}

/// See also [CatalogNotifier].
@ProviderFor(CatalogNotifier)
const catalogNotifierProvider = CatalogNotifierFamily();

/// See also [CatalogNotifier].
class CatalogNotifierFamily extends Family<AsyncValue<List<Thread>>> {
  /// See also [CatalogNotifier].
  const CatalogNotifierFamily();

  /// See also [CatalogNotifier].
  CatalogNotifierProvider call(String boardId) {
    return CatalogNotifierProvider(boardId);
  }

  @override
  CatalogNotifierProvider getProviderOverride(
    covariant CatalogNotifierProvider provider,
  ) {
    return call(provider.boardId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'catalogNotifierProvider';
}

/// See also [CatalogNotifier].
class CatalogNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<CatalogNotifier, List<Thread>> {
  /// See also [CatalogNotifier].
  CatalogNotifierProvider(String boardId)
    : this._internal(
        () => CatalogNotifier()..boardId = boardId,
        from: catalogNotifierProvider,
        name: r'catalogNotifierProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$catalogNotifierHash,
        dependencies: CatalogNotifierFamily._dependencies,
        allTransitiveDependencies:
            CatalogNotifierFamily._allTransitiveDependencies,
        boardId: boardId,
      );

  CatalogNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.boardId,
  }) : super.internal();

  final String boardId;

  @override
  FutureOr<List<Thread>> runNotifierBuild(covariant CatalogNotifier notifier) {
    return notifier.build(boardId);
  }

  @override
  Override overrideWith(CatalogNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: CatalogNotifierProvider._internal(
        () => create()..boardId = boardId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        boardId: boardId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<CatalogNotifier, List<Thread>>
  createElement() {
    return _CatalogNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CatalogNotifierProvider && other.boardId == boardId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, boardId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CatalogNotifierRef on AutoDisposeAsyncNotifierProviderRef<List<Thread>> {
  /// The parameter `boardId` of this provider.
  String get boardId;
}

class _CatalogNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<CatalogNotifier, List<Thread>>
    with CatalogNotifierRef {
  _CatalogNotifierProviderElement(super.provider);

  @override
  String get boardId => (origin as CatalogNotifierProvider).boardId;
}

String _$threadNotifierHash() => r'3a954798b170f3dd79cfd487ebd4ac0d9ec987b7';

abstract class _$ThreadNotifier
    extends BuildlessAutoDisposeAsyncNotifier<Thread> {
  late final String boardId;
  late final String threadId;

  FutureOr<Thread> build(String boardId, String threadId);
}

/// See also [ThreadNotifier].
@ProviderFor(ThreadNotifier)
const threadNotifierProvider = ThreadNotifierFamily();

/// See also [ThreadNotifier].
class ThreadNotifierFamily extends Family<AsyncValue<Thread>> {
  /// See also [ThreadNotifier].
  const ThreadNotifierFamily();

  /// See also [ThreadNotifier].
  ThreadNotifierProvider call(String boardId, String threadId) {
    return ThreadNotifierProvider(boardId, threadId);
  }

  @override
  ThreadNotifierProvider getProviderOverride(
    covariant ThreadNotifierProvider provider,
  ) {
    return call(provider.boardId, provider.threadId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'threadNotifierProvider';
}

/// See also [ThreadNotifier].
class ThreadNotifierProvider
    extends AutoDisposeAsyncNotifierProviderImpl<ThreadNotifier, Thread> {
  /// See also [ThreadNotifier].
  ThreadNotifierProvider(String boardId, String threadId)
    : this._internal(
        () =>
            ThreadNotifier()
              ..boardId = boardId
              ..threadId = threadId,
        from: threadNotifierProvider,
        name: r'threadNotifierProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$threadNotifierHash,
        dependencies: ThreadNotifierFamily._dependencies,
        allTransitiveDependencies:
            ThreadNotifierFamily._allTransitiveDependencies,
        boardId: boardId,
        threadId: threadId,
      );

  ThreadNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.boardId,
    required this.threadId,
  }) : super.internal();

  final String boardId;
  final String threadId;

  @override
  FutureOr<Thread> runNotifierBuild(covariant ThreadNotifier notifier) {
    return notifier.build(boardId, threadId);
  }

  @override
  Override overrideWith(ThreadNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: ThreadNotifierProvider._internal(
        () =>
            create()
              ..boardId = boardId
              ..threadId = threadId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        boardId: boardId,
        threadId: threadId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ThreadNotifier, Thread>
  createElement() {
    return _ThreadNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ThreadNotifierProvider &&
        other.boardId == boardId &&
        other.threadId == threadId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, boardId.hashCode);
    hash = _SystemHash.combine(hash, threadId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ThreadNotifierRef on AutoDisposeAsyncNotifierProviderRef<Thread> {
  /// The parameter `boardId` of this provider.
  String get boardId;

  /// The parameter `threadId` of this provider.
  String get threadId;
}

class _ThreadNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ThreadNotifier, Thread>
    with ThreadNotifierRef {
  _ThreadNotifierProviderElement(super.provider);

  @override
  String get boardId => (origin as ThreadNotifierProvider).boardId;
  @override
  String get threadId => (origin as ThreadNotifierProvider).threadId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
