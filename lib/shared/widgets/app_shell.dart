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

// Fix import for moved enum
import 'package:vibechan/shared/enums/catalog_view_mode.dart';

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

  // Back Button Handler (kept in main state as it orchestrates tab navigation)
  void _handleBackButton(WidgetRef ref, ContentTab? currentTab) {
    if (currentTab == null) return; // Safety check

    final tabNotifier = ref.read(tabManagerProvider.notifier);
    final routeName = currentTab.initialRouteName;

    // Define navigation targets based on the current detail view route
    // Compare routeName (String?) with the actual string values from AppRoute
    if (routeName == AppRoute.thread.name) {
      final boardId = currentTab.pathParameters['boardId'];
      if (boardId != null) {
        tabNotifier.navigateToOrReplaceActiveTab(
          title: '/$boardId/ Catalog',
          initialRouteName: AppRoute.boardCatalog.name,
          pathParameters: {'boardId': boardId},
          icon: Icons.view_list,
        );
      } else {
        tabNotifier.navigateToOrReplaceActiveTab(
          title: 'Boards',
          initialRouteName: AppRoute.boardList.name,
          pathParameters: {},
          icon: Icons.dashboard,
        );
      }
    } else if (routeName == AppRoute.hackernewsItem.name) {
      tabNotifier.navigateToOrReplaceActiveTab(
        title: 'Hacker News',
        initialRouteName: AppRoute.hackernews.name,
        pathParameters: {},
        icon: Icons.newspaper,
      );
    } else if (routeName == AppRoute.lobstersStory.name) {
      tabNotifier.navigateToOrReplaceActiveTab(
        title: 'Lobsters',
        initialRouteName: AppRoute.lobsters.name,
        pathParameters: {},
        icon: Icons.rss_feed,
      );
    } else if (routeName == AppRoute.postDetail.name) {
      final subredditName = currentTab.pathParameters['subredditName'];
      if (subredditName != null) {
        tabNotifier.navigateToOrReplaceActiveTab(
          title: 'r/$subredditName',
          initialRouteName: AppRoute.subreddit.name,
          pathParameters: {'subredditName': subredditName},
          icon: Icons.reddit,
        );
      } else {
        tabNotifier.navigateToOrReplaceActiveTab(
          title: 'Reddit',
          initialRouteName: AppRoute.subredditGrid.name,
          pathParameters: {},
          icon: Icons.grid_view,
        );
      }
    }
    // No else needed, as this function is only relevant for specific detail routes
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
        // Re-check the condition using the local variable
        final bool isDetailView = showBackButton; // We already calculated this

        if (isDetailView) {
          _handleBackButton(ref, activeTab); // Use our custom back logic
          return false; // Prevent default system back behavior
        } else {
          // Prevent closing the app/tab via system back button in other cases
          return false;
        }
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
            // Ensure activeTab is not null before calling back handler
            if (activeTab != null) {
              _handleBackButton(ref, activeTab);
            }
          },
          // Use the correct provider name
          onCatalogViewModeSelected: (mode) {
            ref.read(catalogViewModeProvider.notifier).set(mode);
          },
          onHnSortTypeSelected: (sortType) {
            ref.read(currentHackerNewsSortTypeProvider.notifier).state =
                sortType;
          },
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
