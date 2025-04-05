// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carousel_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$carouselMediaListHash() => r'd2dcdf3d896f8eeb0537e8725defd30892501f37';

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

/// See also [carouselMediaList].
@ProviderFor(carouselMediaList)
const carouselMediaListProvider = CarouselMediaListFamily();

/// See also [carouselMediaList].
class CarouselMediaListFamily extends Family<AsyncValue<List<Media>>> {
  /// See also [carouselMediaList].
  const CarouselMediaListFamily();

  /// See also [carouselMediaList].
  CarouselMediaListProvider call(String sourceInfo) {
    return CarouselMediaListProvider(sourceInfo);
  }

  @override
  CarouselMediaListProvider getProviderOverride(
    covariant CarouselMediaListProvider provider,
  ) {
    return call(provider.sourceInfo);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'carouselMediaListProvider';
}

/// See also [carouselMediaList].
class CarouselMediaListProvider extends AutoDisposeFutureProvider<List<Media>> {
  /// See also [carouselMediaList].
  CarouselMediaListProvider(String sourceInfo)
    : this._internal(
        (ref) => carouselMediaList(ref as CarouselMediaListRef, sourceInfo),
        from: carouselMediaListProvider,
        name: r'carouselMediaListProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$carouselMediaListHash,
        dependencies: CarouselMediaListFamily._dependencies,
        allTransitiveDependencies:
            CarouselMediaListFamily._allTransitiveDependencies,
        sourceInfo: sourceInfo,
      );

  CarouselMediaListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.sourceInfo,
  }) : super.internal();

  final String sourceInfo;

  @override
  Override overrideWith(
    FutureOr<List<Media>> Function(CarouselMediaListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CarouselMediaListProvider._internal(
        (ref) => create(ref as CarouselMediaListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        sourceInfo: sourceInfo,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Media>> createElement() {
    return _CarouselMediaListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CarouselMediaListProvider && other.sourceInfo == sourceInfo;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, sourceInfo.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CarouselMediaListRef on AutoDisposeFutureProviderRef<List<Media>> {
  /// The parameter `sourceInfo` of this provider.
  String get sourceInfo;
}

class _CarouselMediaListProviderElement
    extends AutoDisposeFutureProviderElement<List<Media>>
    with CarouselMediaListRef {
  _CarouselMediaListProviderElement(super.provider);

  @override
  String get sourceInfo => (origin as CarouselMediaListProvider).sourceInfo;
}

String _$boardHasMediaHash() => r'ab66fee05f2ccd747674b2ea1c2b45434f583ee5';

/// See also [boardHasMedia].
@ProviderFor(boardHasMedia)
const boardHasMediaProvider = BoardHasMediaFamily();

/// See also [boardHasMedia].
class BoardHasMediaFamily extends Family<AsyncValue<bool>> {
  /// See also [boardHasMedia].
  const BoardHasMediaFamily();

  /// See also [boardHasMedia].
  BoardHasMediaProvider call(String sourceInfo) {
    return BoardHasMediaProvider(sourceInfo);
  }

  @override
  BoardHasMediaProvider getProviderOverride(
    covariant BoardHasMediaProvider provider,
  ) {
    return call(provider.sourceInfo);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'boardHasMediaProvider';
}

/// See also [boardHasMedia].
class BoardHasMediaProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [boardHasMedia].
  BoardHasMediaProvider(String sourceInfo)
    : this._internal(
        (ref) => boardHasMedia(ref as BoardHasMediaRef, sourceInfo),
        from: boardHasMediaProvider,
        name: r'boardHasMediaProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$boardHasMediaHash,
        dependencies: BoardHasMediaFamily._dependencies,
        allTransitiveDependencies:
            BoardHasMediaFamily._allTransitiveDependencies,
        sourceInfo: sourceInfo,
      );

  BoardHasMediaProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.sourceInfo,
  }) : super.internal();

  final String sourceInfo;

  @override
  Override overrideWith(
    FutureOr<bool> Function(BoardHasMediaRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BoardHasMediaProvider._internal(
        (ref) => create(ref as BoardHasMediaRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        sourceInfo: sourceInfo,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _BoardHasMediaProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BoardHasMediaProvider && other.sourceInfo == sourceInfo;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, sourceInfo.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin BoardHasMediaRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `sourceInfo` of this provider.
  String get sourceInfo;
}

class _BoardHasMediaProviderElement
    extends AutoDisposeFutureProviderElement<bool>
    with BoardHasMediaRef {
  _BoardHasMediaProviderElement(super.provider);

  @override
  String get sourceInfo => (origin as BoardHasMediaProvider).sourceInfo;
}

String _$threadHasMediaHash() => r'30bd6ab2bd5a5469f75e2dec0bd69a679c464c59';

/// See also [threadHasMedia].
@ProviderFor(threadHasMedia)
const threadHasMediaProvider = ThreadHasMediaFamily();

/// See also [threadHasMedia].
class ThreadHasMediaFamily extends Family<AsyncValue<bool>> {
  /// See also [threadHasMedia].
  const ThreadHasMediaFamily();

  /// See also [threadHasMedia].
  ThreadHasMediaProvider call(String sourceInfo) {
    return ThreadHasMediaProvider(sourceInfo);
  }

  @override
  ThreadHasMediaProvider getProviderOverride(
    covariant ThreadHasMediaProvider provider,
  ) {
    return call(provider.sourceInfo);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'threadHasMediaProvider';
}

/// See also [threadHasMedia].
class ThreadHasMediaProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [threadHasMedia].
  ThreadHasMediaProvider(String sourceInfo)
    : this._internal(
        (ref) => threadHasMedia(ref as ThreadHasMediaRef, sourceInfo),
        from: threadHasMediaProvider,
        name: r'threadHasMediaProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$threadHasMediaHash,
        dependencies: ThreadHasMediaFamily._dependencies,
        allTransitiveDependencies:
            ThreadHasMediaFamily._allTransitiveDependencies,
        sourceInfo: sourceInfo,
      );

  ThreadHasMediaProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.sourceInfo,
  }) : super.internal();

  final String sourceInfo;

  @override
  Override overrideWith(
    FutureOr<bool> Function(ThreadHasMediaRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ThreadHasMediaProvider._internal(
        (ref) => create(ref as ThreadHasMediaRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        sourceInfo: sourceInfo,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _ThreadHasMediaProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ThreadHasMediaProvider && other.sourceInfo == sourceInfo;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, sourceInfo.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ThreadHasMediaRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `sourceInfo` of this provider.
  String get sourceInfo;
}

class _ThreadHasMediaProviderElement
    extends AutoDisposeFutureProviderElement<bool>
    with ThreadHasMediaRef {
  _ThreadHasMediaProviderElement(super.provider);

  @override
  String get sourceInfo => (origin as ThreadHasMediaProvider).sourceInfo;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
