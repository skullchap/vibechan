import 'package:flutter/material.dart';
import 'package:vibechan/core/domain/models/generic_list_item.dart';

/// Builds Lobsters specific metadata widgets
List<Widget> buildLobstersMetadata(BuildContext context, GenericListItem item) {
  final List<Widget> widgets = [];
  final metadata = item.metadata;
  final colorScheme = Theme.of(context).colorScheme;

  // Add score if available
  if (metadata['score'] != null) {
    widgets.add(
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.arrow_upward_rounded,
            size: 12,
            color: colorScheme.error, // Lobsters uses red
          ),
          const SizedBox(width: 4),
          Text(
            metadata['score'].toString(),
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );

    // Add separator if more items
    if (metadata['submitterUsername'] != null ||
        metadata['commentCount'] != null) {
      widgets.add(const SizedBox(width: 12));
    }
  }

  // Add author if available
  if (metadata['submitterUsername'] != null) {
    widgets.add(
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.person_outline_rounded,
            size: 12,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(
            metadata['submitterUsername'].toString(),
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );

    // Add separator if comment count is available
    if (metadata['commentCount'] != null) {
      widgets.add(const SizedBox(width: 12));
    }
  }

  // Add comment count if available
  if (metadata['commentCount'] != null) {
    widgets.add(
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.comment_outlined,
            size: 12,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(
            metadata['commentCount'].toString(),
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  // Add tags if available
  if (metadata['tags'] != null &&
      metadata['tags'] is List &&
      (metadata['tags'] as List).isNotEmpty) {
    final tags = metadata['tags'] as List;
    if (tags.isNotEmpty) {
      // Add a separator
      widgets.add(const SizedBox(width: 12));

      // Display first tag only to save space
      widgets.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: colorScheme.tertiaryContainer,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            tags.first.toString(),
            style: TextStyle(
              fontSize: 10,
              color: colorScheme.onTertiaryContainer,
            ),
          ),
        ),
      );

      // If there are more tags, add a count indicator
      if (tags.length > 1) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              '+${tags.length - 1}',
              style: TextStyle(
                fontSize: 10,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        );
      }
    }
  }

  return widgets;
}
