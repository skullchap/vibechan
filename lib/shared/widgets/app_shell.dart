import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config/app_config.dart';
import '../models/tab_item.dart';
import '../providers/tab_manager_provider.dart';
import 'content_tab_view.dart';

class AppShell extends ConsumerStatefulWidget {
  const AppShell({Key? key}) : super(key: key);

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  @override
  void initState() {
    super.initState();
    // Add the default boards tab if no tabs exist
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tabs = ref.read(tabManagerProvider);
      if (tabs.isEmpty) {
        ref.read(tabManagerProvider.notifier).addTab(
          title: 'Boards',
          route: '/',
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final tabs = ref.watch(tabManagerProvider);
    final activeTab = tabs.isEmpty ? null : tabs.firstWhere(
      (tab) => tab.isActive,
      orElse: () => tabs.first,
    );

    // Determine the appropriate title for the AppBar based on current tab
    String appBarTitle = activeTab?.title ?? AppConfig.appName;
    if (activeTab != null) {
      if (activeTab.route == '/' || activeTab.route == '/boards') {
        appBarTitle = 'Boards';
      } else if (activeTab.route == '/favorites') {
        appBarTitle = 'Favorites';
      } else if (activeTab.route.startsWith('/board/') && !activeTab.route.contains('thread')) {
        final boardId = activeTab.pathParameters['boardId'];
        appBarTitle = '/$boardId/';
      }
      // For thread routes, use the tab title which should contain thread info
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'New Tab',
            onPressed: () {
              ref.read(tabManagerProvider.notifier).addTab(
                title: 'Boards',
                route: '/',
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            tooltip: 'Favorites',
            onPressed: () {
              ref.read(tabManagerProvider.notifier).addTab(
                title: 'Favorites',
                route: '/favorites',
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    AppConfig.appName,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    'v${AppConfig.appVersion}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.color_lens),
              title: const Text('Theme'),
              onTap: () {
                // TODO: Theme settings
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Media Settings'),
              onTap: () {
                // TODO: Media settings
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
              onTap: () {
                // TODO: About page
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Main content area that shows the active tab's content
          Expanded(
            child: activeTab != null
                ? ContentTabView(
                    key: ValueKey(activeTab.id + activeTab.route), // Force rebuild when route changes
                    tab: activeTab
                  )
                : const Center(child: Text('No tabs open')),
          ),
          
          // Tab bar at the bottom
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1.0,
                ),
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final tab in tabs) _buildTabButton(tab),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(TabItem tab) {
    return Container(
      height: 40,
      constraints: const BoxConstraints(minWidth: 120),
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      decoration: BoxDecoration(
        color: tab.isActive
            ? Theme.of(context).colorScheme.secondaryContainer
            : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: () {
          ref.read(tabManagerProvider.notifier).setActiveTab(tab.id);
        },
        onSecondaryTap: () {
          // Right-click to close tab
          ref.read(tabManagerProvider.notifier).removeTab(tab.id);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                tab.icon,
                size: 16,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  tab.title,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: tab.isActive ? FontWeight.bold : null,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              InkWell(
                customBorder: const CircleBorder(),
                onTap: () {
                  ref.read(tabManagerProvider.notifier).removeTab(tab.id);
                },
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(
                    Icons.close,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}