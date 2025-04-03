import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/content_tab.dart';
import '../../providers/tab_manager_provider.dart';

/// Builds the bottom tab bar for mobile layout
Widget buildTabBar(
  BuildContext context,
  WidgetRef ref,
  List<ContentTab> tabs,
  ContentTab? activeTab,
  ScrollController tabScrollController,
) {
  final colorScheme = Theme.of(context).colorScheme;

  return SafeArea(
    child: Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        border: Border(
          top: BorderSide(color: colorScheme.outlineVariant, width: 0.5),
        ),
      ),
      // Handle mouse wheel scroll for tabs
      child: Listener(
        onPointerSignal: (pointerSignal) {
          if (pointerSignal is PointerScrollEvent) {
            final scrollAmount = pointerSignal.scrollDelta.dy;
            final sensitivity = 30.0;

            if (scrollAmount.abs() > 0) {
              double newOffset =
                  tabScrollController.offset -
                  (scrollAmount.sign * sensitivity);

              // Clamp the offset to prevent overscrolling
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
        child: ReorderableListView.builder(
          key: const Key('tab-reorderable-list'),
          scrollController: tabScrollController,
          scrollDirection: Axis.horizontal,
          buildDefaultDragHandles: false,
          itemCount: tabs.length,
          itemBuilder: (context, index) {
            final tab = tabs[index];
            return KeyedSubtree(
              key: ValueKey(tab.id),
              child: ReorderableDragStartListener(
                index: index,
                child: _buildTabButton(context, tab, activeTab, ref),
              ),
            );
          },
          onReorder: (oldIndex, newIndex) {
            ref
                .read(tabManagerProvider.notifier)
                .reorderTab(oldIndex, newIndex);
          },
          proxyDecorator: (child, index, animation) {
            // Visual feedback for dragging
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

/// Builds an individual tab button for the bottom tab bar
Widget _buildTabButton(
  BuildContext context,
  ContentTab tab,
  ContentTab? activeTab,
  WidgetRef ref,
) {
  final colorScheme = Theme.of(context).colorScheme;
  final tabNotifier = ref.read(tabManagerProvider.notifier);
  final isActive = tab.id == activeTab?.id;

  return AnimatedContainer(
    duration: const Duration(milliseconds: 200),
    margin: const EdgeInsets.symmetric(horizontal: 2),
    decoration: BoxDecoration(
      color: isActive ? colorScheme.secondaryContainer : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
    ),
    child: InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => tabNotifier.setActiveTab(tab.id),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        constraints: const BoxConstraints(minWidth: 100),
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
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                tab.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color:
                      isActive
                          ? colorScheme.onSecondaryContainer
                          : colorScheme.onSurface,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            const SizedBox(width: 4),
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => tabNotifier.removeTab(tab.id),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(
                  Icons.close,
                  size: 14,
                  color:
                      isActive
                          ? colorScheme.onSecondaryContainer
                          : colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
