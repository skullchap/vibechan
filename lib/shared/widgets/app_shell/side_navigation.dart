import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/content_tab.dart';
import '../../providers/tab_manager_provider.dart';
import 'source_selector.dart';

/// Builds the side navigation drawer for larger screens
Widget buildSideNavigation(
  BuildContext context,
  WidgetRef ref,
  List<ContentTab> tabs,
  ContentTab? activeTab,
  TabManagerNotifier tabNotifier,
) {
  return Container(
    width: 280,
    color: Theme.of(context).colorScheme.surface,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        // Source selector at the top
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: buildSideSourceSelector(context, ref, tabNotifier),
        ),
        const Divider(),

        // Tab list label
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Open Tabs',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),

        // Tab list
        Expanded(
          child:
              tabs.isEmpty
                  ? _buildEmptyTabsMessage(context)
                  : _buildTabsList(context, tabs, activeTab, tabNotifier),
        ),
      ],
    ),
  );
}

/// Builds a message for when there are no open tabs
Widget _buildEmptyTabsMessage(BuildContext context) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.tab_unselected,
          size: 48,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(height: 16),
        Text('No open tabs', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Text(
          'Select a source to get started',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    ),
  );
}

/// Builds the list of open tabs
Widget _buildTabsList(
  BuildContext context,
  List<ContentTab> tabs,
  ContentTab? activeTab,
  TabManagerNotifier tabNotifier,
) {
  return ReorderableListView.builder(
    itemCount: tabs.length,
    onReorder: (oldIndex, newIndex) {
      tabNotifier.reorderTab(oldIndex, newIndex);
    },
    itemBuilder: (context, index) {
      final tab = tabs[index];
      final isActive = tab.id == activeTab?.id;

      return Material(
        key: ValueKey(tab.id),
        color:
            isActive
                ? Theme.of(context).colorScheme.secondaryContainer
                : Colors.transparent,
        child: ListTile(
          leading: Icon(
            tab.icon,
            color:
                isActive
                    ? Theme.of(context).colorScheme.onSecondaryContainer
                    : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          title: Text(
            tab.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color:
                  isActive
                      ? Theme.of(context).colorScheme.onSecondaryContainer
                      : Theme.of(context).colorScheme.onSurface,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          onTap: () => tabNotifier.setActiveTab(tab.id),
          trailing: IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: () => tabNotifier.removeTab(tab.id),
            tooltip: 'Close tab',
          ),
        ),
      );
    },
  );
}
