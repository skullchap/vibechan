import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_provider.g.dart';

// Key for storing the setting in SharedPreferences
const String _switchToExistingTabKey = 'switchToExistingTabOnSourceSelect';

@riverpod
class AppSettings extends _$AppSettings {
  late SharedPreferences _prefs;

  @override
  Future<Map<String, bool>> build() async {
    _prefs = await SharedPreferences.getInstance();
    return {
      _switchToExistingTabKey: _prefs.getBool(_switchToExistingTabKey) ?? false,
      // Add other boolean settings here if needed
    };
  }

  Future<void> setSwitchToExistingTab(bool value) async {
    await _prefs.setBool(_switchToExistingTabKey, value);
    state = AsyncData({
      ...state.value!, // Keep existing settings
      _switchToExistingTabKey: value,
    });
  }

  // Helper getter for easier access in UI
  bool get switchToExistingTab =>
      state.value?[_switchToExistingTabKey] ?? false;
}
