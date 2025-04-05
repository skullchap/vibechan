import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:vibechan/app/app_routes.dart'; // Import AppRoute
import 'package:get_it/get_it.dart'; // Import GetIt
import 'package:logger/logger.dart'; // Import Logger

import '../../models/content_tab.dart';
import '../../providers/tab_manager_provider.dart';
import '../../providers/settings_provider.dart'; // Import for settings access

// MOVED from app_shell_app_bar.dart and made public
// Helper function to determine the general category (route name) of a tab using AppRoute
String getRouteNameFromTab(ContentTab? tab) {
  if (tab == null) return AppRoute.boardList.name; // Default to boards

  final routeName = tab.initialRouteName;

  // Map specific 4chan routes to the base 'boards' route name for the selector
  if (routeName == AppRoute.boardList.name ||
      routeName == AppRoute.boardCatalog.name ||
      routeName == AppRoute.thread.name) {
    return AppRoute.boardList.name;
  }
  // Map specific HN routes to the base 'hackernews' route name
  if (routeName == AppRoute.hackernews.name ||
      routeName == AppRoute.hackernewsItem.name) {
    return AppRoute.hackernews.name;
  }
  // Map specific Lobsters routes to the base 'lobsters' route name
  if (routeName == AppRoute.lobsters.name ||
      routeName == AppRoute.lobstersStory.name) {
    return AppRoute.lobsters.name;
  }
  // Map specific Reddit routes to the base 'subredditGrid' route name
  if (routeName == AppRoute.subredditGrid.name ||
      routeName == AppRoute.subreddit.name ||
      routeName == AppRoute.postDetail.name) {
    return AppRoute.subredditGrid.name;
  }
  // Handle other top-level routes directly
  if (routeName == AppRoute.favorites.name) {
    return AppRoute.favorites.name;
  }
  if (routeName == AppRoute.settings.name) {
    return AppRoute.settings.name;
  }

  // Fallback for any unhandled or potentially new routes
  final logger = GetIt.instance<Logger>(instanceName: "AppLogger");
  logger.w(
    "Warning: Unknown initialRouteName '$routeName' in getRouteNameFromTab, defaulting to boards",
  );
  return AppRoute.boardList.name; // Fallback
}

// Side navigation source selector builder (updated to use AppRoute)
Widget _buildSideSourceSelector(
  BuildContext context,
  WidgetRef ref,
  TabManagerNotifier tabNotifier,
) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  final settings = ref.watch(appSettingsProvider);
  final switchToExistingTab =
      ref.read(appSettingsProvider.notifier).switchToExistingTab;

  // Define available sources using AppRoute enums (consistent with AppBar)
  final List<Map<String, dynamic>> sources = [
    {
      'title': '4chan',
      'routeName': AppRoute.boardList.name,
      'icon': Icons.dashboard_outlined,
    },
    {
      'title': 'Hacker News',
      'routeName': AppRoute.hackernews.name,
      'icon': Icons.newspaper_outlined,
    },
    {
      'title': 'Lobsters',
      'routeName': AppRoute.lobsters.name,
      'icon': Icons.rss_feed,
    },
    {
      'title': 'Reddit',
      'routeName': AppRoute.subredditGrid.name, // Entry point for Reddit
      'icon': Icons.reddit_outlined,
    },
    {
      'title': 'Favorites',
      'routeName': AppRoute.favorites.name,
      'icon': Icons.favorite_outline,
    },
    {
      'title': 'Settings',
      'routeName': AppRoute.settings.name,
      'icon': Icons.settings_outlined,
    },
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
                  // Check setting and if a tab with the same base routeName already exists
                  ContentTab? existingTab;
                  if (settings.value != null && switchToExistingTab) {
                    final tabs = ref.read(tabManagerProvider);
                    // Use the helper function now defined in this file
                    existingTab = tabs.firstWhereOrNull(
                      (tab) => getRouteNameFromTab(tab) == newRouteName,
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
