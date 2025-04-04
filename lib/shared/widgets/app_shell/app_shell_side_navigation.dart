import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

import '../../models/content_tab.dart';
import '../../providers/tab_manager_provider.dart';
import '../../providers/settings_provider.dart'; // Import for settings access

// Side navigation source selector builder (moved here)
Widget _buildSideSourceSelector(
  BuildContext context,
  WidgetRef ref,
  TabManagerNotifier tabNotifier,
) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  // Get settings state
  final settings = ref.watch(appSettingsProvider);
  final switchToExistingTab =
      ref.read(appSettingsProvider.notifier).switchToExistingTab;

  // Define available sources
  final List<Map<String, dynamic>> sources = [
    {'title': '4chan', 'routeName': 'boards', 'icon': Icons.dashboard},
    {
      'title': 'Hacker News',
      'routeName': 'hackernews',
      'icon': Icons.newspaper,
    },
    {'title': 'Lobsters', 'routeName': 'lobsters', 'icon': Icons.rss_feed},
    {'title': 'Favorites', 'routeName': 'favorites', 'icon': Icons.favorite},
    {'title': 'Settings', 'routeName': 'settings', 'icon': Icons.settings},
  ];

  return Card(
    elevation: 1,
    color: colorScheme.surfaceContainerLow,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(color: colorScheme.outlineVariant, width: 0.5),
    ),
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 8),
            child: Row(
              children: [
                Icon(
                  Icons.add_circle_outline,
                  color: colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'Add New Tab',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          Divider(color: colorScheme.outlineVariant, height: 16),
          ...sources.map(
            (source) => Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  final String newRouteName = source['routeName'] as String;
                  // Check setting and if a tab with the same routeName already exists
                  ContentTab? existingTab;
                  if (settings.value != null && switchToExistingTab) {
                    final tabs = ref.read(
                      tabManagerProvider,
                    ); // Read current tabs
                    existingTab = tabs.firstWhereOrNull(
                      (tab) => tab.initialRouteName == newRouteName,
                    );
                  }

                  if (existingTab != null) {
                    // Switch to existing tab
                    tabNotifier.setActiveTab(existingTab.id);
                  } else {
                    // Add a *new* tab for the selected source
                    tabNotifier.addTab(
                      title: source['title'] as String,
                      initialRouteName: newRouteName,
                      icon: source['icon'] ?? Icons.web,
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 10.0,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        source['icon'] as IconData?,
                        size: 20,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        source['title'] as String,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class AppShellSideNavigation extends ConsumerWidget {
  final List<ContentTab> tabs;
  final ContentTab? activeTab;
  final TabManagerNotifier tabNotifier;

  const AppShellSideNavigation({
    super.key,
    required this.tabs,
    required this.activeTab,
    required this.tabNotifier,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          const SizedBox(height: 8),
          // Source selector at the top
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: _buildSideSourceSelector(context, ref, tabNotifier),
          ),
          const Divider(),
          // Tab list
          Expanded(
            child: ReorderableListView.builder(
              itemCount: tabs.length,
              buildDefaultDragHandles: false,
              itemBuilder: (context, index) {
                final tab = tabs[index];
                final isActive = tab.id == activeTab?.id;

                return ReorderableDragStartListener(
                  key: ValueKey(tab.id),
                  index: index,
                  child: Material(
                    color: Colors.transparent,
                    child: ListTile(
                      leading: Icon(
                        tab.icon,
                        color:
                            isActive
                                ? Theme.of(context).colorScheme.primary
                                : null,
                      ),
                      title: Text(
                        tab.title,
                        style:
                            isActive
                                ? TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                )
                                : null,
                        overflow: TextOverflow.ellipsis,
                      ),
                      selected: isActive,
                      selectedTileColor: Theme.of(
                        context,
                      ).colorScheme.primaryContainer.withOpacity(0.2),
                      onTap: () => tabNotifier.setActiveTab(tab.id),
                      trailing: IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        tooltip: 'Close tab',
                        onPressed: () => tabNotifier.removeTab(tab.id),
                      ),
                    ),
                  ),
                );
              },
              onReorder: (oldIndex, newIndex) {
                tabNotifier.reorderTab(oldIndex, newIndex);
              },
            ),
          ),
        ],
      ),
    );
  }
}
