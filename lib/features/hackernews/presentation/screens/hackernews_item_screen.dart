import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibechan/features/hackernews/data/models/hacker_news_item.dart';
import 'package:vibechan/features/hackernews/presentation/providers/hackernews_item_detail_provider.dart';
import 'package:vibechan/shared/providers/tab_manager_provider.dart';
import 'package:vibechan/shared/widgets/simple_html_renderer.dart';
import 'package:vibechan/core/utils/time_utils.dart';
import 'package:vibechan/shared/models/content_tab.dart';

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
    final theme = Theme.of(context);

    final List<Color> marginColors = [
      theme.colorScheme.primary,
      theme.colorScheme.secondary,
      theme.colorScheme.tertiary,
      theme.colorScheme.error,
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hacker News Item'),
        elevation: 1.0,
        // Add Back Button Action
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back to List', // Add tooltip
          onPressed: () {
            final tabNotifier = ref.read(tabManagerProvider.notifier);
            // Correctly get the currently active tab
            final ContentTab? activeTab = tabNotifier.activeTab;

            // Check if the active tab is indeed the HN item view
            if (activeTab != null &&
                activeTab.initialRouteName == 'hackernews_item') {
              // Replace the current tab's content to go back
              tabNotifier.navigateToOrReplaceActiveTab(
                title:
                    'Hacker News', // Or get title from a stored state if needed
                initialRouteName: 'hackernews', // Go back to the list route
                pathParameters: {}, // Clear params from detail view
                icon: Icons.newspaper, // Reset icon
              );
            } else {
              // Fallback or error handling if the active tab logic fails
              print(
                "Error: Could not find active Hacker News item tab to navigate back from.",
              );
            }
          },
        ),
      ),
      backgroundColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
      body: itemDetailAsync.when(
        data: (item) {
          // --- Remove depth pre-calculation logic ---
          /*
          final Map<int, HackerNewsItem> commentsById = { ... };
          final Map<int, int> commentDepthMap = {};
          void populateDepthMap(List<int>? kids, int depth) { ... }
          populateDepthMap(item.kids, 0);
          */

          // --- Flatten the nested comments ---
          final flattenedComments = _flattenCommentsWithDepth(item);

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
            // Item count is header + flattened comments
            itemCount: 1 + flattenedComments.length,
            separatorBuilder: (context, index) => const SizedBox(height: 6),
            itemBuilder: (context, index) {
              if (index == 0) {
                // Story/Item Header Card
                return Card(
                  elevation: 1,
                  clipBehavior: Clip.antiAlias,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _buildItemHeader(context, item, theme),
                );
              } else {
                // Comment Card from flattened list
                final entry = flattenedComments[index - 1];
                final depth = entry.key; // Depth from MapEntry key
                final comment = entry.value; // Comment from MapEntry value

                // Skip rendering if comment is somehow null (shouldn't happen with filter)
                // if (comment == null) return const SizedBox.shrink();

                final colorIndex = depth % marginColors.length;
                final marginColor = marginColors[colorIndex];
                final double indentation = depth * 10.0;

                // Only render card if comment text exists or it's marked deleted/dead
                // (This prevents rendering empty cards for comments filtered out earlier)
                if (comment.text != null || comment.deleted || comment.dead) {
                  return Padding(
                    padding: EdgeInsets.only(left: indentation),
                    child: Card(
                      elevation: 1,
                      clipBehavior: Clip.antiAlias,
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _buildCommentItem(comment, theme, marginColor),
                    ),
                  );
                } else {
                  // Should generally not be reached due to filter in _flattenCommentsWithDepth
                  return const SizedBox.shrink();
                }
              }
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stack) => Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Error loading item: $error\n$stack'),
              ),
            ),
      ),
    );
  }

  // Remove the old _getDepthFromMap function
  /*
  int _getDepthFromMap(HackerNewsItem comment, Map<int, int> depthMap) {
    return depthMap[comment.id] ?? 0;
  }
  */

  Widget _buildItemHeader(
    BuildContext context,
    HackerNewsItem item,
    ThemeData theme,
  ) {
    // Similar to Lobsters header, adapted for HN fields
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (item.url != null && item.url!.isNotEmpty)
            InkWell(
              child: Text(
                Uri.tryParse(item.url!)?.host ?? item.url!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              onTap: () async {
                final uri = Uri.tryParse(item.url!);
                if (uri != null && await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
            ),
          if (item.url != null && item.url!.isNotEmpty)
            const SizedBox(height: 12),
          // Metadata row
          DefaultTextStyle(
            style: theme.textTheme.bodyMedium!.copyWith(
              color: theme.textTheme.bodyMedium!.color?.withOpacity(0.8),
            ),
            child: Row(
              children: [
                if (item.score != null) ...[
                  Icon(
                    Icons.arrow_upward_rounded,
                    size: 16,
                    color: theme.colorScheme.secondary,
                  ),
                  const SizedBox(width: 3),
                  Text('${item.score}'),
                  const SizedBox(width: 12),
                ],
                if (item.by != null) ...[
                  Icon(Icons.person_outline_rounded, size: 16),
                  const SizedBox(width: 3),
                  Text(item.by!),
                  const SizedBox(width: 12),
                ],
                if (item.time != null) ...[
                  Icon(Icons.access_time_rounded, size: 16),
                  const SizedBox(width: 3),
                  Text(
                    formatTimeAgoSimple(
                      DateTime.fromMillisecondsSinceEpoch(item.time! * 1000),
                    ),
                  ),
                ],
                if (item.descendants != null) ...[
                  const Spacer(), // Push comments count to the right if other items exist
                  Icon(Icons.comment_outlined, size: 16),
                  const SizedBox(width: 3),
                  Text('${item.descendants}'),
                ],
              ],
            ),
          ),
          // Separator before text/body (equivalent to Lobsters description)
          if (item.text != null && item.text!.isNotEmpty)
            const Divider(height: 24, thickness: 0.5),
          // Display item text if it exists (using HTML renderer)
          if (item.text != null && item.text!.isNotEmpty)
            SimpleHtmlRenderer(
              htmlString: item.text!,
              baseStyle: theme.textTheme.bodyLarge,
            ),
        ],
      ),
    );
  }

  // Builds the content INSIDE the comment card
  Widget _buildCommentItem(
    HackerNewsItem comment,
    ThemeData theme,
    Color marginColor,
  ) {
    // Very similar to Lobsters _buildCommentItem, uses HackerNewsItem
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 5.0,
            decoration: BoxDecoration(
              color: marginColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  DefaultTextStyle(
                    style: theme.textTheme.labelMedium!.copyWith(
                      color: theme.textTheme.labelMedium!.color?.withOpacity(
                        0.7,
                      ),
                    ),
                    child: Row(
                      children: [
                        if (comment.by != null)
                          Text(
                            comment.by!,
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        const Spacer(),
                        if (comment.time != null) ...[
                          Icon(Icons.access_time_rounded, size: 14),
                          const SizedBox(width: 2),
                          Text(
                            formatTimeAgoSimple(
                              DateTime.fromMillisecondsSinceEpoch(
                                comment.time! * 1000,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (comment.text != null && !comment.deleted && !comment.dead)
                    SimpleHtmlRenderer(
                      htmlString: comment.text!,
                      baseStyle: theme.textTheme.bodyMedium,
                    )
                  else if (comment.deleted)
                    Text(
                      '[deleted]',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    )
                  else if (comment.dead)
                    Text(
                      '[dead]',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
