// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hackernews_stories_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$hackerNewsStoriesHash() => r'2dc0b599f1f949696f10df29a4af2f559cbcc8de';

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

/// See also [hackerNewsStories].
@ProviderFor(hackerNewsStories)
const hackerNewsStoriesProvider = HackerNewsStoriesFamily();

/// See also [hackerNewsStories].
class HackerNewsStoriesFamily
    extends Family<AsyncValue<List<GenericListItem>>> {
  /// See also [hackerNewsStories].
  const HackerNewsStoriesFamily();

  /// See also [hackerNewsStories].
  HackerNewsStoriesProvider call(HackerNewsSortType sortType) {
    return HackerNewsStoriesProvider(sortType);
  }

  @override
  HackerNewsStoriesProvider getProviderOverride(
    covariant HackerNewsStoriesProvider provider,
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
  String? get name => r'hackerNewsStoriesProvider';
}

/// See also [hackerNewsStories].
class HackerNewsStoriesProvider extends FutureProvider<List<GenericListItem>> {
  /// See also [hackerNewsStories].
  HackerNewsStoriesProvider(HackerNewsSortType sortType)
    : this._internal(
        (ref) => hackerNewsStories(ref as HackerNewsStoriesRef, sortType),
        from: hackerNewsStoriesProvider,
        name: r'hackerNewsStoriesProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$hackerNewsStoriesHash,
        dependencies: HackerNewsStoriesFamily._dependencies,
        allTransitiveDependencies:
            HackerNewsStoriesFamily._allTransitiveDependencies,
        sortType: sortType,
      );

  HackerNewsStoriesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.sortType,
  }) : super.internal();

  final HackerNewsSortType sortType;

  @override
  Override overrideWith(
    FutureOr<List<GenericListItem>> Function(HackerNewsStoriesRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HackerNewsStoriesProvider._internal(
        (ref) => create(ref as HackerNewsStoriesRef),
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
    return _HackerNewsStoriesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HackerNewsStoriesProvider && other.sortType == sortType;
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
mixin HackerNewsStoriesRef on FutureProviderRef<List<GenericListItem>> {
  /// The parameter `sortType` of this provider.
  HackerNewsSortType get sortType;
}

class _HackerNewsStoriesProviderElement
    extends FutureProviderElement<List<GenericListItem>>
    with HackerNewsStoriesRef {
  _HackerNewsStoriesProviderElement(super.provider);

  @override
  HackerNewsSortType get sortType =>
      (origin as HackerNewsStoriesProvider).sortType;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
