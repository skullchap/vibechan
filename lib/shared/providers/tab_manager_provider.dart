import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../models/tab_item.dart';

/// Tab manager provider that handles the state of tabs
class TabManagerNotifier extends StateNotifier<List<TabItem>> {
  TabManagerNotifier() : super([]);
  
  final _uuid = const Uuid();
  
  void addTab({
    required String title,
    required String route,
    Map<String, String> pathParameters = const {},
    IconData icon = Icons.web,
    bool setActive = true,
  }) {
    final newTab = TabItem(
      id: _uuid.v4(),
      title: title,
      route: route,
      pathParameters: pathParameters,
      icon: icon,
      isActive: false,
    );
    
    if (setActive) {
      final updatedTabs = state.map((tab) => tab.copyWith(isActive: false)).toList();
      updatedTabs.add(newTab.copyWith(isActive: true));
      state = updatedTabs;
    } else {
      state = [...state, newTab];
    }
  }
  
  void setActiveTab(String id) {
    state = state.map((tab) => tab.copyWith(isActive: tab.id == id)).toList();
  }
  
  void removeTab(String id) {
    final index = state.indexWhere((tab) => tab.id == id);
    if (index == -1) return;
    
    final newTabs = [...state];
    newTabs.removeAt(index);
    
    // If we removed the active tab, set the last tab as active
    if (state[index].isActive && newTabs.isNotEmpty) {
      final newActiveIndex = index == newTabs.length ? index - 1 : index;
      newTabs[newActiveIndex] = newTabs[newActiveIndex].copyWith(isActive: true);
    }
    
    state = newTabs;
  }
  
  void updateTabRoute(String id, String route, Map<String, String> pathParameters, {String? newTitle, IconData? newIcon}) {
    final index = state.indexWhere((tab) => tab.id == id);
    if (index == -1) return;
    
    final updatedTabs = [...state];
    updatedTabs[index] = state[index].copyWith(
      route: route,
      pathParameters: pathParameters,
      title: newTitle ?? state[index].title,
      icon: newIcon ?? state[index].icon,
    );
    
    state = updatedTabs;
  }
  
  TabItem? get activeTab => state.isEmpty ? null : state.firstWhere(
    (tab) => tab.isActive, 
    orElse: () => state.first.copyWith(isActive: true)
  );
}

final tabManagerProvider = StateNotifierProvider<TabManagerNotifier, List<TabItem>>((ref) {
  return TabManagerNotifier();
});