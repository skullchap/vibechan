import 'package:flutter/material.dart';
import 'package:vibechan/core/domain/models/generic_list_item.dart';

/// Builds 4chan-specific metadata widgets
List<Widget> buildFourchanMetadata(BuildContext context, GenericListItem item) {
  final List<Widget> widgets = [];
  final metadata = item.metadata;
  final colorScheme = Theme.of(context).colorScheme;

  // Add reply count if available
  if (metadata['replies'] != null) {
    widgets.add(
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.forum_outlined,
            size: 12,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(
            metadata['replies'].toString(),
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );

    // Add separator if we have more items
    if (metadata['images'] != null) {
      widgets.add(const SizedBox(width: 12));
    }
  }

  // Add image count if available
  if (metadata['images'] != null) {
    widgets.add(
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.image_outlined,
            size: 12,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(
            metadata['images'].toString(),
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  return widgets;
}
