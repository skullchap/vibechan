import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../models/content_tab.dart';

/// Manages the list of open content tabs.
class TabManagerNotifier extends StateNotifier<List<ContentTab>> {
  TabManagerNotifier() : super([]) {
    // Initialize with a default tab if desired, e.g., Boards list
    // addTab(title: 'Boards', initialRouteName: 'boards');
  }

  final _uuid = const Uuid();

  /// Adds a new tab, making it active.
  void addTab({
    required String title,
    required String initialRouteName,
    Map<String, String> pathParameters = const {},
    IconData icon = Icons.web,
  }) {
    final newTab = ContentTab(
      id: _uuid.v4(),
      title: title,
      initialRouteName: initialRouteName,
      pathParameters: pathParameters,
      icon: icon,
      isActive: true, // Make the new tab active
    );

    // Deactivate current active tab
    final updatedTabs =
        state.map((tab) => tab.copyWith(isActive: false)).toList();

    updatedTabs.add(newTab);
    state = updatedTabs;
  }

  /// Sets the tab with the given [id] as active.
  void setActiveTab(String id) {
    // Check if the tab is already active
    final currentActive = state.firstWhere(
      (tab) => tab.isActive,
      orElse: () => state.first,
    );
    if (currentActive.id == id) return; // Already active, do nothing

    state =
        state.map((tab) {
          return tab.copyWith(isActive: tab.id == id);
        }).toList();
  }

  /// Removes the tab with the given [id].
  /// If the removed tab was active, activates the previous tab.
  void removeTab(String id) {
    final index = state.indexWhere((tab) => tab.id == id);
    if (index == -1) return; // Tab not found

    final wasActive = state[index].isActive;
    final newTabs = [...state];
    newTabs.removeAt(index);

    // If we removed the active tab and there are still tabs left,
    // activate the one before it, or the new first one.
    if (wasActive && newTabs.isNotEmpty) {
      final newActiveIndex = (index > 0) ? index - 1 : 0;
      newTabs[newActiveIndex] = newTabs[newActiveIndex].copyWith(
        isActive: true,
      );
    }

    state = newTabs;
  }

  /// Updates the properties of an existing tab (e.g., title or icon).
  /// Does NOT handle route changes within a tab - that's for the tab content view.
  void updateTabDetails(String id, {String? newTitle, IconData? newIcon}) {
    state =
        state.map((tab) {
          if (tab.id == id) {
            return tab.copyWith(
              title: newTitle ?? tab.title,
              icon: newIcon ?? tab.icon,
            );
          }
          return tab;
        }).toList();
  }

  /// Gets the currently active tab, if any.
  ContentTab? get activeTab {
    try {
      return state.firstWhere((tab) => tab.isActive);
    } catch (e) {
      // If no tab is explicitly active (e.g., after removing the last one was active),
      // try returning the first one. This might need refinement based on desired behavior.
      if (state.isNotEmpty) {
        // To avoid infinite loops if state update fails, return first without modifying state here
        return state.first;
      }
      return null; // No tabs left
    }
  }
}

/// Provider definition for the TabManagerNotifier.
final tabManagerProvider =
    StateNotifierProvider<TabManagerNotifier, List<ContentTab>>((ref) {
      return TabManagerNotifier();
    });
