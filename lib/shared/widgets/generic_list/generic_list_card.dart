import 'package:flutter/material.dart';
import 'package:vibechan/core/domain/models/generic_list_item.dart';
import 'package:vibechan/shared/widgets/simple_html_renderer.dart';
import 'text_highlighter.dart';

import 'media_section.dart';
import 'metadata_row.dart';

/// A card that displays content from various sources in a unified format
class GenericListCardImpl extends StatelessWidget {
  final GenericListItem item;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final bool useFullMedia;
  final String? searchQuery;
  final Color? highlightColor;

  const GenericListCardImpl({
    super.key,
    required this.item,
    required this.onTap,
    this.onLongPress,
    this.useFullMedia = false,
    this.searchQuery,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final displayImageUrl = useFullMedia ? item.mediaUrl : item.thumbnailUrl;
    final hasMedia = displayImageUrl != null;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasMedia) MediaSection(imageUrl: displayImageUrl!),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title with optional highlighting
                  if (item.title != null && item.title!.isNotEmpty) ...[
                    if (searchQuery != null && searchQuery!.isNotEmpty)
                      Text.rich(
                        buildHighlightedTextSpan(
                          text: item.title!,
                          baseStyle: textTheme.titleMedium,
                          searchQuery: searchQuery!,
                          highlightColor:
                              highlightColor ??
                              colorScheme.primaryContainer.withOpacity(0.5),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )
                    else
                      Text(
                        item.title!,
                        style: textTheme.titleMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 6),
                  ],

                  // Body with HTML rendering and highlighting
                  if (item.body != null && item.body!.isNotEmpty)
                    SimpleHtmlRenderer(
                      htmlString: item.body ?? '',
                      baseStyle: textTheme.bodyMedium,
                      highlightTerms: searchQuery,
                      highlightColor: highlightColor,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),

                  const SizedBox(height: 8),

                  // Source-specific metadata row
                  MetadataRow(item: item),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
