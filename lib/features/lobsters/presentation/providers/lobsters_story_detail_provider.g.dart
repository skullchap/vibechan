// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lobsters_story_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$lobstersStoryDetailHash() =>
    r'3b8ed77f31e7595aaa5dae247165346bf8431605';

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

/// See also [lobstersStoryDetail].
@ProviderFor(lobstersStoryDetail)
const lobstersStoryDetailProvider = LobstersStoryDetailFamily();

/// See also [lobstersStoryDetail].
class LobstersStoryDetailFamily extends Family<AsyncValue<LobstersStory>> {
  /// See also [lobstersStoryDetail].
  const LobstersStoryDetailFamily();

  /// See also [lobstersStoryDetail].
  LobstersStoryDetailProvider call(String storyId) {
    return LobstersStoryDetailProvider(storyId);
  }

  @override
  LobstersStoryDetailProvider getProviderOverride(
    covariant LobstersStoryDetailProvider provider,
  ) {
    return call(provider.storyId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'lobstersStoryDetailProvider';
}

/// See also [lobstersStoryDetail].
class LobstersStoryDetailProvider extends FutureProvider<LobstersStory> {
  /// See also [lobstersStoryDetail].
  LobstersStoryDetailProvider(String storyId)
    : this._internal(
        (ref) => lobstersStoryDetail(ref as LobstersStoryDetailRef, storyId),
        from: lobstersStoryDetailProvider,
        name: r'lobstersStoryDetailProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$lobstersStoryDetailHash,
        dependencies: LobstersStoryDetailFamily._dependencies,
        allTransitiveDependencies:
            LobstersStoryDetailFamily._allTransitiveDependencies,
        storyId: storyId,
      );

  LobstersStoryDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.storyId,
  }) : super.internal();

  final String storyId;

  @override
  Override overrideWith(
    FutureOr<LobstersStory> Function(LobstersStoryDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LobstersStoryDetailProvider._internal(
        (ref) => create(ref as LobstersStoryDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        storyId: storyId,
      ),
    );
  }

  @override
  FutureProviderElement<LobstersStory> createElement() {
    return _LobstersStoryDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LobstersStoryDetailProvider && other.storyId == storyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, storyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LobstersStoryDetailRef on FutureProviderRef<LobstersStory> {
  /// The parameter `storyId` of this provider.
  String get storyId;
}

class _LobstersStoryDetailProviderElement
    extends FutureProviderElement<LobstersStory>
    with LobstersStoryDetailRef {
  _LobstersStoryDetailProviderElement(super.provider);

  @override
  String get storyId => (origin as LobstersStoryDetailProvider).storyId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
