import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/content_tab.dart';
import '../../providers/tab_manager_provider.dart';

// Helper to build a single tab button (moved here)
Widget _buildTabButton(
  BuildContext context,
  WidgetRef ref,
  ContentTab tab,
  bool isActive,
) {
  final ColorScheme colorScheme = Theme.of(context).colorScheme;
  final TextTheme textTheme = Theme.of(context).textTheme;

  return Material(
    key: ValueKey(tab.id),
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
            // Close button
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap:
                  () => ref.read(tabManagerProvider.notifier).removeTab(tab.id),
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

class AppShellBottomTabBar extends ConsumerWidget {
  final List<ContentTab> tabs;
  final ContentTab? activeTab;
  final ScrollController tabScrollController;
  final Function(int, int) onReorder;

  const AppShellBottomTabBar({
    super.key,
    required this.tabs,
    required this.activeTab,
    required this.tabScrollController,
    required this.onReorder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 50, // Adjust height as needed
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color:
            colorScheme.surfaceContainerLow, // Use Material 3 surface container
        border: Border(
          top: BorderSide(color: colorScheme.outlineVariant, width: 0.5),
        ),
      ),
      // Add Listener to intercept scroll wheel events
      child: Listener(
        onPointerSignal: (pointerSignal) {
          if (pointerSignal is PointerScrollEvent) {
            final double scrollAmount = pointerSignal.scrollDelta.dy;
            final double sensitivity = 30.0; // Adjust scroll sensitivity

            if (scrollAmount.abs() > 0) {
              double newOffset =
                  tabScrollController.offset -
                  (scrollAmount.sign * sensitivity);

              // Clamp the offset
              newOffset = newOffset.clamp(
                tabScrollController.position.minScrollExtent,
                tabScrollController.position.maxScrollExtent,
              );
              tabScrollController.animateTo(
                newOffset,
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeOut,
              );
            }
          }
        },
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: tabScrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          child: ReorderableListView.builder(
            key: const Key('tab-reorderable-list'),
            scrollDirection: Axis.horizontal,
            buildDefaultDragHandles: false,
            itemCount: tabs.length,
            // Don't use the ScrollController here since we're using SingleChildScrollView
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final tab = tabs[index];
              final bool isActive = activeTab?.id == tab.id;
              // Wrap the button with ReorderableDragStartListener
              return ReorderableDragStartListener(
                key: ValueKey(tab.id), // Key for reordering logic
                index: index,
                child: _buildTabButton(context, ref, tab, isActive),
              );
            },
            onReorder: onReorder,
            proxyDecorator: (
              Widget child,
              int index,
              Animation<double> animation,
            ) {
              return Material(
                elevation: 4.0,
                color: Colors.transparent,
                child: ScaleTransition(
                  scale: animation.drive(Tween<double>(begin: 1.0, end: 1.05)),
                  child: child,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
