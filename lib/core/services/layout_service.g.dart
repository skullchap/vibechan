// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'layout_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$layoutServiceHash() => r'4771e0f80b7b13c9c5249a54cf417f53e01d629f';

/// Riverpod provider for layout service
///
/// Copied from [layoutService].
@ProviderFor(layoutService)
final layoutServiceProvider = AutoDisposeProvider<LayoutService>.internal(
  layoutService,
  name: r'layoutServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$layoutServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LayoutServiceRef = AutoDisposeProviderRef<LayoutService>;
String _$layoutStateNotifierHash() =>
    r'a5e843c033bc412d0d872075da6d14731ef98d86';

/// Riverpod provider for current layout state
///
/// Copied from [LayoutStateNotifier].
@ProviderFor(LayoutStateNotifier)
final layoutStateNotifierProvider =
    AutoDisposeNotifierProvider<LayoutStateNotifier, LayoutState>.internal(
      LayoutStateNotifier.new,
      name: r'layoutStateNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$layoutStateNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$LayoutStateNotifier = AutoDisposeNotifier<LayoutState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
