import 'package:flutter/gestures.dart'; // Import for PointerScrollEvent
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart'; // Remove if not directly used for navigation inside AppShell
import 'dart:async'; // Import for Future

import '../../config/app_config.dart';
import '../models/content_tab.dart';
import '../providers/tab_manager_provider.dart';
// Import the screens needed for ContentTabView logic
import '../../features/board/presentation/screens/board_list_screen.dart';
import '../../features/board/presentation/screens/board_catalog_screen.dart';
import '../../features/board/presentation/screens/favorites_screen.dart';
import '../../features/board/presentation/screens/settings_screen.dart';
import '../../features/thread/presentation/screens/thread_detail_screen.dart';
import '../../features/hackernews/presentation/screens/hackernews_screen.dart'; // Import HN Screen
// Import the Lobsters screen
import '../../features/lobsters/presentation/screens/lobsters_screen.dart';
// Import the HN provider and enum for the AppBar controls
import '../../features/hackernews/presentation/providers/hackernews_stories_provider.dart';
import '../../core/presentation/widgets/settings_dialog.dart'; // Import the settings dialog

import '../../features/board/presentation/widgets/catalog/catalog_view_mode.dart';
// Import detail screens
import '../../features/hackernews/presentation/screens/hackernews_item_screen.dart'; // Import HN detail
import '../../features/lobsters/presentation/screens/lobsters_story_screen.dart'; // Import Lobsters detail

// Import responsive layout components
import '../../core/utils/responsive_layout.dart';
import '../../core/presentation/widgets/responsive_widgets.dart';
import '../../core/services/layout_service.dart';
import 'package:vibechan/shared/providers/search_provider.dart';
import 'package:vibechan/shared/providers/settings_provider.dart'; // Import the settings provider
import 'package:collection/collection.dart'; // Import for firstWhereOrNull

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
    // Register as widget binding observer to detect screen size changes
    WidgetsBinding.instance.addObserver(this);

    // Ensure at least one tab exists when the app starts.
    // Add this in post-frame callback to safely interact with provider.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tabs = ref.read(tabManagerProvider);
      if (tabs.isEmpty) {
        ref
            .read(tabManagerProvider.notifier)
            .addTab(
              title: 'Boards', // Initial tab title
              initialRouteName:
                  'boards', // Match route name if using logic below
              icon: Icons.dashboard, // Default icon
            );
      }

      // Initialize the layout state based on current context
      ref.read(layoutStateNotifierProvider.notifier).updateLayout(context);
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
    // Update layout when screen metrics change (e.g., orientation change or window resize)
    ref.read(layoutStateNotifierProvider.notifier).updateLayout(context);
    super.didChangeMetrics();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = ref.watch(tabManagerProvider);
    final activeTab = ref.watch(tabManagerProvider.notifier).activeTab;
    final tabNotifier = ref.read(tabManagerProvider.notifier);

    // Read current layout state
    final layoutState = ref.watch(layoutStateNotifierProvider);
    final currentLayout = layoutState.currentLayout;

    // Get layout service instance
    final layoutService = ref.read(layoutServiceProvider);

    // Read the HN sort type provider for the AppBar action
    final currentHnSortType = ref.watch(currentHackerNewsSortTypeProvider);

    // Get screen dimensions for responsive UI
    final screenSize = MediaQuery.of(context).size;
    final layoutType = layoutService.getLayoutForContext(context);

    // Listen to search state changes
    final isSearchVisible = ref.watch(searchVisibleProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    // Determine if back button should be shown
    // Show if it's a detail view (HN item, Lobsters story, 4chan thread)
    bool showBackButton =
        activeTab != null &&
        (activeTab.initialRouteName == 'hackernews_item' ||
            activeTab.initialRouteName == 'lobsters_story' ||
            activeTab.initialRouteName == 'thread');

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
            ).colorScheme.surfaceVariant.withOpacity(0.5),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 16,
            ),
            prefixIcon: const Icon(Icons.search, size: 20),
            suffixIcon:
                searchQuery.isNotEmpty
                    ? IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      onPressed: () {
                        ref.read(searchQueryProvider.notifier).state = '';
                      },
                    )
                    : null,
          ),
          onChanged: (value) {
            ref.read(searchQueryProvider.notifier).state = value;
          },
        ),
      );
    } else {
      // Use the source selector in the title position
      appBarTitle = _buildSourceSelector(context, ref, activeTab, tabNotifier);
    }

    // Create app bar actions
    final List<Widget> appBarActions = [
      // Search button (shown on all screens)
      IconButton(
        icon: Icon(isSearchVisible ? Icons.close : Icons.search, size: 24),
        tooltip: isSearchVisible ? 'Close search' : 'Search content',
        onPressed: () {
          // Toggle search visibility
          ref.read(searchVisibleProvider.notifier).state = !isSearchVisible;

          // Clear search when closing
          if (isSearchVisible) {
            ref.read(searchQueryProvider.notifier).state = '';
          }
        },
      ),

      // Layout mode toggle (conditional - only shown when search is not visible)
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
              onSelected:
                  (mode) =>
                      ref.read(catalogViewModeProvider.notifier).set(mode),
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
              onSelected: (newSortType) {
                ref.read(currentHackerNewsSortTypeProvider.notifier).state =
                    newSortType;
              },
            );
          },
        ),
    ];

    // Determine if we should use side navigation instead of bottom tabs
    final bool useSideNavigation = layoutService.shouldShowSidePanel(
      currentLayout,
    );
    final double sideNavWidth = layoutService.getSidePanelWidth(currentLayout);

    // Wrap Scaffold with WillPopScope
    return WillPopScope(
      onWillPop: () async {
        final activeTab = ref.read(tabManagerProvider.notifier).activeTab;

        if (activeTab != null) {
          // Check if the current tab is a detail view that should have custom back behavior
          final isDetailView =
              activeTab.initialRouteName == 'thread' ||
              activeTab.initialRouteName == 'hackernews_item' ||
              activeTab.initialRouteName == 'lobsters_story';

          if (isDetailView) {
            // If it's a detail view, trigger the custom back navigation logic
            _handleBackButton(ref, activeTab);
            return false; // Prevent default system back behavior
          } else {
            // If not a detail view, do nothing on back press
            return false; // Prevent default system back behavior (e.g., closing tab/app)
          }
        } else {
          // No active tab, should ideally not happen, but prevent exit just in case
          return false;
        }
      },
      child: ResponsiveScaffold(
        appBar: AppBar(
          title: appBarTitle,
          automaticallyImplyLeading:
              false, // Don't automatically add back button
          leading:
              showBackButton
                  ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    tooltip: 'Back',
                    onPressed: () => _handleBackButton(ref, activeTab!),
                  )
                  : null,
          actions: appBarActions,
        ),
        // Conditionally use side drawer for larger screens
        drawer:
            useSideNavigation
                ? _buildSideNavigation(tabs, activeTab, tabNotifier)
                : null,
        // Adapt body based on layout
        body: AnimatedLayoutBuilder(
          child: Column(
            children: [
              // Secondary app bar for content title (without any margins)
              if (activeTab != null && !isSearchVisible)
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).colorScheme.outlineVariant,
                        width: 0.5,
                      ),
                    ),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 10.0,
                  ),
                  child: Text(
                    activeTab.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              // Main content
              Expanded(
                child: Row(
                  children: [
                    // Side navigation for larger screens (visible directly, not in drawer)
                    if (useSideNavigation &&
                        false) // Disabled to use drawer instead
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: sideNavWidth,
                        child: _buildSideNavigation(
                          tabs,
                          activeTab,
                          tabNotifier,
                        ),
                      ),
                    // Main content area
                    Expanded(
                      child:
                          activeTab != null
                              ? _buildTabContent(
                                activeTab,
                              ) // Use helper to build content
                              : const Center(
                                child: Text(
                                  'No tabs open. Press + to add one.',
                                ),
                              ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Only show bottom navigation bar on smaller screens
        bottomNavigationBar:
            !useSideNavigation
                ? SafeArea(
                  child: Builder(
                    builder: (context) {
                      final colorScheme = Theme.of(context).colorScheme;

                      return Container(
                        height: 50, // Adjust height as needed
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color:
                              colorScheme
                                  .surfaceContainerLow, // Use Material 3 surface container
                          border: Border(
                            top: BorderSide(
                              color: colorScheme.outlineVariant,
                              width: 0.5,
                            ),
                          ),
                        ),
                        // Add Listener to intercept scroll wheel events -> Restore
                        child: Listener(
                          onPointerSignal: (pointerSignal) {
                            if (pointerSignal is PointerScrollEvent) {
                              final double scrollAmount =
                                  pointerSignal.scrollDelta.dy;
                              final double sensitivity =
                                  30.0; // Adjust scroll sensitivity

                              if (scrollAmount.abs() > 0) {
                                // Check if there is vertical scroll
                                // Corrected calculation:
                                // Scroll Up (dy < 0) -> Move Right (increase offset)
                                // Scroll Down (dy > 0) -> Move Left (decrease offset)
                                // So, the offset change should be the *negative* of dy's sign.
                                double newOffset =
                                    _tabScrollController.offset -
                                    (scrollAmount.sign * sensitivity);

                                // Clamp the offset to prevent overscrolling
                                newOffset = newOffset.clamp(
                                  _tabScrollController.position.minScrollExtent,
                                  _tabScrollController.position.maxScrollExtent,
                                );
                                _tabScrollController.animateTo(
                                  newOffset,
                                  duration: const Duration(
                                    milliseconds: 100,
                                  ), // Adjust animation speed
                                  curve:
                                      Curves.easeOut, // Adjust animation curve
                                );
                              }
                            }
                          },
                          // Keep the ReorderableListView.builder as the child of the Listener
                          child: ReorderableListView.builder(
                            key: const Key('tab-reorderable-list'),
                            scrollController: _tabScrollController,
                            scrollDirection: Axis.horizontal,
                            buildDefaultDragHandles: false,
                            itemCount: tabs.length,
                            itemBuilder: (context, index) {
                              final tab = tabs[index];
                              // MUST provide a unique key for each item
                              return KeyedSubtree(
                                key: ValueKey(tab.id),
                                // Wrap the button with the drag listener
                                child: ReorderableDragStartListener(
                                  index: index, // Pass the item's index
                                  child: _buildTabButton(context, tab),
                                ),
                              );
                            },
                            onReorder: (oldIndex, newIndex) {
                              ref
                                  .read(tabManagerProvider.notifier)
                                  .reorderTab(oldIndex, newIndex);
                            },
                            proxyDecorator: (
                              Widget child,
                              int index,
                              Animation<double> animation,
                            ) {
                              // Keep the existing proxy decorator for visual feedback
                              return Material(
                                elevation: 4.0,
                                color: Colors.transparent,
                                child: ScaleTransition(
                                  scale: animation.drive(
                                    Tween<double>(begin: 1.0, end: 1.05),
                                  ),
                                  child: child,
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                )
                : null,
      ),
    );
  }

  // Build side navigation panel for larger screens
  Widget _buildSideNavigation(
    List<ContentTab> tabs,
    ContentTab? activeTab,
    TabManagerNotifier tabNotifier,
  ) {
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
            child: ListView.builder(
              itemCount: tabs.length,
              itemBuilder: (context, index) {
                final tab = tabs[index];
                final isActive = tab.id == activeTab?.id;

                return ListTile(
                  leading: Icon(tab.icon),
                  title: Text(tab.title),
                  selected: isActive,
                  onTap: () => tabNotifier.setActiveTab(tab.id),
                  trailing: IconButton(
                    icon: const Icon(Icons.close, size: 16),
                    onPressed: () => tabNotifier.removeTab(tab.id),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper function to build tab content ---
  Widget _buildTabContent(ContentTab tab) {
    // Get padding based on current layout
    final layoutState = ref.watch(layoutStateNotifierProvider);
    final layoutService = ref.read(layoutServiceProvider);
    final padding = layoutService.getPaddingForLayout(
      layoutState.currentLayout,
    );

    // This logic determines which screen to show based on the active tab's state
    Widget content;
    bool addPadding = true; // Default is to add padding

    switch (tab.initialRouteName) {
      case 'boards':
        content = const BoardListScreen();
        break;
      case 'catalog':
        // Need boardId from pathParameters
        final boardId = tab.pathParameters['boardId'];
        content =
            boardId != null
                ? BoardCatalogScreen(boardId: boardId)
                : const Center(child: Text('Error: Missing boardId'));
        addPadding = false; // BoardCatalogScreen handles its own padding
        break;
      case 'thread':
        // Need boardId and threadId from pathParameters
        final boardId = tab.pathParameters['boardId'];
        final threadId = tab.pathParameters['threadId'];
        content =
            (boardId != null && threadId != null)
                ? ThreadDetailScreen(boardId: boardId, threadId: threadId)
                : const Center(child: Text('Error: Missing board/thread ID'));
        addPadding = false; // ThreadDetailScreen has its own padding
        break;
      case 'favorites':
        content = const FavoritesScreen();
        break;
      case 'settings':
        content = const SettingsScreen();
        break;
      case 'hackernews':
        content = const HackerNewsScreen();
        break;
      case 'hackernews_item':
        final itemIdStr = tab.pathParameters['itemId'];
        final itemId = int.tryParse(itemIdStr ?? '');
        content =
            itemId != null
                ? HackerNewsItemScreen(itemId: itemId)
                : const Center(child: Text('Error: Missing item ID'));
        addPadding = false; // HackerNewsItemScreen has its own padding
        break;
      case 'lobsters':
        content = const LobstersScreen();
        break;
      case 'lobsters_story':
        final storyId = tab.pathParameters['storyId'];
        content =
            storyId != null
                ? LobstersStoryScreen(storyId: storyId)
                : const Center(child: Text('Error: Missing story ID'));
        addPadding = false; // LobstersStoryScreen has its own padding
        break;
      default:
        // Fallback for unknown route or initial state
        content = Center(child: Text('Content for: ${tab.title}'));
    }

    // Wrap content with padding based on layout
    return addPadding ? Padding(padding: padding, child: content) : content;
  }
  // --- End Helper ---

  // --- New Back Button Handler ---
  void _handleBackButton(WidgetRef ref, ContentTab currentTab) {
    final tabNotifier = ref.read(tabManagerProvider.notifier);

    switch (currentTab.initialRouteName) {
      case 'thread':
        // Navigate back to the specific board catalog
        final boardId = currentTab.pathParameters['boardId'];
        if (boardId != null) {
          tabNotifier.navigateToOrReplaceActiveTab(
            title: '/$boardId/ Catalog', // Or a better title
            initialRouteName: 'catalog',
            pathParameters: {'boardId': boardId},
            icon: Icons.view_list, // Or appropriate icon
          );
        } else {
          print("Error: Missing boardId for thread back navigation.");
          // Fallback: Navigate to general boards list
          tabNotifier.navigateToOrReplaceActiveTab(
            title: 'Boards',
            initialRouteName: 'boards',
            pathParameters: {},
            icon: Icons.dashboard,
          );
        }
        break;
      case 'hackernews_item':
        // Navigate back to the main Hacker News list
        tabNotifier.navigateToOrReplaceActiveTab(
          title: 'Hacker News',
          initialRouteName: 'hackernews',
          pathParameters: {},
          icon: Icons.newspaper,
        );
        break;
      case 'lobsters_story':
        // Navigate back to the main Lobsters list
        tabNotifier.navigateToOrReplaceActiveTab(
          title: 'Lobsters',
          initialRouteName: 'lobsters',
          pathParameters: {},
          icon: Icons.rss_feed,
        );
        break;
      default:
        // Should not happen if showBackButton logic is correct, but add a fallback
        print("Warning: Back button pressed on unexpected screen type.");
        // Attempt to navigate to a default/home tab if possible
        if (ref.read(tabManagerProvider).isNotEmpty) {
          tabNotifier.setActiveTab(ref.read(tabManagerProvider).first.id);
        }
    }
  }
  // --- End Back Button Handler ---

  // --- Build Tab Button ---
  Widget _buildTabButton(BuildContext context, ContentTab tab) {
    final bool isActive =
        ref.watch(tabManagerProvider.notifier).activeTab?.id == tab.id;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent, // Use transparent for Material ripple effect
      child: InkWell(
        onTap: () => ref.read(tabManagerProvider.notifier).setActiveTab(tab.id),
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          margin: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 4.0),
          decoration: BoxDecoration(
            color:
                isActive
                    ? colorScheme.secondaryContainer
                    : colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                tab.icon,
                size: 18,
                color:
                    isActive
                        ? colorScheme.onSecondaryContainer
                        : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                tab.title,
                style: textTheme.labelMedium?.copyWith(
                  color:
                      isActive
                          ? colorScheme.onSecondaryContainer
                          : colorScheme.onSurfaceVariant,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(width: 6),
              // Close button - consider making it smaller/more subtle
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap:
                    () =>
                        ref.read(tabManagerProvider.notifier).removeTab(tab.id),
                child: Icon(
                  Icons.close,
                  size: 16,
                  color:
                      isActive
                          ? colorScheme.onSecondaryContainer
                          : colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- End Build Tab Button ---

  // Build search bar for app bar
  Widget _buildSearchBar(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TextField(
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Search...',
        hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      style: TextStyle(color: colorScheme.onSurface),
      onChanged: (value) {
        ref.read(searchQueryProvider.notifier).state = value;
      },
    );
  }

  // Show more options sheet
  void _showMoreOptionsSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) => const SettingsDialog(),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('About'),
                onTap: () {
                  Navigator.pop(context);
                  // Show about dialog or navigate to about screen
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

// ADD HELPER FUNCTIONS AT THE END OF THE CLASS or outside

// Helper function to determine the general category of a tab
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

// Widget builder for the source selector dropdown
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

  // Define available sources (can be refactored later)
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

// Widget builder for side navigation source selector
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
          ...sources
              .map(
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
              )
              .toList(),
        ],
      ),
    ),
  );
}
