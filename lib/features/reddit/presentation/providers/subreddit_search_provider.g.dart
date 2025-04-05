// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subreddit_search_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$subredditSearchHash() => r'579d15205f4bb4d0888eae3a29b8d81d9e0ba85d';

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

/// See also [subredditSearch].
@ProviderFor(subredditSearch)
const subredditSearchProvider = SubredditSearchFamily();

/// See also [subredditSearch].
class SubredditSearchFamily extends Family<AsyncValue<List<SubredditInfo>>> {
  /// See also [subredditSearch].
  const SubredditSearchFamily();

  /// See also [subredditSearch].
  SubredditSearchProvider call(String query) {
    return SubredditSearchProvider(query);
  }

  @override
  SubredditSearchProvider getProviderOverride(
    covariant SubredditSearchProvider provider,
  ) {
    return call(provider.query);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'subredditSearchProvider';
}

/// See also [subredditSearch].
class SubredditSearchProvider
    extends AutoDisposeFutureProvider<List<SubredditInfo>> {
  /// See also [subredditSearch].
  SubredditSearchProvider(String query)
    : this._internal(
        (ref) => subredditSearch(ref as SubredditSearchRef, query),
        from: subredditSearchProvider,
        name: r'subredditSearchProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$subredditSearchHash,
        dependencies: SubredditSearchFamily._dependencies,
        allTransitiveDependencies:
            SubredditSearchFamily._allTransitiveDependencies,
        query: query,
      );

  SubredditSearchProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  Override overrideWith(
    FutureOr<List<SubredditInfo>> Function(SubredditSearchRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SubredditSearchProvider._internal(
        (ref) => create(ref as SubredditSearchRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<SubredditInfo>> createElement() {
    return _SubredditSearchProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SubredditSearchProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SubredditSearchRef on AutoDisposeFutureProviderRef<List<SubredditInfo>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _SubredditSearchProviderElement
    extends AutoDisposeFutureProviderElement<List<SubredditInfo>>
    with SubredditSearchRef {
  _SubredditSearchProviderElement(super.provider);

  @override
  String get query => (origin as SubredditSearchProvider).query;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
