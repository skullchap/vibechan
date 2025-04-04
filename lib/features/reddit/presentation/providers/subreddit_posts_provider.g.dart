// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subreddit_posts_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$subredditPostsHash() => r'a47e493cd0908aa830ba57ff8ef76e7da5fa3d17';

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

abstract class _$SubredditPosts
    extends BuildlessAsyncNotifier<List<RedditPost>> {
  late final String subreddit;

  FutureOr<List<RedditPost>> build(String subreddit);
}

/// See also [SubredditPosts].
@ProviderFor(SubredditPosts)
const subredditPostsProvider = SubredditPostsFamily();

/// See also [SubredditPosts].
class SubredditPostsFamily extends Family<AsyncValue<List<RedditPost>>> {
  /// See also [SubredditPosts].
  const SubredditPostsFamily();

  /// See also [SubredditPosts].
  SubredditPostsProvider call(String subreddit) {
    return SubredditPostsProvider(subreddit);
  }

  @override
  SubredditPostsProvider getProviderOverride(
    covariant SubredditPostsProvider provider,
  ) {
    return call(provider.subreddit);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'subredditPostsProvider';
}

/// See also [SubredditPosts].
class SubredditPostsProvider
    extends AsyncNotifierProviderImpl<SubredditPosts, List<RedditPost>> {
  /// See also [SubredditPosts].
  SubredditPostsProvider(String subreddit)
    : this._internal(
        () => SubredditPosts()..subreddit = subreddit,
        from: subredditPostsProvider,
        name: r'subredditPostsProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$subredditPostsHash,
        dependencies: SubredditPostsFamily._dependencies,
        allTransitiveDependencies:
            SubredditPostsFamily._allTransitiveDependencies,
        subreddit: subreddit,
      );

  SubredditPostsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.subreddit,
  }) : super.internal();

  final String subreddit;

  @override
  FutureOr<List<RedditPost>> runNotifierBuild(
    covariant SubredditPosts notifier,
  ) {
    return notifier.build(subreddit);
  }

  @override
  Override overrideWith(SubredditPosts Function() create) {
    return ProviderOverride(
      origin: this,
      override: SubredditPostsProvider._internal(
        () => create()..subreddit = subreddit,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        subreddit: subreddit,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<SubredditPosts, List<RedditPost>>
  createElement() {
    return _SubredditPostsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SubredditPostsProvider && other.subreddit == subreddit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, subreddit.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SubredditPostsRef on AsyncNotifierProviderRef<List<RedditPost>> {
  /// The parameter `subreddit` of this provider.
  String get subreddit;
}

class _SubredditPostsProviderElement
    extends AsyncNotifierProviderElement<SubredditPosts, List<RedditPost>>
    with SubredditPostsRef {
  _SubredditPostsProviderElement(super.provider);

  @override
  String get subreddit => (origin as SubredditPostsProvider).subreddit;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
