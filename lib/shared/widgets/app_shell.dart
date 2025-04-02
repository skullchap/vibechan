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

    // Determine if back button should be shown
    // Show if it's a detail view (HN item, Lobsters story, 4chan thread)
    bool showBackButton =
        activeTab != null &&
        (activeTab.initialRouteName == 'hackernews_item' ||
            activeTab.initialRouteName == 'lobsters_story' ||
            activeTab.initialRouteName == 'thread');

    List<Widget> appBarActions = [
      // Conditionally show view mode toggle if active tab is boards/catalog?
      if (activeTab?.initialRouteName == 'boards' ||
          activeTab?.initialRouteName == 'catalog')
        Consumer(
          builder: (context, ref, _) {
            final mode = ref.watch(catalogViewModeProvider);
            return PopupMenuButton<CatalogViewMode>(
              tooltip: 'Layout mode',
              initialValue: mode,
              onSelected:
                  (mode) =>
                      ref.read(catalogViewModeProvider.notifier).set(mode),
              icon: const Icon(Icons.view_compact_outlined),
              itemBuilder:
                  (context) => [
                    const PopupMenuItem(
                      value: CatalogViewMode.grid,
                      child: ListTile(
                        leading: Icon(Icons.grid_view),
                        title: Text('Grid View'),
                      ),
                    ),
                    const PopupMenuItem(
                      value: CatalogViewMode.media,
                      child: ListTile(
                        leading: Icon(Icons.photo_library),
                        title: Text('Media Feed'),
                      ),
                    ),
                  ],
            );
          },
        ),
      // HN Sort Dropdown (conditionally shown)
      if (activeTab?.initialRouteName == 'hackernews')
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: DropdownButton<HackerNewsSortType>(
            value: currentHnSortType,
            underline: Container(),
            icon: const Icon(Icons.sort),
            items:
                HackerNewsSortType.values
                    .map(
                      (sortType) => DropdownMenuItem(
                        value: sortType,
                        child: Text(
                          sortType.name[0].toUpperCase() +
                              sortType.name.substring(1),
                        ),
                      ),
                    )
                    .toList(),
            onChanged: (newSortType) {
              if (newSortType != null) {
                ref.read(currentHackerNewsSortTypeProvider.notifier).state =
                    newSortType;
              }
            },
          ),
        ),
      IconButton(
        icon: const Icon(Icons.settings),
        tooltip: 'Settings',
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const SettingsDialog(),
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
          // Use the source selector dropdown as the title
          title: _buildSourceSelector(context, ref, activeTab, tabNotifier),
          // Conditionally add the leading back button
          leading:
              showBackButton
                  ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    tooltip: 'Back',
                    onPressed:
                        () => _handleBackButton(
                          ref,
                          activeTab!,
                        ), // Pass activeTab directly
                  )
                  : null, // No back button if not applicable
          actions: appBarActions,
        ),
        // Conditionally use side drawer for larger screens
        drawer:
            useSideNavigation
                ? _buildSideNavigation(tabs, activeTab, tabNotifier)
                : null,
        // Adapt body based on layout
        body: AnimatedLayoutBuilder(
          child: Row(
            children: [
              // Side navigation for larger screens (visible directly, not in drawer)
              if (useSideNavigation && false) // Disabled to use drawer instead
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: sideNavWidth,
                  child: _buildSideNavigation(tabs, activeTab, tabNotifier),
                ),
              // Main content
              Expanded(
                child:
                    activeTab != null
                        ? _buildTabContent(
                          activeTab,
                        ) // Use helper to build content
                        : const Center(
                          child: Text('No tabs open. Press + to add one.'),
                        ),
              ),
            ],
          ),
        ),
        // Only show bottom navigation bar on smaller screens
        bottomNavigationBar:
            !useSideNavigation
                ? SafeArea(
                  child: Container(
                    height: 50, // Adjust height as needed
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color:
                          Theme.of(
                            context,
                          ).colorScheme.surfaceVariant, // Or appropriate color
                      border: Border(
                        top: BorderSide(
                          color: Theme.of(context).dividerColor,
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
                              curve: Curves.easeOut, // Adjust animation curve
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
        break;
      case 'thread':
        // Need boardId and threadId from pathParameters
        final boardId = tab.pathParameters['boardId'];
        final threadId = tab.pathParameters['threadId'];
        content =
            (boardId != null && threadId != null)
                ? ThreadDetailScreen(boardId: boardId, threadId: threadId)
                : const Center(child: Text('Error: Missing board/thread ID'));
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
        break;
      default:
        // Fallback for unknown route or initial state
        content = Center(child: Text('Content for: ${tab.title}'));
    }

    // Wrap content with padding based on layout
    return Padding(padding: padding, child: content);
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

    return Material(
      color: Colors.transparent, // Use transparent for Material ripple effect
      child: InkWell(
        onTap: () => ref.read(tabManagerProvider.notifier).setActiveTab(tab.id),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          margin: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: isActive ? colorScheme.primaryContainer : null,
            borderRadius: BorderRadius.circular(8.0),
            // border: Border.all(
            //   color: isActive ? colorScheme.primary : Colors.grey.shade400,
            //   width: 1.0,
            // ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...[
                Icon(
                  tab.icon,
                  size: 18,
                  color:
                      isActive
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                tab.title,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color:
                      isActive
                          ? colorScheme.onPrimaryContainer
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
                          ? colorScheme.onPrimaryContainer.withOpacity(0.7)
                          : colorScheme.onSurfaceVariant.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- End Build Tab Button ---
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

  return DropdownButtonHideUnderline(
    child: DropdownButton<String>(
      value: currentCategory,
      icon: Icon(
        Icons.arrow_drop_down,
        color: colorScheme.onPrimary,
      ), // Adjust color as needed
      style:
          theme.appBarTheme.titleTextStyle ??
          theme.textTheme.titleLarge?.copyWith(color: colorScheme.onPrimary),
      dropdownColor:
          colorScheme.surfaceContainerHighest, // Or another suitable color
      items:
          sources.map((source) {
            return DropdownMenuItem<String>(
              value: source['routeName'] as String,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    source['icon'] as IconData?,
                    size: 20,
                    color: colorScheme.onSurfaceVariant,
                  ), // Style icon
                  const SizedBox(width: 8),
                  Text(
                    source['title'] as String,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ), // Style text
                  ),
                ],
              ),
            );
          }).toList(),
      onChanged: (String? newRouteName) {
        if (newRouteName != null) {
          final selectedSource = sources.firstWhere(
            (s) => s['routeName'] == newRouteName,
          );
          // Add a *new* tab for the selected source
          tabNotifier.addTab(
            title: selectedSource['title'] as String,
            initialRouteName: selectedSource['routeName'] as String,
            icon: selectedSource['icon'] ?? Icons.web,
          );
        }
      },
    ),
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

  return Row(
    children: [
      Icon(Icons.source, color: colorScheme.primary),
      const SizedBox(width: 8),
      Expanded(
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            icon: Icon(Icons.arrow_drop_down, color: colorScheme.onSurface),
            style: theme.textTheme.titleMedium,
            items:
                sources.map((source) {
                  return DropdownMenuItem<String>(
                    value: source['routeName'] as String,
                    child: Row(
                      children: [
                        Icon(source['icon'] as IconData?, size: 18),
                        const SizedBox(width: 8),
                        Text(source['title'] as String),
                      ],
                    ),
                  );
                }).toList(),
            onChanged: (String? newRouteName) {
              if (newRouteName != null) {
                final selectedSource = sources.firstWhere(
                  (s) => s['routeName'] == newRouteName,
                );
                // Add a new tab
                tabNotifier.addTab(
                  title: selectedSource['title'] as String,
                  initialRouteName: selectedSource['routeName'] as String,
                  icon: selectedSource['icon'] ?? Icons.web,
                );
              }
            },
            hint: const Text('Add new tab'),
          ),
        ),
      ),
      IconButton(
        icon: const Icon(Icons.add),
        tooltip: 'Add new tab',
        onPressed: () {
          // Show dialog or dropdown to add a new tab
          // This is a duplicate way to add tabs for accessibility
        },
      ),
    ],
  );
}
