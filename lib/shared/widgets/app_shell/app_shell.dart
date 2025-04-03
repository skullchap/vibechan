import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/layout_service.dart';
import '../../providers/search_provider.dart';
import '../../providers/tab_manager_provider.dart';
import 'app_bar_builder.dart';
import 'content_tab_view.dart';
import 'side_navigation.dart';
import 'tab_bar_builder.dart';

// Provider to maintain consistency in the navigation display style
final sideNavigationVisibleProvider = StateProvider<bool>((ref) => false);

/// Main application shell that manages layout, navigation and content display
class AppShellImpl extends ConsumerStatefulWidget {
  const AppShellImpl({super.key});

  @override
  ConsumerState<AppShellImpl> createState() => _AppShellImplState();
}

class _AppShellImplState extends ConsumerState<AppShellImpl>
    with WidgetsBindingObserver {
  late final ScrollController _tabScrollController;

  @override
  void initState() {
    super.initState();
    _tabScrollController = ScrollController();
    WidgetsBinding.instance.addObserver(this);

    // Initialize the layout state based on current context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(layoutStateNotifierProvider.notifier).updateLayout(context);
    });
  }

  @override
  void dispose() {
    _tabScrollController.dispose();
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
    final colorScheme = Theme.of(context).colorScheme;

    // Read current layout state
    final layoutState = ref.watch(layoutStateNotifierProvider);
    final currentLayout = layoutState.currentLayout;
    final layoutService = ref.read(layoutServiceProvider);

    // Get layout service instance
    final useSideNavigation = layoutService.shouldShowSidePanel(currentLayout);
    final sideNavWidth = layoutService.getSidePanelWidth(currentLayout);

    // Listen to search state changes
    final isSearchVisible = ref.watch(searchVisibleProvider);

    // Create the side drawer content
    final sideNavigationContent = buildSideNavigation(
      context,
      ref,
      tabs,
      activeTab,
      tabNotifier,
    );

    return Scaffold(
      appBar: buildAppBar(context, ref, activeTab, isSearchVisible),
      drawer:
          !useSideNavigation
              ? Drawer(
                backgroundColor: colorScheme.surface,
                elevation: 1,
                child: sideNavigationContent,
              )
              : null,
      body: Row(
        children: [
          // Side navigation for desktop as a permanent drawer
          if (useSideNavigation)
            Container(
              width: sideNavWidth,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(1, 0),
                  ),
                ],
              ),
              child: sideNavigationContent,
            ),

          // Main content area
          Expanded(
            child: Column(
              children: [
                // Secondary app bar for content title
                if (activeTab != null && !isSearchVisible)
                  buildContentTitleBar(context, activeTab),

                // Main content
                Expanded(
                  child:
                      activeTab != null
                          ? ContentTabView(tab: activeTab)
                          : Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.tab_unselected_rounded,
                                  size: 48,
                                  color: colorScheme.onSurfaceVariant
                                      .withOpacity(0.5),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No tabs open',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Select a source from the dropdown above',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant
                                        .withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                ),
              ],
            ),
          ),
        ],
      ),
      // Bottom tab bar for mobile layout
      bottomNavigationBar:
          !useSideNavigation
              ? buildTabBar(context, ref, tabs, activeTab, _tabScrollController)
              : null,
    );
  }
}
