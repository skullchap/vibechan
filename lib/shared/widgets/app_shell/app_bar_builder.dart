import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/layout_service.dart';
import '../../../features/board/presentation/widgets/catalog/catalog_view_mode.dart';
import '../../../features/hackernews/presentation/providers/hackernews_stories_provider.dart';
import '../../models/content_tab.dart';
import '../../providers/search_provider.dart';
import '../../providers/tab_manager_provider.dart';
import 'source_selector.dart';

/// Builds the main app bar with search support, source selector, and actions
AppBar buildAppBar(
  BuildContext context,
  WidgetRef ref,
  ContentTab? activeTab,
  bool isSearchVisible,
) {
  final searchQuery = ref.watch(searchQueryProvider);
  final currentHnSortType = ref.watch(currentHackerNewsSortTypeProvider);
  final tabNotifier = ref.read(tabManagerProvider.notifier);

  // Get window width directly to ensure responsive behavior
  final windowWidth = MediaQuery.of(context).size.width;
  final isDesktop = windowWidth >= 800;

  // Also check the layout state from the provider
  final layoutState = ref.watch(layoutStateNotifierProvider);
  final currentLayout = layoutState.currentLayout;
  final useSideNavigation =
      isDesktop ||
      currentLayout == AppLayout.desktop ||
      currentLayout == AppLayout.wideDesktop ||
      currentLayout == AppLayout.compactDesktop;

  // Determine if back button should be shown
  final bool showBackButton =
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
    appBarTitle = buildSourceSelector(
      context,
      ref,
      activeTab,
      tabNotifier,
      isDesktop: isDesktop,
    );
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

    // HN Sort Type (conditionally shown)
    if (!isSearchVisible && activeTab?.initialRouteName == 'hackernews')
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

    // Layout mode toggle (conditional - only shown for catalog or boards)
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
            color: colorScheme.surfaceContainerHigh,
            initialValue: mode,
            onSelected:
                (mode) => ref.read(catalogViewModeProvider.notifier).set(mode),
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
                        ? Icons.grid_view_rounded
                        : Icons.photo_library_rounded,
                    size: 24,
                  ),
                  // Show text label on desktop layouts
                  if (isDesktop) ...[
                    const SizedBox(width: 6),
                    Text(
                      mode == CatalogViewMode.grid ? 'Grid View' : 'Media Feed',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(width: 2),
                    const Icon(Icons.arrow_drop_down, size: 24),
                  ],
                ],
              ),
            ),
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    value: CatalogViewMode.grid,
                    child: Row(
                      children: [
                        Icon(
                          Icons.grid_view_rounded,
                          color:
                              mode == CatalogViewMode.grid
                                  ? colorScheme.primary
                                  : null,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Grid View',
                          style: TextStyle(
                            color:
                                mode == CatalogViewMode.grid
                                    ? colorScheme.primary
                                    : null,
                            fontWeight:
                                mode == CatalogViewMode.grid
                                    ? FontWeight.bold
                                    : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: CatalogViewMode.media,
                    child: Row(
                      children: [
                        Icon(
                          Icons.photo_library_rounded,
                          color:
                              mode == CatalogViewMode.media
                                  ? colorScheme.primary
                                  : null,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Media Feed',
                          style: TextStyle(
                            color:
                                mode == CatalogViewMode.media
                                    ? colorScheme.primary
                                    : null,
                            fontWeight:
                                mode == CatalogViewMode.media
                                    ? FontWeight.bold
                                    : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
          );
        },
      ),

    // More options menu
    if (!isSearchVisible)
      IconButton(
        icon: const Icon(Icons.more_vert),
        tooltip: 'More options',
        onPressed: () => _showMoreOptionsSheet(context),
      ),
  ];

  return AppBar(
    // Only show back button on detail views
    leading:
        showBackButton
            ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => _handleBackButton(ref, activeTab!),
            )
            : null,
    // Set automaticallyImplyLeading to false when we don't show a back button
    automaticallyImplyLeading: showBackButton,
    title: appBarTitle,
    actions: appBarActions,
    backgroundColor: Theme.of(context).colorScheme.surface,
    // On desktop, show elevation to separate from content
    elevation: isDesktop ? 1 : 0,
  );
}

/// Shows a modal bottom sheet with app options
void _showMoreOptionsSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder:
        (context) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  Icons.settings,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                  // Show settings dialog
                  showDialog(
                    context: context,
                    builder:
                        (context) => const AlertDialog(
                          title: Text('Settings'),
                          content: Text('Settings will be implemented soon!'),
                        ),
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                title: const Text('About'),
                onTap: () {
                  Navigator.pop(context);
                  // Show about dialog
                  showAboutDialog(
                    context: context,
                    applicationName: 'VibeChan',
                    applicationVersion: '1.0.0',
                    applicationIcon: const FlutterLogo(),
                    applicationLegalese: '© 2023 VibeChan Team',
                  );
                },
              ),
            ],
          ),
        ),
  );
}

/// Handles back button navigation
void _handleBackButton(WidgetRef ref, ContentTab activeTab) {
  final tabNotifier = ref.read(tabManagerProvider.notifier);

  if (activeTab.initialRouteName == 'thread') {
    // From thread to catalog
    final boardId = activeTab.pathParameters['boardId'] ?? '';
    if (boardId.isNotEmpty) {
      tabNotifier.navigateToOrReplaceActiveTab(
        title: '/$boardId/ - Catalog',
        initialRouteName: 'catalog',
        pathParameters: {'boardId': boardId},
        icon: Icons.view_list,
      );
    }
  } else if (activeTab.initialRouteName == 'hackernews_item') {
    // From HN item to HN stories
    tabNotifier.navigateToOrReplaceActiveTab(
      title: 'Hacker News',
      initialRouteName: 'hackernews',
      icon: Icons.open_in_browser,
    );
  } else if (activeTab.initialRouteName == 'lobsters_story') {
    // From Lobsters story to Lobsters
    tabNotifier.navigateToOrReplaceActiveTab(
      title: 'Lobsters',
      initialRouteName: 'lobsters',
      icon: Icons.open_in_browser,
    );
  }
}

/// Builds the content title bar displayed below the app bar
Widget buildContentTitleBar(BuildContext context, ContentTab activeTab) {
  return Container(
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
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
    child: Text(
      activeTab.title,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
    ),
  );
}
