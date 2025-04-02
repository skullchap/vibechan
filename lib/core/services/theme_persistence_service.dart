import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@singleton
class ThemePersistenceService {
  final SharedPreferences _prefs;

  static const String _themeModeKey = 'theme_mode';
  static const String _schemeIndexKey = 'theme_scheme_index';

  ThemePersistenceService(this._prefs);

  Future<void> saveThemeMode(ThemeMode mode) async {
    await _prefs.setString(_themeModeKey, mode.name);
  }

  ThemeMode loadThemeMode() {
    final modeString = _prefs.getString(_themeModeKey);
    return ThemeMode.values.firstWhere(
      (e) => e.name == modeString,
      orElse: () => ThemeMode.system, // Default to system
    );
  }

  Future<void> saveSchemeIndex(int index) async {
    await _prefs.setInt(_schemeIndexKey, index);
  }

  int loadSchemeIndex() {
    return _prefs.getInt(_schemeIndexKey) ?? 0; // Default to index 0
  }
}
