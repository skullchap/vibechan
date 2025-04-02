import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart'; // Remove if not directly used for navigation inside AppShell

import '../../config/app_config.dart';
import '../models/content_tab.dart';
import '../providers/tab_manager_provider.dart';
// Import the screens needed for ContentTabView logic
import '../../features/board/presentation/screens/board_list_screen.dart';
import '../../features/board/presentation/screens/board_catalog_screen.dart';
import '../../features/board/presentation/screens/favorites_screen.dart';
import '../../features/board/presentation/screens/settings_screen.dart';
import '../../features/thread/presentation/screens/thread_detail_screen.dart';

import '../../features/board/presentation/widgets/catalog/catalog_view_mode.dart';

// Revert to ConsumerStatefulWidget
class AppShell extends ConsumerStatefulWidget {
  // Remove child parameter
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  // Internal state management will be reintroduced with TabManager
  // For now, keep it simple or placeholder state
  // int _selectedIndex = 0; // Remove state related to bottom nav index

  // Remove functions related to GoRouter-based bottom nav
  // int _calculateSelectedIndex(BuildContext context) { ... }
  // void _onItemTapped(BuildContext context, int index) { ... }

  @override
  void initState() {
    super.initState();
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
    });
  }

  @override
  Widget build(BuildContext context) {
    final tabs = ref.watch(tabManagerProvider);
    final activeTab = ref.watch(tabManagerProvider.notifier).activeTab;
    final tabNotifier = ref.read(tabManagerProvider.notifier);

    String appBarTitle = activeTab?.title ?? AppConfig.appName;
    // Add actions based on active tab type if needed
    List<Widget> appBarActions = [
      IconButton(
        icon: const Icon(Icons.add),
        tooltip: 'New Boards Tab',
        onPressed: () {
          tabNotifier.addTab(
            title: 'Boards',
            initialRouteName: 'boards',
            icon: Icons.dashboard,
          );
        },
      ),
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
    ];

    return Scaffold(
      appBar: AppBar(title: Text(appBarTitle), actions: appBarActions),
      // Body displays the content for the active tab
      body:
          activeTab != null
              ? _buildTabContent(activeTab) // Use helper to build content
              : const Center(child: Text('No tabs open. Press + to add one.')),

      // Dynamically build the bottom tab bar
      bottomNavigationBar: SafeArea(
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
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  tabs.map((tab) => _buildTabButton(context, tab)).toList(),
            ),
          ),
        ),
      ),
    );
  }

  // Helper to build the content widget for a given tab
  Widget _buildTabContent(ContentTab tab) {
    // Use a unique key for each tab's content to preserve state
    final Key tabKey = ValueKey(tab.id);

    switch (tab.initialRouteName) {
      case 'boards':
        return BoardListScreen(key: tabKey);
      case 'favorites':
        return FavoritesScreen(key: tabKey);
      case 'settings':
        return SettingsScreen(key: tabKey);
      case 'catalog':
        final boardId = tab.pathParameters['boardId'];
        if (boardId != null) {
          return BoardCatalogScreen(key: tabKey, boardId: boardId);
        }
        break; // Fallthrough to error if boardId is null
      case 'thread':
        final boardId = tab.pathParameters['boardId'];
        final threadId = tab.pathParameters['threadId'];
        if (boardId != null && threadId != null) {
          return ThreadDetailScreen(
            key: tabKey,
            boardId: boardId,
            threadId: threadId,
          );
        }
        break; // Fallthrough to error if params are null
    }
    // Handle unknown route or missing parameters
    return Center(
      key: tabKey,
      child: Text(
        'Error: Cannot display content for tab "${tab.title}" (Route: ${tab.initialRouteName})',
      ),
    );
  }

  // Helper to build a single tab button for the bottom bar
  Widget _buildTabButton(BuildContext context, ContentTab tab) {
    final tabNotifier = ref.read(tabManagerProvider.notifier);
    final theme = Theme.of(context);
    final bool isActive = tab.isActive;

    return InkWell(
      onTap: () => tabNotifier.setActiveTab(tab.id),
      child: Container(
        height: 40, // Consistent height
        constraints: const BoxConstraints(
          minWidth: 100,
          maxWidth: 180,
        ), // Control width
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color:
              isActive
                  ? theme.colorScheme.primaryContainer
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, // Don't expand Row unnecessarily
          children: [
            Icon(
              tab.icon,
              size: 16,
              color:
                  isActive
                      ? theme.colorScheme.onPrimaryContainer
                      : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Expanded(
              // Allow text to take available space and ellipsis
              child: Text(
                tab.title,
                style: TextStyle(
                  fontSize: 12,
                  color:
                      isActive
                          ? theme.colorScheme.onPrimaryContainer
                          : theme.colorScheme.onSurfaceVariant,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            // Close Button - Wrap InkWell with Tooltip
            Tooltip(
              message: 'Close Tab',
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => tabNotifier.removeTab(tab.id),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Icon(
                    Icons.close,
                    size: 14,
                    color:
                        isActive
                            ? theme.colorScheme.onPrimaryContainer.withOpacity(
                              0.7,
                            )
                            : theme.colorScheme.onSurfaceVariant.withOpacity(
                              0.7,
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
}
