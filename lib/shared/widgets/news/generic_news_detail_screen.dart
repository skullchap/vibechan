import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibechan/core/utils/time_utils.dart';
import 'package:vibechan/shared/enums/news_source.dart';
import 'package:vibechan/shared/providers/search_provider.dart';
import 'package:vibechan/shared/widgets/simple_html_renderer.dart';

/// A generic news detail screen that can be used for any news source
class GenericNewsDetailScreen extends ConsumerWidget {
  final NewsSource source;
  final AsyncValue<dynamic> itemDetailAsync;
  final Future<void> Function() onRefresh;
  final bool isRefreshing;
  final String? commentTextFieldName;

  const GenericNewsDetailScreen({
    super.key,
    required this.source,
    required this.itemDetailAsync,
    required this.onRefresh,
    this.isRefreshing = false,
    this.commentTextFieldName = 'text',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // Define margin colors based on theme
    final List<Color> marginColors = [
      theme.colorScheme.primary,
      theme.colorScheme.secondary,
      theme.colorScheme.tertiary,
      theme.colorScheme.error,
    ];

    // Get search state
    final isSearchActive = ref.watch(searchVisibleProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    // Container for background and positioning
    return Container(
      color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
      child: Stack(
        children: [
          itemDetailAsync.when(
            data: (item) {
              // Get comments based on source
              _getCommentsFromItem(item);
              final flattenedComments = _flattenCommentsWithDepth(item);

              return RefreshIndicator(
                onRefresh: onRefresh,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 6.0,
                  ),
                  itemCount: 1 + flattenedComments.length,
                  separatorBuilder:
                      (context, index) => const SizedBox(height: 6),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      // Story/Item Header Card
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Add refresh button at the top
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton.icon(
                                icon: const Icon(Icons.refresh),
                                label: const Text('Refresh'),
                                onPressed: isRefreshing ? null : onRefresh,
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),
                          Card(
                            elevation: 1,
                            clipBehavior: Clip.antiAlias,
                            margin: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: _buildItemHeader(
                              context,
                              item,
                              theme,
                              isSearchActive ? searchQuery : null,
                            ),
                          ),
                        ],
                      );
                    } else {
                      // Comment Card from flattened list
                      final entry = flattenedComments[index - 1];
                      final depth = entry.key;
                      final comment = entry.value;
                      final colorIndex = depth % marginColors.length;
                      final marginColor = marginColors[colorIndex];
                      final double indentation = depth * 10.0;

                      // Skip deleted/dead comments if appropriate
                      final isCommentValid = _isValidComment(comment);
                      if (!isCommentValid) {
                        return const SizedBox.shrink();
                      }

                      return Padding(
                        padding: EdgeInsets.only(left: indentation),
                        child: Card(
                          elevation: 1,
                          clipBehavior: Clip.antiAlias,
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: _buildCommentItem(
                            comment,
                            theme,
                            marginColor,
                            isSearchActive ? searchQuery : null,
                          ),
                        ),
                      );
                    }
                  },
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error:
                (error, stack) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        Text('Error loading item: $error'),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.refresh),
                          label: const Text('Try Again'),
                          onPressed: onRefresh,
                        ),
                      ],
                    ),
                  ),
                ),
          ),
          // Overlay loading indicator during refresh
          if (isRefreshing)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }

  // Helper method to flatten comments with depth for display
  List<MapEntry<int, dynamic>> _flattenCommentsWithDepth(dynamic item) {
    final List<MapEntry<int, dynamic>> flattenedList = [];

    void traverse(List<dynamic>? comments, int depth) {
      if (comments == null || comments.isEmpty) return;

      for (final comment in comments) {
        // For Lobsters, use the depth from the model
        final actualDepth =
            source == NewsSource.lobsters && comment.depth != null
                ? comment.depth
                : depth;

        // Add to list regardless of visibility status - we'll filter in the builder
        flattenedList.add(MapEntry(actualDepth, comment));

        // Get replies/children based on source
        List<dynamic>? replies;

        switch (source) {
          case NewsSource.hackernews:
            replies = comment.comments;
            break;
          case NewsSource.lobsters:
            // Check if this comment has children (nested comments)
            replies = comment.comments;
            break;
          case NewsSource.reddit:
            replies = comment.replies;
            break;
        }

        // Recursively traverse children for all sources
        traverse(replies, depth + 1);
      }
    }

    // Special case for Lobsters: comments are already flattened but with depth info
    if (source == NewsSource.lobsters) {
      final comments = _getCommentsFromItem(item);
      if (comments != null) {
        for (final comment in comments) {
          flattenedList.add(MapEntry(comment.depth, comment));
        }
      }
      return flattenedList;
    }

    // For other sources, use the recursive approach
    traverse(_getCommentsFromItem(item), 0);
    return flattenedList;
  }

  // Helper to get comments from different item types
  List<dynamic>? _getCommentsFromItem(dynamic item) {
    switch (source) {
      case NewsSource.hackernews:
        return item.comments;
      case NewsSource.lobsters:
        return item.comments;
      case NewsSource.reddit:
        return item.comments;
    }
  }

  // Helper to check if a comment is valid (not deleted/removed)
  bool _isValidComment(dynamic comment) {
    switch (source) {
      case NewsSource.hackernews:
        return !comment.deleted && !comment.dead;
      case NewsSource.lobsters:
        // Lobsters doesn't seem to have dead/deleted comments in API
        return true;
      case NewsSource.reddit:
        // Reddit might have [deleted] or [removed] comments
        return comment.body != "[deleted]" && comment.body != "[removed]";
    }
  }

  // Build the header for the item based on source
  Widget _buildItemHeader(
    BuildContext context,
    dynamic item,
    ThemeData theme,
    String? searchQuery,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // URL section for all sources
          if (_getItemUrl(item) != null && _getItemUrl(item)!.isNotEmpty)
            InkWell(
              child: Text(
                Uri.tryParse(_getItemUrl(item)!)?.host ?? _getItemUrl(item)!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              onTap: () async {
                final uri = Uri.tryParse(_getItemUrl(item)!);
                if (uri != null && await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
            ),
          if (_getItemUrl(item) != null && _getItemUrl(item)!.isNotEmpty)
            const SizedBox(height: 12),

          // Metadata row - score, user, time
          DefaultTextStyle(
            style: theme.textTheme.bodyMedium!.copyWith(
              color: theme.textTheme.bodyMedium!.color?.withOpacity(0.8),
            ),
            child: Row(
              children: [
                if (_getItemScore(item) != null) ...[
                  Icon(
                    Icons.arrow_upward_rounded,
                    size: 16,
                    color: theme.colorScheme.secondary,
                  ),
                  const SizedBox(width: 3),
                  Text('${_getItemScore(item)}'),
                  const SizedBox(width: 12),
                ],
                Icon(Icons.person_outline_rounded, size: 16),
                const SizedBox(width: 3),
                Text(_getItemAuthor(item)),
                const SizedBox(width: 12),
                Icon(Icons.access_time_rounded, size: 16),
                const SizedBox(width: 3),
                Text(formatTimeAgoSimple(_getItemTimestamp(item))),
              ],
            ),
          ),

          // Item description/text if exists
          if (_getItemBody(item) != null && _getItemBody(item)!.isNotEmpty) ...[
            const Divider(height: 24, thickness: 0.5),
            SimpleHtmlRenderer(
              htmlString: _getItemBody(item)!,
              baseStyle: theme.textTheme.bodyLarge,
              highlightTerms: searchQuery,
              highlightColor: theme.colorScheme.primaryContainer.withOpacity(
                0.5,
              ),
            ),
          ],

          // Tags if available
          if (_getItemTags(item) != null && _getItemTags(item)!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children:
                    _getItemTags(item)!
                        .map(
                          (tag) => Chip(
                            label: Text(tag),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                          ),
                        )
                        .toList(),
              ),
            ),
        ],
      ),
    );
  }

  // Build a comment item based on source
  Widget _buildCommentItem(
    dynamic comment,
    ThemeData theme,
    Color marginColor,
    String? searchQuery,
  ) {
    return Stack(
      children: [
        // Left margin indicator
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          width: 4,
          child: Container(color: marginColor),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Comment header with author and time
              Row(
                children: [
                  Text(
                    _getCommentAuthor(comment),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    formatTimeAgoSimple(_getCommentTimestamp(comment)),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall!.color?.withOpacity(0.7),
                    ),
                  ),
                  if (_getCommentScore(comment) != null) ...[
                    const SizedBox(width: 8),
                    Icon(
                      Icons.arrow_upward_rounded,
                      size: 14,
                      color: theme.colorScheme.secondary,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${_getCommentScore(comment)}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              // Comment body with search highlighting
              SimpleHtmlRenderer(
                htmlString: _getCommentBody(comment),
                baseStyle: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
                highlightTerms: searchQuery,
                highlightColor: theme.colorScheme.secondaryContainer
                    .withOpacity(0.5),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Helper methods to get item properties across different sources

  String? _getItemUrl(dynamic item) {
    switch (source) {
      case NewsSource.hackernews:
        return item.url;
      case NewsSource.lobsters:
        return item.url;
      case NewsSource.reddit:
        return item.url;
    }
  }

  int? _getItemScore(dynamic item) {
    switch (source) {
      case NewsSource.hackernews:
        return item.score;
      case NewsSource.lobsters:
        return item.score;
      case NewsSource.reddit:
        return item.score;
    }
  }

  String _getItemAuthor(dynamic item) {
    switch (source) {
      case NewsSource.hackernews:
        return item.by ?? 'anonymous';
      case NewsSource.lobsters:
        return item.submitterUser;
      case NewsSource.reddit:
        return item.author ?? 'anonymous';
    }
  }

  DateTime _getItemTimestamp(dynamic item) {
    switch (source) {
      case NewsSource.hackernews:
        // HackerNews returns Unix timestamp in seconds
        if (item.time is int) {
          return DateTime.fromMillisecondsSinceEpoch(item.time * 1000);
        }
        return item.time ?? DateTime.now();
      case NewsSource.lobsters:
        return item.createdAt;
      case NewsSource.reddit:
        return item.createdAt ?? DateTime.now();
    }
  }

  String? _getItemBody(dynamic item) {
    switch (source) {
      case NewsSource.hackernews:
        return item.text;
      case NewsSource.lobsters:
        return item.description;
      case NewsSource.reddit:
        return item.selftext;
    }
  }

  List<String>? _getItemTags(dynamic item) {
    switch (source) {
      case NewsSource.hackernews:
        return null; // HN doesn't have tags
      case NewsSource.lobsters:
        return item.tags;
      case NewsSource.reddit:
        return item.flairs != null ? [item.flairs] : null;
    }
  }

  // Helper methods to get comment properties across different sources

  String _getCommentAuthor(dynamic comment) {
    switch (source) {
      case NewsSource.hackernews:
        return comment.by ?? 'anonymous';
      case NewsSource.lobsters:
        return comment.commentingUser ?? 'anonymous';
      case NewsSource.reddit:
        return comment.author ?? 'anonymous';
    }
  }

  DateTime _getCommentTimestamp(dynamic comment) {
    switch (source) {
      case NewsSource.hackernews:
        // HackerNews returns Unix timestamp in seconds
        if (comment.time is int) {
          return DateTime.fromMillisecondsSinceEpoch(comment.time * 1000);
        }
        return comment.time ?? DateTime.now();
      case NewsSource.lobsters:
        return comment.createdAt;
      case NewsSource.reddit:
        return comment.createdAt ?? DateTime.now();
    }
  }

  int? _getCommentScore(dynamic comment) {
    switch (source) {
      case NewsSource.hackernews:
        return null; // HN doesn't show comment scores
      case NewsSource.lobsters:
        return comment.score;
      case NewsSource.reddit:
        return comment.score;
    }
  }

  String _getCommentBody(dynamic comment) {
    switch (source) {
      case NewsSource.hackernews:
        return comment.text ?? '';
      case NewsSource.lobsters:
        return comment.comment ?? '';
      case NewsSource.reddit:
        return comment.body ?? '';
    }
  }
}
