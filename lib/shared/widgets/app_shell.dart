import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart'; // Remove if not directly used for navigation inside AppShell
// Import for Future

import '../models/content_tab.dart';
import '../providers/tab_manager_provider.dart';
import '../providers/search_provider.dart';
// Fix imports for moved screens
// Import HN Screen
// Import the Lobsters screen
// Import HN detail
// Import Lobsters detail
import 'package:vibechan/features/hackernews/presentation/providers/hackernews_stories_provider.dart'; // Import the HN provider
import 'package:vibechan/features/lobsters/presentation/providers/lobsters_stories_provider.dart';
import 'package:vibechan/features/reddit/presentation/providers/reddit_sort_provider.dart';
// Import CatalogViewMode provider from its correct location
import 'package:vibechan/shared/enums/catalog_view_mode.dart';

// Fix import for moved enum
// import 'package:vibechan/shared/enums/catalog_view_mode.dart';

// Import detail screens
// Import responsive layout components
import 'package:vibechan/features/fourchan/presentation/widgets/responsive_widgets.dart';
import 'package:vibechan/core/services/layout_service.dart';
// import 'package:vibechan/shared/providers/settings_provider.dart'; // No longer needed directly here
// import 'package:collection/collection.dart'; // No longer needed

// Import the extracted components
import 'app_shell/app_shell_app_bar.dart';
import 'app_shell/app_shell_bottom_tab_bar.dart';
import 'app_shell/app_shell_side_navigation.dart';
import 'app_shell/app_shell_content_view.dart';

import 'package:vibechan/app/app_routes.dart'; // Import AppRoute

// Revert to ConsumerStatefulWidget
class AppShell extends ConsumerStatefulWidget {
  // Remove child parameter
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell>
    with WidgetsBindingObserver {
  // Internal state management will be reintroduced with TabManager
  // For now, keep it simple or placeholder state
  // int _selectedIndex = 0; // Remove state related to bottom nav index

  // Add a ScrollController for the bottom tab bar
  late final ScrollController _tabScrollController;

  @override
  void initState() {
    super.initState();
    _tabScrollController = ScrollController();
    WidgetsBinding.instance.addObserver(this);

    // Initialize layout state once after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(layoutStateNotifierProvider.notifier).updateLayout(context);
      }
    });
  }

  @override
  void dispose() {
    _tabScrollController.dispose(); // Dispose the controller
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    // Update layout on resize/orientation change, ensuring context is valid
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(layoutStateNotifierProvider.notifier).updateLayout(context);
      }
    });
    super.didChangeMetrics();
  }

  // Back Button Handler (updated to use AppRoute enums)
  void _handleBackButton(WidgetRef ref, ContentTab? currentTab) {
    if (currentTab == null) return;

    final tabNotifier = ref.read(tabManagerProvider.notifier);
    final routeName = currentTab.initialRouteName;
    final params = currentTab.pathParameters;

    // Use AppRoute enums for comparisons
    if (routeName == AppRoute.thread.name) {
      final boardId = params['boardId'];
      if (boardId != null) {
        tabNotifier.navigateToOrReplaceActiveTab(
          title: '/$boardId/ Catalog',
          initialRouteName: AppRoute.boardCatalog.name,
          pathParameters: {'boardId': boardId},
          icon: Icons.view_list, // Consider a dedicated catalog icon
        );
      } else {
        // Fallback to boards list if boardId is somehow null
        tabNotifier.navigateToOrReplaceActiveTab(
          title: 'Boards',
          initialRouteName: AppRoute.boardList.name,
          pathParameters: {},
          icon: Icons.dashboard_outlined, // Match source selector icon
        );
      }
    } else if (routeName == AppRoute.hackernewsItem.name) {
      tabNotifier.navigateToOrReplaceActiveTab(
        title: 'Hacker News',
        initialRouteName: AppRoute.hackernews.name,
        pathParameters: {},
        icon: Icons.newspaper_outlined, // Match source selector icon
      );
    } else if (routeName == AppRoute.lobstersStory.name) {
      tabNotifier.navigateToOrReplaceActiveTab(
        title: 'Lobsters',
        initialRouteName: AppRoute.lobsters.name,
        pathParameters: {},
        icon: Icons.rss_feed, // Match source selector icon
      );
    } else if (routeName == AppRoute.postDetail.name) {
      final subredditName = params['subredditName'];
      if (subredditName != null) {
        tabNotifier.navigateToOrReplaceActiveTab(
          title: 'r/$subredditName',
          initialRouteName: AppRoute.subreddit.name,
          pathParameters: {'subredditName': subredditName},
          icon: Icons.reddit_outlined, // Match source selector icon
        );
      } else {
        // Fallback to subreddit grid if name is somehow null
        tabNotifier.navigateToOrReplaceActiveTab(
          title: 'Reddit',
          initialRouteName: AppRoute.subredditGrid.name,
          pathParameters: {},
          icon: Icons.reddit_outlined, // Match source selector icon
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch necessary providers
    final tabs = ref.watch(tabManagerProvider);
    final activeTab = ref.watch(tabManagerProvider.notifier).activeTab;
    final tabNotifier = ref.read(tabManagerProvider.notifier);
    final layoutState = ref.watch(layoutStateNotifierProvider);
    final layoutService = ref.read(layoutServiceProvider);
    final isSearchVisible = ref.watch(searchVisibleProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    // Watch the correct catalog view mode provider (defined in its own file)
    // final viewMode = ref.watch(catalogViewModeProvider); // Remove watch here if only needed in AppBar

    // Determine UI states based on providers
    final String? currentRouteName = activeTab?.initialRouteName;
    final bool showBackButton =
        currentRouteName == AppRoute.hackernewsItem.name ||
        currentRouteName == AppRoute.lobstersStory.name ||
        currentRouteName == AppRoute.thread.name ||
        currentRouteName == AppRoute.postDetail.name;

    final bool useSideNavigation = layoutService.shouldShowSidePanel(
      layoutState.currentLayout,
    );

    // Use WillPopScope to handle system back button presses for detail views
    return WillPopScope(
      onWillPop: () async {
        // Use the calculated showBackButton flag
        if (showBackButton) {
          _handleBackButton(ref, activeTab);
          return false; // Prevent default back behavior
        }
        // Allow default back behavior (like closing the app) if not in a detail view
        // Or return false if you want to prevent closing the app with back button.
        return true; // Or false based on desired behavior
      },
      child: ResponsiveScaffold(
        // Use the extracted AppBar widget
        appBar: AppShellAppBar(
          activeTab: activeTab,
          tabNotifier: tabNotifier,
          isSearchVisible: isSearchVisible,
          searchQuery: searchQuery,
          showBackButton: showBackButton,
          onSearchToggle: () {
            final currentSearchVisible = ref.read(searchVisibleProvider);
            ref.read(searchVisibleProvider.notifier).state =
                !currentSearchVisible;
            if (currentSearchVisible) {
              // Clear search query when closing the search bar
              ref.read(searchQueryProvider.notifier).state = '';
            }
          },
          onSearchChanged: (value) {
            ref.read(searchQueryProvider.notifier).state = value;
          },
          onSearchClear: () {
            ref.read(searchQueryProvider.notifier).state = '';
          },
          onBackButtonPressed: () {
            _handleBackButton(ref, activeTab);
          },
          // Use the correct provider name
          onCatalogViewModeSelected: (mode) {
            ref.read(catalogViewModeProvider.notifier).set(mode);
          },
          onHnSortTypeSelected: (sortType) {
            ref.read(currentHackerNewsSortTypeProvider.notifier).state =
                sortType;
          },
          // Pass the Lobsters sort callback
          onLobstersSortTypeSelected: (sortType) {
            ref.read(currentLobstersSortTypeProvider.notifier).state = sortType;
          },
          // Pass the Reddit sort callback
          onRedditSortTypeSelected: (sortType) {
            ref.read(currentRedditSortTypeProvider.notifier).state = sortType;
          },
          // TODO: Implement onOpenInBrowserPressed logic if needed
        ),
        // Conditionally show the extracted Side Navigation widget
        drawer:
            useSideNavigation
                ? AppShellSideNavigation(
                  tabs: tabs,
                  activeTab: activeTab,
                  tabNotifier: tabNotifier,
                )
                : null,
        // Use the extracted Content View widget wrapped in AnimatedLayoutBuilder
        body: AnimatedLayoutBuilder(
          child: AppShellContentView(
            activeTab: activeTab,
            isSearchVisible: isSearchVisible,
          ),
        ),
        // Conditionally show the extracted Bottom Tab Bar widget
        bottomNavigationBar:
            !useSideNavigation
                ? SafeArea(
                  child: AppShellBottomTabBar(
                    tabs: tabs,
                    activeTab: activeTab,
                    tabScrollController: _tabScrollController,
                    onReorder: (oldIndex, newIndex) {
                      tabNotifier.reorderTab(oldIndex, newIndex);
                    },
                  ),
                )
                : null,
      ),
    );
  }
}
