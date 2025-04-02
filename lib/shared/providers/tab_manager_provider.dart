import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../models/content_tab.dart';

/// Manages the list of open content tabs.
class TabManagerNotifier extends StateNotifier<List<ContentTab>> {
  TabManagerNotifier() : super([]) {
    // Initialize with a default tab if desired
    // addTab(title: 'Boards', initialRouteName: 'boards', icon: Icons.dashboard);
  }

  final _uuid = const Uuid();

  /// Adds a new tab, making it active.
  void addTab({
    required String title,
    required String initialRouteName,
    Map<String, String> pathParameters = const {},
    IconData icon = Icons.web,
  }) {
    // Deactivate current active tab
    final List<ContentTab> deactivatedTabs =
        state.map((tab) => tab.copyWith(isActive: false)).toList();

    final newTab = ContentTab(
      id: _uuid.v4(),
      title: title,
      initialRouteName: initialRouteName,
      pathParameters: pathParameters,
      icon: icon,
      isActive: true, // Make the new tab active
    );

    state = [...deactivatedTabs, newTab];
  }

  /// Sets the tab with the given [id] as active.
  void setActiveTab(String id) {
    // Avoid redundant state updates if already active
    final currentActiveIndex = state.indexWhere((tab) => tab.isActive);
    if (currentActiveIndex != -1 && state[currentActiveIndex].id == id) {
      return;
    }

    state =
        state.map((tab) {
          return tab.copyWith(isActive: tab.id == id);
        }).toList();
  }

  /// Removes the tab with the given [id].
  /// If the removed tab was active, activates the previous tab or the first one.
  void removeTab(String id) {
    final index = state.indexWhere((tab) => tab.id == id);
    if (index == -1) return; // Tab not found

    final wasActive = state[index].isActive;
    final List<ContentTab> updatedTabs = List.from(state);
    updatedTabs.removeAt(index);

    // If we removed the active tab and there are still tabs left,
    // activate the one before it, or the new first one if it was the first.
    if (wasActive && updatedTabs.isNotEmpty) {
      final newActiveIndex = (index > 0) ? index - 1 : 0;
      // Ensure the index is valid for the reduced list
      final safeIndex = newActiveIndex.clamp(0, updatedTabs.length - 1);
      updatedTabs[safeIndex] = updatedTabs[safeIndex].copyWith(isActive: true);
    }

    state = updatedTabs;
  }

  /// Updates the currently active tab to show new content.
  /// If no tab is active or available, it adds a new one instead.
  void navigateToOrReplaceActiveTab({
    required String title,
    required String initialRouteName,
    Map<String, String> pathParameters = const {},
    IconData icon = Icons.web,
  }) {
    final activeIndex = state.indexWhere((tab) => tab.isActive);

    if (activeIndex != -1) {
      // Active tab found, update it
      final activeTabId = state[activeIndex].id;
      state =
          state.map((tab) {
            if (tab.id == activeTabId) {
              return tab.copyWith(
                title: title,
                initialRouteName: initialRouteName,
                pathParameters: pathParameters,
                icon: icon,
                isActive: true, // Ensure it remains active
              );
            }
            // This ensures only the target tab is active after the update
            return tab.copyWith(isActive: false);
          }).toList();
    } else {
      // No active tab (or no tabs at all?), fall back to adding a new one
      // This automatically makes the new tab active
      addTab(
        title: title,
        initialRouteName: initialRouteName,
        pathParameters: pathParameters,
        icon: icon,
      );
    }
  }

  /// Reorders the tab list based on drag-and-drop interaction.
  void reorderTab(int oldIndex, int newIndex) {
    // Handle index adjustment if item is moved downwards
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    // Perform reordering
    final List<ContentTab> updatedTabs = List.from(state);
    final ContentTab item = updatedTabs.removeAt(oldIndex);
    updatedTabs.insert(newIndex, item);

    state = updatedTabs;
  }

  /// Updates the properties of an existing tab (e.g., title or icon).
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
      // Find the first tab marked as active
      return state.firstWhere((tab) => tab.isActive);
    } catch (e) {
      // If no tab is explicitly active, default to the first tab if the list isn't empty
      if (state.isNotEmpty) {
        // Important: Don't modify state here, just return the first one.
        // If no tab should be active, the UI should handle the null case.
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
