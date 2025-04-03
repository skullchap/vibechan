import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibechan/features/hackernews/data/models/hacker_news_item.dart';
import 'package:vibechan/features/hackernews/presentation/providers/hackernews_item_detail_provider.dart'
    hide HackerNewsItemRefresher, hackerNewsItemRefresherProvider;
import 'package:vibechan/shared/widgets/simple_html_renderer.dart';
import 'package:vibechan/core/utils/time_utils.dart';
import 'package:vibechan/shared/providers/search_provider.dart';
import 'package:vibechan/features/hackernews/presentation/providers/hackernews_item_refresher_provider.dart';
import 'package:vibechan/core/presentation/widgets/common/empty_state.dart';
import 'package:vibechan/core/presentation/widgets/common/loading_indicator.dart';
import 'package:vibechan/core/utils/comment_utils.dart';
import '../widgets/hackernews_item/hn_comment_card.dart';
import '../widgets/hackernews_item/hn_item_header.dart';

class HackerNewsItemScreen extends ConsumerWidget {
  final int itemId;

  const HackerNewsItemScreen({super.key, required this.itemId});

  // --- Helper to flatten comments and calculate depth ---
  List<MapEntry<int, HackerNewsItem>> _flattenCommentsWithDepth(
    HackerNewsItem item,
  ) {
    final List<MapEntry<int, HackerNewsItem>> flattenedList = [];

    void traverse(List<HackerNewsItem>? comments, int depth) {
      if (comments == null) return;
      for (final comment in comments) {
        // Only add non-deleted/non-dead comments to the display list
        // Also check for null text as some valid comments might have no text
        if (!comment.deleted && !comment.dead) {
          flattenedList.add(MapEntry(depth, comment));
          // Recursively traverse children
          traverse(comment.comments, depth + 1);
        }
      }
    }

    // Start traversal from the main item's direct comments
    traverse(item.comments, 0);
    return flattenedList;
  }
  // --- End Helper ---

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemDetailAsync = ref.watch(hackerNewsItemDetailProvider(itemId));
    final refreshing = ref.watch(hackerNewsItemRefresherProvider);
    final theme = Theme.of(context);
    final isSearchActive = ref.watch(isSearchActiveProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    // Define margin colors for comment indentation
    final List<Color> marginColors = [
      theme.colorScheme.primary.withOpacity(0.6),
      theme.colorScheme.secondary.withOpacity(0.6),
      theme.colorScheme.tertiary.withOpacity(0.6),
      theme.colorScheme.error.withOpacity(0.6),
    ];

    Future<void> refresh() =>
        ref.read(hackerNewsItemRefresherProvider.notifier).refresh(itemId);

    return Container(
      color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
      child: Stack(
        children: [
          itemDetailAsync.when(
            data: (item) {
              // Flatten comments using the utility function
              final flattenedComments = flattenCommentsWithDepth(item.comments);

              // TODO: Implement search filtering for comments if desired
              // final filteredComments = filterComments...

              return RefreshIndicator(
                onRefresh: refresh,
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
                      // Item Header Card
                      return Card(
                        elevation: 1,
                        clipBehavior: Clip.antiAlias,
                        margin: const EdgeInsets.only(
                          bottom: 6,
                        ), // Add margin below header
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: HnItemHeader(
                          item: item,
                          searchQuery: isSearchActive ? searchQuery : null,
                        ),
                      );
                    } else {
                      // Comment Card
                      final entry = flattenedComments[index - 1];
                      final depth = entry.key;
                      final comment = entry.value;
                      final colorIndex = depth % marginColors.length;
                      final marginColor = marginColors[colorIndex];
                      final double indentation = depth * 10.0;

                      // Skip rendering if comment somehow lacks text and isn't deleted/dead
                      // (shouldn't happen with flattenCommentsWithDepth filtering)
                      // if (comment.text == null && !comment.deleted && !comment.dead) {
                      //   return const SizedBox.shrink();
                      // }

                      return Padding(
                        padding: EdgeInsets.only(left: indentation),
                        child: HnCommentCard(
                          comment: comment,
                          marginColor: marginColor,
                          searchQuery: isSearchActive ? searchQuery : null,
                        ),
                      );
                    }
                  },
                ),
              );
            },
            loading: () => const LoadingIndicator(),
            error: (error, stack) => _buildErrorWidget(context, error, refresh),
          ),
          // Overlay loading indicator during refresh
          if (refreshing)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.3),
                child: const LoadingIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  // Keep old error handling for now
  Widget _buildErrorWidget(
    BuildContext context,
    Object error,
    VoidCallback onRetry,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text('Error loading item: $error'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}
