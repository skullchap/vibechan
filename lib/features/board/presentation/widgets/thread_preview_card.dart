import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vibechan/core/domain/models/media.dart';
import 'package:vibechan/core/domain/models/thread.dart';
import 'package:vibechan/features/thread/presentation/widgets/post_video.dart';
import 'package:vibechan/shared/widgets/simple_html_renderer.dart';
import 'package:vibechan/shared/providers/search_provider.dart';

class ThreadPreviewCard extends StatelessWidget {
  final Thread thread;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final bool fullWidth;
  final bool squareAspect;
  final bool useFullMedia;
  final String? searchQuery;

  const ThreadPreviewCard({
    super.key,
    required this.thread,
    required this.onTap,
    this.onLongPress,
    this.fullWidth = false,
    this.squareAspect = false,
    this.useFullMedia = false,
    this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    final originalPost = thread.originalPost;
    final media = originalPost.media;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (media != null)
              Card(
                margin: EdgeInsets.zero,
                child: AspectRatio(
                  aspectRatio:
                      useFullMedia
                          ? 1
                          : (media.width > 0 && media.height > 0
                              ? media.width / media.height
                              : 1.0),
                  child:
                      media.type == MediaType.video
                          ? PostVideo(media: media, isPreview: true)
                          : Container(
                            color: colorScheme.surfaceVariant,
                            child: CachedNetworkImage(
                              imageUrl:
                                  useFullMedia ? media.url : media.thumbnailUrl,
                              fit: useFullMedia ? BoxFit.cover : BoxFit.contain,
                              placeholder:
                                  (context, url) => Shimmer.fromColors(
                                    baseColor:
                                        colorScheme.surfaceContainerHighest,
                                    highlightColor:
                                        colorScheme.surfaceContainerLow,
                                    child: Container(
                                      color:
                                          colorScheme.surfaceContainerHighest,
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
                    if (originalPost.subject != null) ...[
                      if (searchQuery != null && searchQuery!.isNotEmpty)
                        RichText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            children: _getHighlightedSpans(
                              originalPost.subject!,
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
                          originalPost.subject!,
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
                        originalPost.comment != null)
                      SimpleHtmlRenderer(
                        htmlString: originalPost.comment ?? '',
                        baseStyle: textTheme.bodyMedium!.copyWith(
                          height: 1.4,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 12,
                        highlightTerms: searchQuery,
                        highlightColor: colorScheme.tertiaryContainer,
                      )
                    else
                      SimpleHtmlRenderer(
                        htmlString: originalPost.comment ?? '',
                        baseStyle: textTheme.bodyMedium!.copyWith(
                          height: 1.4,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.comment, size: 16),
                        const SizedBox(width: 4),
                        Text('${thread.repliesCount}'),
                        const SizedBox(width: 16),
                        const Icon(Icons.image, size: 16),
                        const SizedBox(width: 4),
                        Text('${thread.imagesCount}'),
                        if (thread.isSticky) ...[
                          const SizedBox(width: 16),
                          const Icon(Icons.push_pin, size: 16),
                        ],
                        if (thread.isClosed) ...[
                          const SizedBox(width: 16),
                          const Icon(Icons.lock, size: 16),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
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
      // Add text before the match
      if (match.start > lastMatchEnd) {
        result.add(
          TextSpan(
            text: text.substring(lastMatchEnd, match.start),
            style: style,
          ),
        );
      }

      // Add the highlighted match
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

    // Add remaining text after the last match
    if (lastMatchEnd < text.length) {
      result.add(TextSpan(text: text.substring(lastMatchEnd), style: style));
    }

    return result;
  }
}
