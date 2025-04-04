import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vibechan/core/di/injection.dart';
import 'package:vibechan/core/services/theme_persistence_service.dart';

part 'theme_provider.g.dart';

// Provider to expose the ThemePersistenceService from GetIt
final themePersistenceServiceProvider = Provider<ThemePersistenceService>((
  ref,
) {
  // This assumes GetIt has been configured beforehand
  return getIt<ThemePersistenceService>();
});

// Helper class to hold scheme info
@immutable
class AppSchemeInfo {
  final String name;
  final String description;
  final FlexScheme scheme;

  const AppSchemeInfo({
    required this.name,
    required this.description,
    required this.scheme,
  });
}

// Define available color schemes using the helper class
const List<AppSchemeInfo> _appColorSchemes = [
  AppSchemeInfo(
    name: 'Deep Blue',
    description: 'Deep blue theme from FlexColorScheme package',
    scheme: FlexScheme.deepBlue,
  ),
  AppSchemeInfo(
    name: 'Aqua Blue',
    description: 'Aqua blue theme from FlexColorScheme package',
    scheme: FlexScheme.aquaBlue,
  ),
  AppSchemeInfo(
    name: 'Sakura',
    description: 'Light pink theme from FlexColorScheme package',
    scheme: FlexScheme.sakura,
  ),
  AppSchemeInfo(
    name: 'Indigo',
    description: 'Indigo theme from FlexColorScheme package',
    scheme: FlexScheme.indigo,
  ),
  AppSchemeInfo(
    name: 'Material Baseline',
    description: 'Material baseline theme',
    scheme: FlexScheme.materialBaseline,
  ),
  // Add more schemes
  AppSchemeInfo(
    name: 'Amber',
    description: 'Warm amber and orange theme',
    scheme: FlexScheme.amber,
  ),
  AppSchemeInfo(
    name: 'Vesuvius Burn',
    description: 'Deep orange and red theme',
    scheme: FlexScheme.vesuviusBurn,
  ),
  AppSchemeInfo(
    name: 'Green',
    description: 'Green and teal color theme',
    scheme: FlexScheme.green,
  ),
  AppSchemeInfo(
    name: 'Gold',
    description: 'Gold theme with yellow accents',
    scheme: FlexScheme.gold,
  ),
  AppSchemeInfo(
    name: 'Mango',
    description: 'Bright mango orange theme',
    scheme: FlexScheme.mango,
  ),
  AppSchemeInfo(
    name: 'Material High Contrast',
    description: 'High contrast theme',
    scheme: FlexScheme.materialHc,
  ),
  AppSchemeInfo(
    name: 'Espresso',
    description: 'Dark brown coffee theme',
    scheme: FlexScheme.espresso,
  ),
  AppSchemeInfo(
    name: 'Barossa',
    description: 'Rich purple wine theme',
    scheme: FlexScheme.barossa,
  ),
  AppSchemeInfo(
    name: 'Red Wine',
    description: 'Deep red wine theme',
    scheme: FlexScheme.red,
  ),
];

// Make the list publicly accessible
List<AppSchemeInfo> get appColorSchemes => _appColorSchemes;

// Simple state class to hold theme mode and selected scheme index
@immutable
class AppThemeState {
  final ThemeMode themeMode;
  final int selectedSchemeIndex;

  const AppThemeState({
    required this.themeMode,
    required this.selectedSchemeIndex,
  });

  AppThemeState copyWith({ThemeMode? themeMode, int? selectedSchemeIndex}) {
    return AppThemeState(
      themeMode: themeMode ?? this.themeMode,
      selectedSchemeIndex: selectedSchemeIndex ?? this.selectedSchemeIndex,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppThemeState &&
          runtimeType == other.runtimeType &&
          themeMode == other.themeMode &&
          selectedSchemeIndex == other.selectedSchemeIndex;

  @override
  int get hashCode => themeMode.hashCode ^ selectedSchemeIndex.hashCode;
}

@riverpod
class AppTheme extends _$AppTheme {
  @override
  AppThemeState build() {
    // Read the service via the provider
    final persistenceService = ref.read(themePersistenceServiceProvider);

    // Load initial state from persistence
    final initialMode = persistenceService.loadThemeMode();
    int initialSchemeIndex = persistenceService.loadSchemeIndex();
    if (initialSchemeIndex < 0 ||
        initialSchemeIndex >= _appColorSchemes.length) {
      initialSchemeIndex = 0;
    }

    return AppThemeState(
      themeMode: initialMode,
      selectedSchemeIndex: initialSchemeIndex,
    );
  }

  // Method to change the theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    // Read service provider here
    final persistenceService = ref.read(themePersistenceServiceProvider);
    // Update state only if the mode is different
    if (state.themeMode != mode) {
      state = state.copyWith(themeMode: mode);
      // Persist the new mode
      await persistenceService.saveThemeMode(mode);
    }
  }

  // Method to change the color scheme
  Future<void> setSchemeIndex(int index) async {
    // Read service provider here
    final persistenceService = ref.read(themePersistenceServiceProvider);
    // Validate index and check if it's different from current
    if (index >= 0 &&
        index < _appColorSchemes.length &&
        state.selectedSchemeIndex != index) {
      state = state.copyWith(selectedSchemeIndex: index);
      // Persist the new index
      await persistenceService.saveSchemeIndex(index);
    }
  }

  // Getter for the light theme data based on the current state
  ThemeData get lightTheme => FlexThemeData.light(
    // Use the scheme directly from our AppSchemeInfo list
    scheme: _appColorSchemes[state.selectedSchemeIndex].scheme,
    surfaceMode: FlexSurfaceMode.level,
    blendLevel: 9,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 10,
      blendOnColors: false,
      useTextTheme: true,
      useM2StyleDividerInM3: true,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
    swapLegacyOnMaterial3: true,
    // Add other theme customizations if needed
  );

  // Getter for the dark theme data based on the current state
  ThemeData get darkTheme => FlexThemeData.dark(
    // Use the scheme directly from our AppSchemeInfo list
    scheme: _appColorSchemes[state.selectedSchemeIndex].scheme,
    surfaceMode: FlexSurfaceMode.level,
    blendLevel: 15,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 20,
      useTextTheme: true,
      useM2StyleDividerInM3: true,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
    swapLegacyOnMaterial3: true,
    // Add other theme customizations if needed
  );
}
