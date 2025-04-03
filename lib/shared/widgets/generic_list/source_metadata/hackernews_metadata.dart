import 'package:flutter/material.dart';
import 'package:vibechan/core/domain/models/generic_list_item.dart';

/// Builds Hacker News specific metadata widgets
List<Widget> buildHackerNewsMetadata(
  BuildContext context,
  GenericListItem item,
) {
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
            color: colorScheme.secondary,
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
    if (metadata['by'] != null || metadata['descendants'] != null) {
      widgets.add(const SizedBox(width: 12));
    }
  }

  // Add author if available
  if (metadata['by'] != null) {
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
            metadata['by'].toString(),
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );

    // Add separator if comment count is available
    if (metadata['descendants'] != null) {
      widgets.add(const SizedBox(width: 12));
    }
  }

  // Add comment count if available
  if (metadata['descendants'] != null) {
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
            metadata['descendants'].toString(),
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  return widgets;
}
