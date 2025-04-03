import 'package:flutter/material.dart';
import 'package:vibechan/core/domain/models/generic_list_item.dart';
import 'package:vibechan/core/utils/time_utils.dart';

import 'source_metadata/fourchan_metadata.dart';
import 'source_metadata/hackernews_metadata.dart';
import 'source_metadata/lobsters_metadata.dart';

/// Displays source-specific metadata for a generic list item
class MetadataRow extends StatelessWidget {
  final GenericListItem item;

  const MetadataRow({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    // Choose the appropriate metadata widgets based on source
    final metadataWidgets = _buildMetadataWidgets(context);

    return DefaultTextStyle(
      style: Theme.of(context).textTheme.bodySmall ?? const TextStyle(),
      child: Row(children: metadataWidgets),
    );
  }

  List<Widget> _buildMetadataWidgets(BuildContext context) {
    final List<Widget> widgets = [];

    // Add source-specific metadata
    switch (item.source) {
      case ItemSource.fourchan:
        widgets.addAll(buildFourchanMetadata(context, item));
        break;
      case ItemSource.hackernews:
        widgets.addAll(buildHackerNewsMetadata(context, item));
        break;
      case ItemSource.lobsters:
        widgets.addAll(buildLobstersMetadata(context, item));
        break;
      case ItemSource.reddit:
        // TODO: Add Reddit metadata when implemented
        break;
    }

    // Add timestamp if available
    if (item.timestamp != null) {
      // Add spacer if there are other widgets
      if (widgets.isNotEmpty) {
        widgets.add(const Spacer());
      }

      widgets.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.access_time,
              size: 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 4),
            Text(
              formatTimeAgoSimple(item.timestamp!),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return widgets;
  }
}
