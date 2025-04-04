import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

import '../../models/content_tab.dart';
import '../../providers/tab_manager_provider.dart';
import '../../providers/settings_provider.dart'; // Import for settings access in source selector
// import '../../../features/board/presentation/widgets/catalog/catalog_view_mode.dart'; // Old path
import 'package:vibechan/shared/enums/catalog_view_mode.dart'; // New package path
import '../../../features/hackernews/presentation/providers/hackernews_stories_provider.dart'; // Needed for HN sort type

// Helper function to determine the general category of a tab (moved here)
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

// Source selector dropdown builder (moved here)
Widget _buildSourceSelector(
  BuildContext context,
  WidgetRef ref,
  ContentTab? activeTab,
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

  final String currentCategory = _getCategoryFromTab(activeTab);

  // Find the current source
  final currentSource = sources.firstWhere(
    (s) => s['routeName'] == currentCategory,
    orElse: () => sources.first,
  );

  // Build a Material 3 styled dropdown
  return PopupMenuButton<String>(
    tooltip: 'Select source',
    position: PopupMenuPosition.under,
    offset: const Offset(0, 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 3,
    color: colorScheme.surfaceContainer,
    // Show the current selection as a child
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            currentSource['icon'] as IconData?,
            color: colorScheme.onSurface,
            size: 22,
          ),
          const SizedBox(width: 8),
          Text(
            currentSource['title'] as String,
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          Icon(Icons.arrow_drop_down, color: colorScheme.onSurface, size: 24),
        ],
      ),
    ),
    // Menu items
    itemBuilder:
        (context) =>
            sources.map((source) {
              final isSelected = source['routeName'] == currentCategory;
              return PopupMenuItem<String>(
                value: source['routeName'] as String,
                padding: EdgeInsets.zero, // Remove outer padding
                height: 56, // Standard height for menu items
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? colorScheme.primaryContainer
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          source['icon'] as IconData?,
                          size: 20,
                          color:
                              isSelected
                                  ? colorScheme.onPrimaryContainer
                                  : colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            source['title'] as String,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight:
                                  isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                              color:
                                  isSelected
                                      ? colorScheme.onPrimaryContainer
                                      : colorScheme.onSurface,
                            ),
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle_outline,
                            size: 18,
                            color: colorScheme.onPrimaryContainer,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
    onSelected: (String? newRouteName) {
      if (newRouteName != null) {
        final selectedSource = sources.firstWhere(
          (s) => s['routeName'] == newRouteName,
        );

        // Check setting and if a tab with the same routeName already exists
        ContentTab? existingTab;
        if (settings.value != null && switchToExistingTab) {
          final tabs = ref.read(tabManagerProvider); // Read current tabs
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
            title: selectedSource['title'] as String,
            initialRouteName: selectedSource['routeName'] as String,
            icon: selectedSource['icon'] ?? Icons.web,
          );
        }
      }
    },
  );
}

class AppShellAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final ContentTab? activeTab;
  final TabManagerNotifier tabNotifier;
  final bool isSearchVisible;
  final String searchQuery;
  final bool showBackButton;
  final VoidCallback onSearchToggle;
  final Function(String) onSearchChanged;
  final VoidCallback onSearchClear;
  final VoidCallback onBackButtonPressed;
  final Function(CatalogViewMode) onCatalogViewModeSelected;
  final Function(HackerNewsSortType) onHnSortTypeSelected;
  final VoidCallback? onOpenInBrowserPressed;

  const AppShellAppBar({
    super.key,
    required this.activeTab,
    required this.tabNotifier,
    required this.isSearchVisible,
    required this.searchQuery,
    required this.showBackButton,
    required this.onSearchToggle,
    required this.onSearchChanged,
    required this.onSearchClear,
    required this.onBackButtonPressed,
    required this.onCatalogViewModeSelected,
    required this.onHnSortTypeSelected,
    this.onOpenInBrowserPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentHnSortType = ref.watch(currentHackerNewsSortTypeProvider);

    // Handle search UI logic in AppBar
    Widget appBarTitle;
    if (isSearchVisible) {
      // Show search field when search is visible
      appBarTitle = Container(
        height: 40,
        margin: const EdgeInsets.only(right: 8),
        child: TextField(
          autofocus: true,
          controller: TextEditingController(text: searchQuery)
            ..selection = TextSelection.fromPosition(
              TextPosition(offset: searchQuery.length),
            ),
          decoration: InputDecoration(
            hintText: 'Search content...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withOpacity(0.5),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 16,
            ),
            prefixIcon: const Icon(Icons.search, size: 20),
            suffixIcon:
                searchQuery.isNotEmpty
                    ? IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      onPressed: onSearchClear,
                    )
                    : null,
          ),
          onChanged: onSearchChanged,
        ),
      );
    } else {
      // Use the source selector in the title position
      appBarTitle = _buildSourceSelector(context, ref, activeTab, tabNotifier);
    }

    // Create app bar actions
    final List<Widget> appBarActions = [
      // Open in browser button (shown when viewing threads)
      if (!isSearchVisible &&
          (activeTab?.initialRouteName == 'thread' ||
              activeTab?.initialRouteName == 'hackernews_item' ||
              activeTab?.initialRouteName == 'lobsters_story') &&
          onOpenInBrowserPressed != null)
        IconButton(
          icon: const Icon(Icons.open_in_browser, size: 24),
          tooltip: 'Open in browser',
          onPressed: onOpenInBrowserPressed,
        ),

      // Search button (shown on all screens)
      IconButton(
        icon: Icon(isSearchVisible ? Icons.close : Icons.search, size: 24),
        tooltip: isSearchVisible ? 'Close search' : 'Search content',
        onPressed: onSearchToggle,
      ),

      // Layout mode toggle (conditional)
      if (!isSearchVisible &&
          (activeTab?.initialRouteName == 'catalog' ||
              activeTab?.initialRouteName == 'boards'))
        Consumer(
          builder: (context, ref, _) {
            final mode = ref.watch(catalogViewModeProvider);
            final theme = Theme.of(context);
            final colorScheme = theme.colorScheme;

            return PopupMenuButton<CatalogViewMode>(
              tooltip: 'Layout mode',
              position: PopupMenuPosition.under,
              offset: const Offset(0, 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              color: colorScheme.surfaceContainer,
              initialValue: mode,
              onSelected: onCatalogViewModeSelected,
              // Show current layout icon
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      mode == CatalogViewMode.grid
                          ? Icons.grid_view
                          : Icons.photo_library,
                      color: colorScheme.onSurface,
                      size: 22,
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_drop_down,
                      color: colorScheme.onSurface,
                      size: 24,
                    ),
                  ],
                ),
              ),
              // Menu items
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    value: CatalogViewMode.grid,
                    padding: EdgeInsets.zero,
                    height: 56,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color:
                              mode == CatalogViewMode.grid
                                  ? colorScheme.primaryContainer
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.grid_view,
                              size: 20,
                              color:
                                  mode == CatalogViewMode.grid
                                      ? colorScheme.onPrimaryContainer
                                      : colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                'Grid View',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight:
                                      mode == CatalogViewMode.grid
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                  color:
                                      mode == CatalogViewMode.grid
                                          ? colorScheme.onPrimaryContainer
                                          : colorScheme.onSurface,
                                ),
                              ),
                            ),
                            if (mode == CatalogViewMode.grid)
                              Icon(
                                Icons.check_circle_outline,
                                size: 18,
                                color: colorScheme.onPrimaryContainer,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    value: CatalogViewMode.media,
                    padding: EdgeInsets.zero,
                    height: 56,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color:
                              mode == CatalogViewMode.media
                                  ? colorScheme.primaryContainer
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.photo_library,
                              size: 20,
                              color:
                                  mode == CatalogViewMode.media
                                      ? colorScheme.onPrimaryContainer
                                      : colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                'Media Feed',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight:
                                      mode == CatalogViewMode.media
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                  color:
                                      mode == CatalogViewMode.media
                                          ? colorScheme.onPrimaryContainer
                                          : colorScheme.onSurface,
                                ),
                              ),
                            ),
                            if (mode == CatalogViewMode.media)
                              Icon(
                                Icons.check_circle_outline,
                                size: 18,
                                color: colorScheme.onPrimaryContainer,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ];
              },
            );
          },
        ),
      // HN Sort Dropdown (conditionally shown)
      if (activeTab?.initialRouteName == 'hackernews')
        Builder(
          builder: (context) {
            final theme = Theme.of(context);
            final colorScheme = theme.colorScheme;

            return PopupMenuButton<HackerNewsSortType>(
              tooltip: 'Sort stories',
              position: PopupMenuPosition.under,
              offset: const Offset(0, 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              color: colorScheme.surfaceContainer,
              // Menu items
              itemBuilder:
                  (context) =>
                      HackerNewsSortType.values.map((sortType) {
                        final isSelected = sortType == currentHnSortType;
                        final sortName =
                            sortType.name[0].toUpperCase() +
                            sortType.name.substring(1);

                        return PopupMenuItem<HackerNewsSortType>(
                          value: sortType,
                          padding: EdgeInsets.zero,
                          height: 56,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? colorScheme.primaryContainer
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      sortName,
                                      style: theme.textTheme.bodyLarge
                                          ?.copyWith(
                                            fontWeight:
                                                isSelected
                                                    ? FontWeight.w600
                                                    : FontWeight.normal,
                                            color:
                                                isSelected
                                                    ? colorScheme
                                                        .onPrimaryContainer
                                                    : colorScheme.onSurface,
                                          ),
                                    ),
                                  ),
                                  if (isSelected)
                                    Icon(
                                      Icons.check_circle_outline,
                                      size: 18,
                                      color: colorScheme.onPrimaryContainer,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
              onSelected: onHnSortTypeSelected,
              // Show current sort type
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.sort, color: colorScheme.onSurface, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      currentHnSortType.name[0].toUpperCase() +
                          currentHnSortType.name.substring(1),
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_drop_down,
                      color: colorScheme.onSurface,
                      size: 24,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
    ];

    return AppBar(
      title: appBarTitle,
      automaticallyImplyLeading: false, // Don't automatically add back button
      leading:
          showBackButton
              ? IconButton(
                icon: const Icon(Icons.arrow_back),
                tooltip: 'Back',
                onPressed: onBackButtonPressed,
              )
              : null,
      actions: appBarActions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
