import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibechan/shared/enums/news_source.dart';
import 'package:vibechan/shared/providers/search_provider.dart';
import 'package:vibechan/features/reddit/domain/models/reddit_post.dart';
import 'package:vibechan/features/reddit/domain/models/reddit_comment.dart';

// Import the extracted public widgets
import 'news_comment_item.dart';
import 'news_item_header.dart';

/// A generic news detail screen that can be used for any news source
class GenericNewsDetailScreen extends ConsumerWidget {
  final NewsSource source;
  final AsyncValue<dynamic> itemDetailAsync;
  final Future<void> Function() onRefresh;
  final bool isRefreshing;

  const GenericNewsDetailScreen({
    super.key,
    required this.source,
    required this.itemDetailAsync,
    required this.onRefresh,
    this.isRefreshing = false,
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

    return Container(
      color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
      child: Stack(
        children: [
          itemDetailAsync.when(
            data: (item) {
              final flattenedComments = _flattenCommentsWithDepth(item);
              final itemData = _getActualItemData(
                item,
              ); // Helper to get HN/Lobster/RedditPost

              if (itemData == null && source == NewsSource.reddit) {
                // Handle case where Reddit data isn't the expected tuple
                return _buildErrorView(context, 'Invalid post data format');
              }
              if (itemData == null) {
                // Handle generic error case
                return _buildErrorView(context, 'Invalid item data');
              }

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
                      // Use the extracted NewsItemHeader widget (Constructor call)
                      return NewsItemHeader(
                        item: itemData,
                        source: source,
                        theme: theme,
                        searchQuery: isSearchActive ? searchQuery : null,
                        onRefresh: onRefresh,
                        isRefreshing: isRefreshing,
                      );
                    } else {
                      final entry = flattenedComments[index - 1];
                      final depth = entry.key;
                      final comment = entry.value;
                      final colorIndex = depth % marginColors.length;
                      final marginColor = marginColors[colorIndex];
                      final double indentation = depth * 10.0;

                      if (!_isValidComment(comment)) {
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
                          // Use the extracted NewsCommentItem widget (Constructor call)
                          child: NewsCommentItem(
                            comment: comment,
                            source: source,
                            theme: theme,
                            marginColor: marginColor,
                            searchQuery: isSearchActive ? searchQuery : null,
                          ),
                        ),
                      );
                    }
                  },
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => _buildErrorView(context, error),
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
    final comments = _getCommentsFromItem(item);

    if (source == NewsSource.lobsters) {
      // Lobsters provides depth directly in its flat comment list
      if (comments != null) {
        for (final comment in comments) {
          // Ensure we handle potential null depth from API
          final depth = (comment.depth is int) ? comment.depth : 0;
          flattenedList.add(MapEntry(depth, comment));
        }
      }
    } else {
      // For HN and Reddit, use recursive traversal
      void traverse(List<dynamic>? commentsToTraverse, int depth) {
        if (commentsToTraverse == null || commentsToTraverse.isEmpty) return;

        for (final comment in commentsToTraverse) {
          flattenedList.add(MapEntry(depth, comment));

          List<dynamic>? replies;
          switch (source) {
            case NewsSource.hackernews:
              replies = comment.comments;
              break;
            case NewsSource.reddit:
              // *** FIX: Access replies using object properties ***
              if (comment is RedditComment && comment.replies != null) {
                replies = comment.replies!.data.children;
              } else {
                replies = null;
              }
              break;
            default:
              replies = null;
          }
          traverse(replies, depth + 1);
        }
      }

      traverse(comments, 0);
    }
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
        // Return the comment list from the tuple
        return (item is (RedditPost, List<RedditComment>)) ? item.$2 : null;
      default:
        return null;
    }
  }

  // Helper to check if a comment is valid (not deleted/removed)
  bool _isValidComment(dynamic comment) {
    switch (source) {
      case NewsSource.hackernews:
        // Check for 'deleted' or 'dead' flags
        return comment.deleted != true && comment.dead != true;
      case NewsSource.lobsters:
        // Lobsters doesn't seem to explicitly mark deleted comments in the same way
        return true; // Assuming all comments received are valid
      case NewsSource.reddit:
        // Check for specific body text patterns
        return comment.body != null &&
            comment.body != "[deleted]" &&
            comment.body != "[removed]";
    }
  }

  // Gets the actual news item data (Post/Story)
  // Handles the Reddit tuple case.
  dynamic _getActualItemData(dynamic rawItemData) {
    if (source == NewsSource.reddit) {
      // For Reddit, the provider returns (RedditPost, List<RedditComment>)
      if (rawItemData is (RedditPost, List<RedditComment>)) {
        return rawItemData.$1; // Return the RedditPost
      } else {
        return null; // Invalid format
      }
    } else {
      // For HN and Lobsters, the provider returns the item directly
      return rawItemData;
    }
  }

  // Centralized error view builder
  Widget _buildErrorView(BuildContext context, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              'Error loading item', // Generic title
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(), // Display the specific error
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              onPressed: onRefresh,
            ),
          ],
        ),
      ),
    );
  }
}
