// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lobsters_stories_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$lobstersStoriesHash() => r'343c8d7ac0d926f6d0b70301ca6287e310b17e91';

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

/// See also [lobstersStories].
@ProviderFor(lobstersStories)
const lobstersStoriesProvider = LobstersStoriesFamily();

/// See also [lobstersStories].
class LobstersStoriesFamily extends Family<AsyncValue<List<GenericListItem>>> {
  /// See also [lobstersStories].
  const LobstersStoriesFamily();

  /// See also [lobstersStories].
  LobstersStoriesProvider call(LobstersSortType sortType) {
    return LobstersStoriesProvider(sortType);
  }

  @override
  LobstersStoriesProvider getProviderOverride(
    covariant LobstersStoriesProvider provider,
  ) {
    return call(provider.sortType);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'lobstersStoriesProvider';
}

/// See also [lobstersStories].
class LobstersStoriesProvider extends FutureProvider<List<GenericListItem>> {
  /// See also [lobstersStories].
  LobstersStoriesProvider(LobstersSortType sortType)
    : this._internal(
        (ref) => lobstersStories(ref as LobstersStoriesRef, sortType),
        from: lobstersStoriesProvider,
        name: r'lobstersStoriesProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$lobstersStoriesHash,
        dependencies: LobstersStoriesFamily._dependencies,
        allTransitiveDependencies:
            LobstersStoriesFamily._allTransitiveDependencies,
        sortType: sortType,
      );

  LobstersStoriesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.sortType,
  }) : super.internal();

  final LobstersSortType sortType;

  @override
  Override overrideWith(
    FutureOr<List<GenericListItem>> Function(LobstersStoriesRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LobstersStoriesProvider._internal(
        (ref) => create(ref as LobstersStoriesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        sortType: sortType,
      ),
    );
  }

  @override
  FutureProviderElement<List<GenericListItem>> createElement() {
    return _LobstersStoriesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LobstersStoriesProvider && other.sortType == sortType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, sortType.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LobstersStoriesRef on FutureProviderRef<List<GenericListItem>> {
  /// The parameter `sortType` of this provider.
  LobstersSortType get sortType;
}

class _LobstersStoriesProviderElement
    extends FutureProviderElement<List<GenericListItem>>
    with LobstersStoriesRef {
  _LobstersStoriesProviderElement(super.provider);

  @override
  LobstersSortType get sortType => (origin as LobstersStoriesProvider).sortType;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
