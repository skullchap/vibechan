import 'dart:convert'; // For jsonEncode/Decode

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'package:uuid/uuid.dart';

import '../models/content_tab.dart';

// Key for storing tabs in SharedPreferences
const String _tabsStorageKey = 'app_open_tabs';

// Provider for SharedPreferences instance
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((
  ref,
) async {
  return await SharedPreferences.getInstance();
});

/// Manages the list of open content tabs.
class TabManagerNotifier extends StateNotifier<List<ContentTab>> {
  // Accept nullable SharedPreferences
  TabManagerNotifier(this._prefs) : super([]) {
    // Load tabs only if prefs is available
    if (_prefs != null) {
      _loadTabs();
    }
  }

  final SharedPreferences? _prefs; // Make nullable
  final _uuid = const Uuid();

  /// Loads tabs from SharedPreferences.
  Future<void> _loadTabs() async {
    // Only load if prefs is available
    if (_prefs == null) return;

    final String? tabsJson = _prefs!.getString(_tabsStorageKey);
    if (tabsJson != null) {
      try {
        final List<dynamic> decodedList = jsonDecode(tabsJson) as List;
        final List<ContentTab> loadedTabs =
            decodedList
                .map(
                  (json) => ContentTab.fromJson(json as Map<String, dynamic>),
                )
                .toList();

        // Ensure at least one tab is active if tabs were loaded
        if (loadedTabs.isNotEmpty &&
            loadedTabs.where((t) => t.isActive).isEmpty) {
          // Find the *first* non-null tab to activate
          final firstValidTabIndex = loadedTabs.indexWhere((t) => t != null);
          if (firstValidTabIndex != -1) {
            loadedTabs[firstValidTabIndex] = loadedTabs[firstValidTabIndex]
                .copyWith(isActive: true);
          }
        }

        // Filter out any potential nulls from bad saves (though unlikely with freezed)
        state = loadedTabs.where((t) => t != null).toList();
      } catch (e) {
        print('Error loading/decoding tabs: $e');
        state = [];
        await _saveTabs(); // Clear potentially corrupted data
      }
    } else {
      state = [];
    }
  }

  /// Saves the current tab list to SharedPreferences.
  Future<void> _saveTabs() async {
    // Only save if prefs is available
    if (_prefs == null) return;

    try {
      final String tabsJson = jsonEncode(
        state.map((tab) => tab.toJson()).toList(),
      );
      await _prefs!.setString(_tabsStorageKey, tabsJson);
    } catch (e) {
      print('Error saving tabs: $e');
    }
  }

  @override
  set state(List<ContentTab> newState) {
    super.state = newState;
    _saveTabs(); // Save whenever state changes
  }

  /// Adds a new tab, making it active.
  void addTab({
    required String title,
    required String initialRouteName,
    Map<String, String> pathParameters = const {},
    IconData icon = Icons.web,
  }) {
    final List<ContentTab> deactivatedTabs =
        state.map((tab) => tab.copyWith(isActive: false)).toList();

    final newTab = ContentTab(
      id: _uuid.v4(),
      title: title,
      initialRouteName: initialRouteName,
      pathParameters: pathParameters,
      icon: icon,
      isActive: true,
    );

    super.state = [
      ...deactivatedTabs,
      newTab,
    ]; // Use super.state to avoid double save
    _saveTabs();
  }

  /// Sets the tab with the given [id] as active.
  void setActiveTab(String id) {
    final currentActiveIndex = state.indexWhere((tab) => tab.isActive);
    if (currentActiveIndex != -1 && state[currentActiveIndex].id == id) {
      return;
    }

    final newState =
        state.map((tab) {
          return tab.copyWith(isActive: tab.id == id);
        }).toList();
    super.state = newState;
    _saveTabs();
  }

  /// Removes the tab with the given [id].
  void removeTab(String id) {
    final index = state.indexWhere((tab) => tab.id == id);
    if (index == -1) return;

    final wasActive = state[index].isActive;
    final List<ContentTab> updatedTabs = List.from(state);
    updatedTabs.removeAt(index);

    if (wasActive && updatedTabs.isNotEmpty) {
      final newActiveIndex = (index > 0) ? index - 1 : 0;
      final safeIndex = newActiveIndex.clamp(0, updatedTabs.length - 1);
      // Ensure we don't modify the list while iterating if we mapped directly
      final List<ContentTab> finalTabs = [];
      for (int i = 0; i < updatedTabs.length; ++i) {
        finalTabs.add(updatedTabs[i].copyWith(isActive: i == safeIndex));
      }
      super.state = finalTabs;
    } else {
      super.state = updatedTabs;
    }
    _saveTabs();
  }

  /// Updates the currently active tab to show new content.
  void navigateToOrReplaceActiveTab({
    required String title,
    required String initialRouteName,
    Map<String, String> pathParameters = const {},
    IconData icon = Icons.web,
  }) {
    final activeIndex = state.indexWhere((tab) => tab.isActive);

    if (activeIndex != -1) {
      final activeTabId = state[activeIndex].id;
      final newState =
          state.map((tab) {
            if (tab.id == activeTabId) {
              return tab.copyWith(
                title: title,
                initialRouteName: initialRouteName,
                pathParameters: pathParameters,
                icon: icon,
                isActive: true,
              );
            }
            return tab.copyWith(isActive: false);
          }).toList();
      super.state = newState;
      _saveTabs();
    } else {
      addTab(
        title: title,
        initialRouteName: initialRouteName,
        pathParameters: pathParameters,
        icon: icon,
      ); // addTab already saves
    }
  }

  /// Reorders the tab list based on drag-and-drop interaction.
  void reorderTab(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final List<ContentTab> updatedTabs = List.from(state);
    final ContentTab item = updatedTabs.removeAt(oldIndex);
    updatedTabs.insert(newIndex, item);
    super.state = updatedTabs;
    _saveTabs();
  }

  /// Updates the properties of an existing tab (e.g., title or icon).
  void updateTabDetails(String id, {String? newTitle, IconData? newIcon}) {
    final newState =
        state.map((tab) {
          if (tab.id == id) {
            return tab.copyWith(
              title: newTitle ?? tab.title,
              icon: newIcon ?? tab.icon,
            );
          }
          return tab;
        }).toList();
    super.state = newState;
    _saveTabs();
  }

  /// Updates the title of the currently active tab.
  void updateActiveTabTitle(String newTitle) {
    final activeIndex = state.indexWhere((tab) => tab.isActive);
    if (activeIndex != -1) {
      final updatedTabs = List<ContentTab>.from(state);
      updatedTabs[activeIndex] = updatedTabs[activeIndex].copyWith(
        title: newTitle,
      );
      super.state = updatedTabs;
      _saveTabs();
    }
  }

  /// Gets the currently active tab, if any.
  ContentTab? get activeTab {
    try {
      return state.firstWhere((tab) => tab.isActive);
    } catch (e) {
      if (state.isNotEmpty) {
        return state.first;
      }
      return null;
    }
  }
}

/// Provider definition for the TabManagerNotifier.
final tabManagerProvider = StateNotifierProvider<
  TabManagerNotifier,
  List<ContentTab>
>((ref) {
  // Watch the FutureProvider for SharedPreferences
  final prefsAsyncValue = ref.watch(sharedPreferencesProvider);

  // Return the notifier, passing the SharedPreferences instance when available,
  // or null during loading/error states.
  return prefsAsyncValue.when(
    data: (prefs) => TabManagerNotifier(prefs),
    loading: () => TabManagerNotifier(null),
    error: (err, stack) {
      print("Error loading SharedPreferences: $err");
      // Optionally, return a notifier that signals an error state?
      return TabManagerNotifier(null);
    },
  );
});
