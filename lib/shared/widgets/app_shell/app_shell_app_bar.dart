import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter for navigation
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:vibechan/app/app_routes.dart'; // Import AppRoute
// Ensure the side navigation file is imported to access the public helper
import 'package:vibechan/shared/widgets/app_shell/app_shell_side_navigation.dart';

import '../../models/content_tab.dart';
import '../../providers/tab_manager_provider.dart';
import '../../providers/settings_provider.dart'; // Import for settings access in source selector
// import '../../../features/board/presentation/widgets/catalog/catalog_view_mode.dart'; // Old path
import 'package:vibechan/shared/enums/catalog_view_mode.dart'; // New package path
import '../../../features/hackernews/presentation/providers/hackernews_stories_provider.dart'; // Needed for HN sort type
import '../../../features/lobsters/presentation/providers/lobsters_stories_provider.dart'; // Import for Lobsters sort
import '../../../features/reddit/presentation/providers/reddit_sort_provider.dart'; // Import for Reddit sort
import '../../../features/fourchan/presentation/providers/carousel_providers.dart'; // Import hasMedia providers

// Source selector dropdown builder (updated to use AppRoute)
Widget _buildSourceSelector(
  BuildContext context,
  WidgetRef ref,
  ContentTab? activeTab,
  TabManagerNotifier tabNotifier,
) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  final settings = ref.watch(appSettingsProvider);
  final switchToExistingTab =
      ref.read(appSettingsProvider.notifier).switchToExistingTab;

  // Define available sources using AppRoute enums
  // Note: Reddit uses subredditGrid as its entry point
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

  // Use the public helper function from app_shell_side_navigation.dart
  final String currentRouteName = getRouteNameFromTab(activeTab);

  // Find the current source based on route name
  final currentSource = sources.firstWhere(
    (s) => s['routeName'] == currentRouteName,
    orElse:
        () => sources.firstWhere(
          (s) =>
              s['routeName'] == AppRoute.boardList.name, // Fallback to boards
          orElse: () => sources.first, // Ultimate fallback
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
    itemBuilder:
        (context) =>
            sources.map((source) {
              final isSelected = source['routeName'] == currentRouteName;
              return PopupMenuItem<String>(
                value: source['routeName'] as String,
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

        // Check setting and if a tab with the *same base route name* already exists
        ContentTab? existingTab;
        if (settings.value != null && switchToExistingTab) {
          final tabs = ref.read(tabManagerProvider);
          // Use the public helper function from app_shell_side_navigation.dart
          existingTab = tabs.firstWhereOrNull(
            (tab) => getRouteNameFromTab(tab) == newRouteName,
          );
        }

        if (existingTab != null) {
          tabNotifier.setActiveTab(existingTab.id);
        } else {
          // Add a *new* tab for the selected source (using its defined routeName)
          tabNotifier.addTab(
            title: selectedSource['title'] as String,
            initialRouteName:
                selectedSource['routeName']
                    as String, // Use the selected route name
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
  final Function(HackerNewsSortType) onHnSortTypeSelected; // Keep this
  final Function(LobstersSortType) onLobstersSortTypeSelected; // Add this
  final Function(RedditSortType) onRedditSortTypeSelected; // Add this
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
    required this.onLobstersSortTypeSelected, // Add required parameter
    required this.onRedditSortTypeSelected, // Add required parameter
    this.onOpenInBrowserPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch sort providers (no change needed here)
    final currentHnSortType = ref.watch(currentHackerNewsSortTypeProvider);
    final currentLobstersSortType = ref.watch(currentLobstersSortTypeProvider);
    final currentRedditSortType = ref.watch(currentRedditSortTypeProvider);

    // Determine context using AppRoute enums
    final String? initialRouteName = activeTab?.initialRouteName;
    final bool isThreadContext = initialRouteName == AppRoute.thread.name;
    final bool isCatalogContext =
        initialRouteName == AppRoute.boardCatalog.name;
    final bool isBoardListContext = initialRouteName == AppRoute.boardList.name;
    final bool isHnListContext = initialRouteName == AppRoute.hackernews.name;
    final bool isLobstersListContext =
        initialRouteName == AppRoute.lobsters.name;
    final bool isRedditContext =
        initialRouteName ==
        AppRoute.subreddit.name; // Only show sort on subreddit list
    // Note: subredditGrid does not have a sort button in this logic

    // Visibility flags for buttons based on AppRoute
    final bool showCatalogViewButton = isCatalogContext || isBoardListContext;
    final bool showHnSortButton = isHnListContext;
    final bool showLobstersSortButton = isLobstersListContext;
    final bool showRedditSortButton = isRedditContext;

    // Construct sourceInfo strings conditionally (no change needed here)
    String? boardSourceInfo;
    String? threadSourceInfo;
    final params = activeTab?.pathParameters;
    if (params != null) {
      final boardId = params['boardId'];
      final threadId = params['threadId'];
      // Use the public helper function from app_shell_side_navigation.dart
      final sourceCategoryRouteName = getRouteNameFromTab(activeTab);
      // Map route name back to a simple source name if needed for the provider key
      String sourceName;
      if (sourceCategoryRouteName == AppRoute.boardList.name) {
        sourceName = '4chan';
      } else if (sourceCategoryRouteName == AppRoute.hackernews.name) {
        sourceName = 'hackernews';
      } else if (sourceCategoryRouteName == AppRoute.lobsters.name) {
        sourceName = 'lobsters';
      } else if (sourceCategoryRouteName == AppRoute.subredditGrid.name) {
        sourceName = 'reddit';
      } else {
        sourceName = 'unknown'; // Handle fallback if necessary
      }

      if (boardId != null && sourceName == '4chan') {
        // Be specific for 4chan
        boardSourceInfo = '$sourceName:$boardId';
        if (threadId != null) {
          threadSourceInfo = '$sourceName:$boardId/$threadId';
        }
      }
    }

    // Watch the hasMedia providers only if the context matches
    final boardHasMediaValue =
        isCatalogContext &&
                boardSourceInfo !=
                    null // Use AppRoute flag
            ? ref.watch(boardHasMediaProvider(boardSourceInfo))
            : const AsyncData(false);

    final threadHasMediaValue =
        isThreadContext &&
                threadSourceInfo !=
                    null // Use AppRoute flag
            ? ref.watch(threadHasMediaProvider(threadSourceInfo))
            : const AsyncData(false);

    // Determine button visibility based on provider state
    final showBoardCarouselButtonFinal =
        isCatalogContext && (boardHasMediaValue.valueOrNull ?? false);
    final showThreadCarouselButtonFinal =
        isThreadContext && (threadHasMediaValue.valueOrNull ?? false);

    // Handle search UI logic in AppBar (no change needed here)
    Widget appBarTitle;
    if (isSearchVisible) {
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
            fillColor: Theme.of(context).colorScheme.surfaceContainerHighest
                .withAlpha(128), // Use withAlpha
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
      // Use the updated source selector
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
          icon: const Icon(Icons.view_list),
          tooltip: 'Change View Mode',
          onSelected:
              onCatalogViewModeSelected, // Keep using callback from AppShell
          itemBuilder:
              (context) =>
                  CatalogViewMode.values
                      .map(
                        (mode) => PopupMenuItem(
                          value: mode,
                          child: Text(mode.displayName),
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
          // Use callback passed from AppShell
          onSelected: onHnSortTypeSelected,
          itemBuilder:
              (context) =>
                  HackerNewsSortType.values
                      .map(
                        (type) => PopupMenuItem(
                          value: type,
                          child: Text(type.displayName),
                        ),
                      )
                      .toList(),
        ),
      // Lobsters Sort Type Button
      if (showLobstersSortButton)
        PopupMenuButton<LobstersSortType>(
          icon: const Icon(Icons.sort),
          tooltip: 'Sort Stories',
          initialValue: currentLobstersSortType,
          // Use callback passed from AppShell
          onSelected: onLobstersSortTypeSelected,
          itemBuilder:
              (context) =>
                  LobstersSortType.values
                      .map(
                        (type) => PopupMenuItem(
                          value: type,
                          child: Text(type.displayName),
                        ),
                      )
                      .toList(),
        ),
      // Reddit Sort Type Button
      if (showRedditSortButton)
        PopupMenuButton<RedditSortType>(
          icon: const Icon(Icons.sort),
          tooltip: 'Sort Posts',
          initialValue: currentRedditSortType,
          // Use callback passed from AppShell
          onSelected: onRedditSortTypeSelected,
          itemBuilder:
              (context) =>
                  RedditSortType.values
                      .map(
                        (type) => PopupMenuItem(
                          value: type,
                          child: Text(type.displayName),
                        ),
                      )
                      .toList(),
        ),
      // Board Media Carousel Button
      if (showBoardCarouselButtonFinal && boardSourceInfo != null)
        IconButton(
          icon: const Icon(Icons.collections_bookmark_outlined),
          tooltip: 'View Board Media',
          onPressed: () {
            // Use AppRoute name for navigation
            context.pushNamed(
              AppRoute.carousel.name,
              pathParameters: {'sourceInfo': boardSourceInfo!},
            );
          },
        ),
      // Thread Media Carousel Button
      if (showThreadCarouselButtonFinal && threadSourceInfo != null)
        IconButton(
          icon: const Icon(Icons.photo_library_outlined),
          tooltip: 'View Thread Media',
          onPressed: () {
            // Use AppRoute name for navigation
            context.pushNamed(
              AppRoute.carousel.name,
              pathParameters: {'sourceInfo': threadSourceInfo!},
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
      automaticallyImplyLeading: false,
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
