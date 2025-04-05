import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter for navigation
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../../models/content_tab.dart';
import '../../providers/tab_manager_provider.dart';
import '../../providers/settings_provider.dart'; // Import for settings access in source selector
// import '../../../features/board/presentation/widgets/catalog/catalog_view_mode.dart'; // Old path
import 'package:vibechan/shared/enums/catalog_view_mode.dart'; // New package path
import '../../../features/hackernews/presentation/providers/hackernews_stories_provider.dart'; // Needed for HN sort type
import '../../../features/fourchan/presentation/providers/carousel_providers.dart'; // Import hasMedia providers

// Helper function to determine the general category of a tab (moved here)
String _getCategoryFromTab(ContentTab? tab) {
  if (tab == null) return '4chan'; // Default to '4chan'
  switch (tab.initialRouteName) {
    case 'boards':
    case 'catalog':
    case 'thread':
      return 'boards'; // Use 'boards' as the primary 4chan key
    case 'hackernews':
    case 'hackernews_item':
      return 'hackernews';
    case 'lobsters':
    case 'lobsters_story':
      return 'lobsters';
    case 'subredditGrid':
    case 'subreddit':
    case 'postDetail':
      return 'reddit'; // Use 'reddit' as the key
    case 'favorites':
      return 'favorites';
    case 'settings':
      return 'settings';
    default:
      final logger = GetIt.instance<Logger>(instanceName: "AppLogger");
      logger.w(
        "Warning: Unknown initialRouteName '${tab.initialRouteName}' in _getCategoryFromTab, defaulting to boards",
      );
      return 'boards'; // Fallback
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
    {'title': '4chan', 'routeName': 'boards', 'icon': Icons.dashboard_outlined},
    {
      'title': 'Hacker News',
      'routeName': 'hackernews',
      'icon': Icons.newspaper_outlined,
    },
    {'title': 'Lobsters', 'routeName': 'lobsters', 'icon': Icons.rss_feed},
    {'title': 'Reddit', 'routeName': 'reddit', 'icon': Icons.reddit_outlined},
    {
      'title': 'Favorites',
      'routeName': 'favorites',
      'icon': Icons.favorite_outline,
    },
    {
      'title': 'Settings',
      'routeName': 'settings',
      'icon': Icons.settings_outlined,
    },
  ];

  final String currentCategory = _getCategoryFromTab(activeTab);

  // Find the current source
  final currentSource = sources.firstWhere(
    (s) => s['routeName'] == currentCategory,
    orElse:
        () => sources.firstWhere(
          (s) => s['routeName'] == 'boards',
          orElse: () => sources.first,
        ),
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

    // Determine context based on initial route name
    final String? initialRouteName = activeTab?.initialRouteName;
    final bool isThreadContext = initialRouteName == 'thread';
    final bool isCatalogContext = initialRouteName == 'catalog';
    final bool isBoardListContext = initialRouteName == 'boards';
    final bool isHnListContext = initialRouteName == 'hackernews';

    // Visibility flags for buttons
    final bool showCatalogViewButton = isCatalogContext || isBoardListContext;
    final bool showHnSortButton = isHnListContext;

    // Construct sourceInfo strings conditionally
    String? boardSourceInfo;
    String? threadSourceInfo;
    final params = activeTab?.pathParameters;
    if (params != null) {
      final boardId = params['boardId'];
      final threadId = params['threadId'];
      final sourceName = _getCategoryFromTab(
        activeTab,
      ); // Assuming this gives '4chan', 'hackernews' etc.

      if (boardId != null) {
        boardSourceInfo = '$sourceName:$boardId';
        if (threadId != null) {
          threadSourceInfo = '$sourceName:$boardId/$threadId';
        }
      }
    }

    // Watch the hasMedia providers only if the context matches
    final boardHasMediaValue =
        isCatalogContext && boardSourceInfo != null
            ? ref.watch(boardHasMediaProvider(boardSourceInfo))
            : const AsyncData(false); // Default to false if not applicable

    final threadHasMediaValue =
        isThreadContext && threadSourceInfo != null
            ? ref.watch(threadHasMediaProvider(threadSourceInfo))
            : const AsyncData(false); // Default to false if not applicable

    // Determine button visibility based on provider state (use .valueOrNull ?? false)
    final showBoardCarouselButtonFinal =
        isCatalogContext && (boardHasMediaValue.valueOrNull ?? false);
    final showThreadCarouselButtonFinal =
        isThreadContext && (threadHasMediaValue.valueOrNull ?? false);

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
            ).colorScheme.surfaceContainerHighest.withValues(alpha: 128),
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

    List<Widget> actions = [
      // Show search icon only if not already searching
      if (!isSearchVisible)
        IconButton(
          icon: const Icon(Icons.search),
          tooltip: 'Search',
          onPressed: onSearchToggle,
        ),
      // Catalog View Mode Button
      if (showCatalogViewButton)
        PopupMenuButton<CatalogViewMode>(
          icon: const Icon(
            Icons.view_list,
          ), // Consider using the extension icon: mode.icon
          tooltip: 'Change View Mode',
          onSelected: onCatalogViewModeSelected,
          itemBuilder:
              (context) =>
                  CatalogViewMode.values
                      .map(
                        (mode) => PopupMenuItem(
                          value: mode,
                          child: Text(mode.displayName), // Use extension
                        ),
                      )
                      .toList(),
        ),
      // HN Sort Type Button
      if (showHnSortButton)
        PopupMenuButton<HackerNewsSortType>(
          icon: const Icon(Icons.sort),
          tooltip: 'Sort Stories',
          initialValue: currentHnSortType,
          onSelected: (newType) {
            ref.read(currentHackerNewsSortTypeProvider.notifier).state =
                newType;
          },
          itemBuilder:
              (context) =>
                  HackerNewsSortType.values
                      .map(
                        (type) => PopupMenuItem(
                          value: type,
                          child: Text(type.displayName), // Use extension
                        ),
                      )
                      .toList(),
        ),
      // Board Media Carousel Button
      if (showBoardCarouselButtonFinal &&
          boardSourceInfo != null) // Use final variable
        IconButton(
          icon: const Icon(Icons.collections_bookmark_outlined),
          tooltip: 'View Board Media',
          onPressed: () {
            context.pushNamed(
              'carousel',
              pathParameters: {
                'sourceInfo': boardSourceInfo!,
              }, // Safe with check
            );
          },
        ),
      // Thread Media Carousel Button
      if (showThreadCarouselButtonFinal &&
          threadSourceInfo != null) // Use final variable
        IconButton(
          icon: const Icon(Icons.photo_library_outlined),
          tooltip: 'View Thread Media',
          onPressed: () {
            context.pushNamed(
              'carousel',
              pathParameters: {
                'sourceInfo': threadSourceInfo!,
              }, // Safe with check
            );
          },
        ),
      // Open in Browser Button
      if (onOpenInBrowserPressed != null)
        IconButton(
          icon: const Icon(Icons.open_in_browser),
          tooltip: 'Open in Browser',
          onPressed: onOpenInBrowserPressed,
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
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
