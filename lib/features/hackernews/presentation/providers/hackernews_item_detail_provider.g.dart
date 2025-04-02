// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hackernews_item_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$hackerNewsItemDetailHash() =>
    r'17bfaebbb5907da27e4f80307df4a3db3fc64618';

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

/// See also [hackerNewsItemDetail].
@ProviderFor(hackerNewsItemDetail)
const hackerNewsItemDetailProvider = HackerNewsItemDetailFamily();

/// See also [hackerNewsItemDetail].
class HackerNewsItemDetailFamily extends Family<AsyncValue<HackerNewsItem>> {
  /// See also [hackerNewsItemDetail].
  const HackerNewsItemDetailFamily();

  /// See also [hackerNewsItemDetail].
  HackerNewsItemDetailProvider call(int itemId) {
    return HackerNewsItemDetailProvider(itemId);
  }

  @override
  HackerNewsItemDetailProvider getProviderOverride(
    covariant HackerNewsItemDetailProvider provider,
  ) {
    return call(provider.itemId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'hackerNewsItemDetailProvider';
}

/// See also [hackerNewsItemDetail].
class HackerNewsItemDetailProvider extends FutureProvider<HackerNewsItem> {
  /// See also [hackerNewsItemDetail].
  HackerNewsItemDetailProvider(int itemId)
    : this._internal(
        (ref) => hackerNewsItemDetail(ref as HackerNewsItemDetailRef, itemId),
        from: hackerNewsItemDetailProvider,
        name: r'hackerNewsItemDetailProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$hackerNewsItemDetailHash,
        dependencies: HackerNewsItemDetailFamily._dependencies,
        allTransitiveDependencies:
            HackerNewsItemDetailFamily._allTransitiveDependencies,
        itemId: itemId,
      );

  HackerNewsItemDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.itemId,
  }) : super.internal();

  final int itemId;

  @override
  Override overrideWith(
    FutureOr<HackerNewsItem> Function(HackerNewsItemDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HackerNewsItemDetailProvider._internal(
        (ref) => create(ref as HackerNewsItemDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        itemId: itemId,
      ),
    );
  }

  @override
  FutureProviderElement<HackerNewsItem> createElement() {
    return _HackerNewsItemDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HackerNewsItemDetailProvider && other.itemId == itemId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, itemId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin HackerNewsItemDetailRef on FutureProviderRef<HackerNewsItem> {
  /// The parameter `itemId` of this provider.
  int get itemId;
}

class _HackerNewsItemDetailProviderElement
    extends FutureProviderElement<HackerNewsItem>
    with HackerNewsItemDetailRef {
  _HackerNewsItemDetailProviderElement(super.provider);

  @override
  int get itemId => (origin as HackerNewsItemDetailProvider).itemId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
