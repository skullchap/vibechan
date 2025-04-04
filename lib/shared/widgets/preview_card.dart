import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vibechan/features/fourchan/thread/presentation/widgets/post_video.dart';
import 'package:vibechan/shared/widgets/simple_html_renderer.dart';
import 'package:vibechan/shared/models/previewable_item.dart';

class GenericPreviewCard extends StatelessWidget {
  final PreviewableItem item;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final bool fullWidth;
  final bool squareAspect;
  final bool useFullMedia;
  final String? searchQuery;
  final int? orderIndex;

  const GenericPreviewCard({
    super.key,
    required this.item,
    required this.onTap,
    this.onLongPress,
    this.fullWidth = false,
    this.squareAspect = false,
    this.useFullMedia = false,
    this.searchQuery,
    this.orderIndex,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final String? mediaUrl =
        useFullMedia ? item.mediaPreviewUrl : item.thumbnailUrl;
    final double aspectRatio = item.mediaAspectRatio ?? 1.0;

    return Stack(
      children: [
        Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (mediaUrl != null)
                  Card(
                    margin: EdgeInsets.zero,
                    child: AspectRatio(
                      aspectRatio: useFullMedia ? 1 : aspectRatio,
                      child:
                          item.isVideo && item.mediaObject != null
                              ? PostVideo(
                                media: item.mediaObject!,
                                isPreview: true,
                              )
                              : Container(
                                color: colorScheme.surfaceVariant,
                                child: CachedNetworkImage(
                                  imageUrl: mediaUrl,
                                  fit:
                                      useFullMedia
                                          ? BoxFit.cover
                                          : BoxFit.contain,
                                  placeholder:
                                      (context, url) => Shimmer.fromColors(
                                        baseColor:
                                            colorScheme.surfaceContainerHighest,
                                        highlightColor:
                                            colorScheme.surfaceContainerLow,
                                        child: Container(
                                          color:
                                              colorScheme
                                                  .surfaceContainerHighest,
                                        ),
                                      ),
                                  errorWidget:
                                      (context, url, error) => Center(
                                        child: Icon(
                                          Icons.broken_image_outlined,
                                          color: colorScheme.outline,
                                        ),
                                      ),
                                ),
                              ),
                    ),
                  ),

                if (!useFullMedia)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (item.subject != null) ...[
                          if (searchQuery != null && searchQuery!.isNotEmpty)
                            RichText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                children: _getHighlightedSpans(
                                  item.subject!,
                                  textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.onSurface,
                                  ),
                                  searchQuery!,
                                  colorScheme.tertiaryContainer,
                                ),
                              ),
                            )
                          else
                            Text(
                              item.subject!,
                              style: textTheme.titleMedium!.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          const SizedBox(height: 4),
                        ],
                        if (searchQuery != null &&
                            searchQuery!.isNotEmpty &&
                            item.commentSnippet != null)
                          SimpleHtmlRenderer(
                            htmlString: item.commentSnippet ?? '',
                            baseStyle: textTheme.bodyMedium!.copyWith(
                              height: 1.4,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 12,
                            highlightTerms: searchQuery,
                            highlightColor: colorScheme.tertiaryContainer,
                          )
                        else if (item.commentSnippet != null)
                          SimpleHtmlRenderer(
                            htmlString: item.commentSnippet!,
                            baseStyle: textTheme.bodyMedium!.copyWith(
                              height: 1.4,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 12,
                          ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 12.0,
                          runSpacing: 4.0,
                          children:
                              item.stats.map((stat) {
                                final statWidget = Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      stat.icon,
                                      size: 16,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                    if (stat.value.isNotEmpty) ...[
                                      const SizedBox(width: 4),
                                      Text(
                                        stat.value,
                                        style: textTheme.bodySmall?.copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ],
                                );
                                if (stat.tooltip != null) {
                                  return Tooltip(
                                    message: stat.tooltip!,
                                    child: statWidget,
                                  );
                                } else {
                                  return statWidget;
                                }
                              }).toList(),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (orderIndex != null && orderIndex! > 0)
          Positioned(
            top: 4,
            right: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '#${orderIndex}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onTertiaryContainer,
                ),
              ),
            ),
          ),
      ],
    );
  }

  List<InlineSpan> _getHighlightedSpans(
    String text,
    TextStyle style,
    String searchTerms,
    Color highlightColor,
  ) {
    if (searchTerms.isEmpty) return [TextSpan(text: text, style: style)];

    final List<InlineSpan> result = [];
    final RegExp regExp = RegExp(
      searchTerms
          .split(' ')
          .where((term) => term.isNotEmpty)
          .map((term) {
            return RegExp.escape(term);
          })
          .join('|'),
      caseSensitive: false,
    );

    int lastMatchEnd = 0;
    for (final match in regExp.allMatches(text)) {
      if (match.start > lastMatchEnd) {
        result.add(
          TextSpan(
            text: text.substring(lastMatchEnd, match.start),
            style: style,
          ),
        );
      }
      result.add(
        TextSpan(
          text: text.substring(match.start, match.end),
          style: style.copyWith(
            backgroundColor: highlightColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
      lastMatchEnd = match.end;
    }
    if (lastMatchEnd < text.length) {
      result.add(TextSpan(text: text.substring(lastMatchEnd), style: style));
    }
    return result;
  }
}
