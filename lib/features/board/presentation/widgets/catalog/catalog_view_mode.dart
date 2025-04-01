import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum CatalogViewMode { grid, media }

final catalogViewModeProvider =
    StateNotifierProvider<CatalogViewModeNotifier, CatalogViewMode>(
      (ref) => CatalogViewModeNotifier(),
    );

class CatalogViewModeNotifier extends StateNotifier<CatalogViewMode> {
  static const _key = 'catalog_view_mode';

  CatalogViewModeNotifier() : super(CatalogViewMode.grid) {
    _load();
  }

  void set(CatalogViewMode mode) {
    state = mode;
    _save(mode);
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt(_key);
    if (index != null && index < CatalogViewMode.values.length) {
      state = CatalogViewMode.values[index];
    }
  }

  Future<void> _save(CatalogViewMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, mode.index);
  }
}
