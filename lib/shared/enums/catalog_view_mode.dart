import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

/// Defines the different layout modes for a catalog view.
enum CatalogViewMode {
  /// Displays items in a grid.
  grid,

  /// Displays items as a feed emphasizing media.
  media,
}

// Add extension for display name
extension CatalogViewModeExtension on CatalogViewMode {
  String get displayName {
    switch (this) {
      case CatalogViewMode.grid:
        return 'Grid View';
      case CatalogViewMode.media:
        return 'Media Feed';
    }
  }

  IconData get icon {
    switch (this) {
      case CatalogViewMode.grid:
        return Icons.grid_view;
      case CatalogViewMode.media:
        return Icons.photo_library_outlined;
    }
  }
}

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
