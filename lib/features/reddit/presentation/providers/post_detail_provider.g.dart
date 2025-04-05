// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$postDetailHash() => r'13d81eb56a451de23c2010f3d27e4c53b24d3c7e';

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

/// See also [postDetail].
@ProviderFor(postDetail)
const postDetailProvider = PostDetailFamily();

/// See also [postDetail].
class PostDetailFamily
    extends Family<AsyncValue<(RedditPost, List<RedditComment>)>> {
  /// See also [postDetail].
  const PostDetailFamily();

  /// See also [postDetail].
  PostDetailProvider call(PostDetailParams params) {
    return PostDetailProvider(params);
  }

  @override
  PostDetailProvider getProviderOverride(
    covariant PostDetailProvider provider,
  ) {
    return call(provider.params);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'postDetailProvider';
}

/// See also [postDetail].
class PostDetailProvider
    extends FutureProvider<(RedditPost, List<RedditComment>)> {
  /// See also [postDetail].
  PostDetailProvider(PostDetailParams params)
    : this._internal(
        (ref) => postDetail(ref as PostDetailRef, params),
        from: postDetailProvider,
        name: r'postDetailProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$postDetailHash,
        dependencies: PostDetailFamily._dependencies,
        allTransitiveDependencies: PostDetailFamily._allTransitiveDependencies,
        params: params,
      );

  PostDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.params,
  }) : super.internal();

  final PostDetailParams params;

  @override
  Override overrideWith(
    FutureOr<(RedditPost, List<RedditComment>)> Function(PostDetailRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PostDetailProvider._internal(
        (ref) => create(ref as PostDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        params: params,
      ),
    );
  }

  @override
  FutureProviderElement<(RedditPost, List<RedditComment>)> createElement() {
    return _PostDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PostDetailProvider && other.params == params;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, params.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PostDetailRef on FutureProviderRef<(RedditPost, List<RedditComment>)> {
  /// The parameter `params` of this provider.
  PostDetailParams get params;
}

class _PostDetailProviderElement
    extends FutureProviderElement<(RedditPost, List<RedditComment>)>
    with PostDetailRef {
  _PostDetailProviderElement(super.provider);

  @override
  PostDetailParams get params => (origin as PostDetailProvider).params;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
