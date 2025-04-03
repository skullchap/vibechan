import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/layout_service.dart';
import '../../models/content_tab.dart';
import '../../providers/tab_manager_provider.dart';

// Provider to maintain consistency in the selector display style
final selectorStyleProvider = StateProvider<bool>((ref) => false);

/// Builds a source selector widget for the app bar
Widget buildSourceSelector(
  BuildContext context,
  WidgetRef ref,
  ContentTab? activeTab,
  TabManagerNotifier tabNotifier, {
  bool isDesktop = false,
}) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  final windowWidth = MediaQuery.of(context).size.width;
  final useCompactLayout = windowWidth < 600;

  String currentSourceName = 'Select Source';
  IconData currentIcon = Icons.menu;

  // Define available sources including Settings
  final List<Map<String, dynamic>> sources = [
    {'title': '4chan Boards', 'routeName': 'boards', 'icon': Icons.grid_view},
    {
      'title': 'Hacker News',
      'routeName': 'hackernews',
      'icon': Icons.trending_up,
    },
    {
      'title': 'Lobsters',
      'routeName': 'lobsters',
      'icon': Icons.adjust_rounded,
    },
    {'title': 'Favorites', 'routeName': 'favorites', 'icon': Icons.favorite},
    {'title': 'Settings', 'routeName': 'settings', 'icon': Icons.settings},
  ];

  final String currentCategory = _getCategoryFromTab(activeTab);
  final currentSource = sources.firstWhere(
    (s) => s['routeName'] == currentCategory,
    orElse: () => sources.first, // Default to first item if not found
  );

  currentSourceName =
      useCompactLayout && currentCategory == 'hackernews'
          ? 'HN'
          : currentSource['title'];
  currentIcon = currentSource['icon'];

  // Create a Material 3 style container design for larger screens
  final selectorWidget =
      isDesktop
          ? Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: colorScheme.surfaceContainerLow,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            child: _buildPopupButton(
              context,
              currentSourceName,
              currentIcon,
              activeTab,
              tabNotifier,
              colorScheme,
              theme,
              sources,
              currentCategory,
            ),
          )
          // On mobile, just use the popup button directly
          : _buildPopupButton(
            context,
            currentSourceName,
            currentIcon,
            activeTab,
            tabNotifier,
            colorScheme,
            theme,
            sources,
            currentCategory,
          );

  return selectorWidget;
}

// Helper to build the popup button content
Widget _buildPopupButton(
  BuildContext context,
  String currentSourceName,
  IconData currentIcon,
  ContentTab? activeTab,
  TabManagerNotifier tabNotifier,
  ColorScheme colorScheme,
  ThemeData theme,
  List<Map<String, dynamic>> sources,
  String currentCategory,
) {
  final windowWidth = MediaQuery.of(context).size.width;
  final isCompact = windowWidth < 360;

  return PopupMenuButton<String>(
    offset: const Offset(0, 40),
    tooltip: 'Select source',
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    position: PopupMenuPosition.under,
    elevation: 3,
    color: colorScheme.surfaceContainerHigh,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(currentIcon, size: 24, color: colorScheme.onSurface),
        if (!isCompact) ...[
          const SizedBox(width: 10),
          Text(
            currentSourceName,
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
        ],
        const SizedBox(width: 4),
        Icon(Icons.arrow_drop_down, color: colorScheme.onSurface),
      ],
    ),
    itemBuilder:
        (context) =>
            sources.map((source) {
              final routeName = source['routeName'] as String;
              final title = source['title'] as String;
              final icon = source['icon'] as IconData?;
              final isSelected = routeName == currentCategory;

              return _buildPopupMenuItem(
                context,
                routeName,
                title,
                icon ?? Icons.web,
                isSelected,
              );
            }).toList(),
    onSelected: (value) {
      switch (value) {
        case 'boards':
          _openBoardsTab(tabNotifier);
          break;
        case 'favorites':
          _openFavoritesTab(tabNotifier);
          break;
        case 'hackernews':
          _openHackerNewsTab(tabNotifier);
          break;
        case 'lobsters':
          _openLobstersTab(tabNotifier);
          break;
        case 'settings':
          _openSettingsTab(tabNotifier);
          break;
      }
    },
  );
}

// Helper method to build a popup menu item with Material 3 styling
PopupMenuItem<String> _buildPopupMenuItem(
  BuildContext context,
  String value,
  String label,
  IconData icon,
  bool isSelected,
) {
  final colorScheme = Theme.of(context).colorScheme;

  return PopupMenuItem<String>(
    value: value,
    child: Row(
      children: [
        Icon(
          icon,
          size: 20,
          color:
              isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color:
                isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    ),
  );
}

/// Helper function to determine the current category
String _getCategoryFromTab(ContentTab? tab) {
  if (tab == null) return 'boards'; // Default if no tab active
  switch (tab.initialRouteName) {
    case 'boards':
    case 'catalog':
    case 'thread':
      return 'boards';
    case 'hackernews':
    case 'hackernews_item':
      return 'hackernews';
    case 'lobsters':
    case 'lobsters_story':
      return 'lobsters';
    case 'favorites':
      return 'favorites';
    case 'settings':
      return 'settings';
    default:
      return 'boards'; // Fallback category
  }
}

/// Builds a more complete source selector for the side navigation drawer
Widget buildSideSourceSelector(
  BuildContext context,
  WidgetRef ref,
  TabManagerNotifier tabNotifier,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Sources', style: Theme.of(context).textTheme.titleSmall),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          // 4chan button with more details
          ActionChip(
            avatar: const Icon(Icons.grid_view, size: 18),
            label: const Text('4chan'),
            onPressed: () => _openBoardsTab(tabNotifier),
          ),

          // Favorites button
          ActionChip(
            avatar: const Icon(Icons.favorite, size: 18),
            label: const Text('Favorites'),
            onPressed: () => _openFavoritesTab(tabNotifier),
          ),

          // Hacker News button
          ActionChip(
            avatar: const Icon(Icons.trending_up, size: 18),
            label: const Text('Hacker News'),
            onPressed: () => _openHackerNewsTab(tabNotifier),
          ),

          // Lobsters button
          ActionChip(
            avatar: const Icon(Icons.adjust_rounded, size: 18),
            label: const Text('Lobsters'),
            onPressed: () => _openLobstersTab(tabNotifier),
          ),
        ],
      ),
      const Divider(height: 24),
      // Settings Button
      ActionChip(
        avatar: const Icon(Icons.settings, size: 18),
        label: const Text('Settings'),
        onPressed: () => _openSettingsTab(tabNotifier),
      ),
    ],
  );
}

// Helper functions for opening tabs

void _openBoardsTab(TabManagerNotifier tabNotifier) {
  tabNotifier.navigateToOrReplaceActiveTab(
    title: '4chan Boards',
    initialRouteName: 'boards',
    icon: Icons.grid_view,
  );
}

void _openFavoritesTab(TabManagerNotifier tabNotifier) {
  tabNotifier.navigateToOrReplaceActiveTab(
    title: 'Favorites',
    initialRouteName: 'favorites',
    icon: Icons.favorite,
  );
}

void _openHackerNewsTab(TabManagerNotifier tabNotifier) {
  tabNotifier.navigateToOrReplaceActiveTab(
    title: 'Hacker News',
    initialRouteName: 'hackernews',
    icon: Icons.trending_up,
  );
}

void _openLobstersTab(TabManagerNotifier tabNotifier) {
  tabNotifier.navigateToOrReplaceActiveTab(
    title: 'Lobsters',
    initialRouteName: 'lobsters',
    icon: Icons.adjust_rounded,
  );
}

void _openSettingsTab(TabManagerNotifier tabNotifier) {
  tabNotifier.navigateToOrReplaceActiveTab(
    title: 'Settings',
    initialRouteName: 'settings',
    icon: Icons.settings,
  );
}
