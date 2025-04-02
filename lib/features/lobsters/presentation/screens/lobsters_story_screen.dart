import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibechan/features/lobsters/data/models/lobsters_story.dart';
import 'package:vibechan/features/lobsters/presentation/providers/lobsters_story_detail_provider.dart';
import 'package:vibechan/shared/widgets/simple_html_renderer.dart';
import 'package:vibechan/core/utils/time_utils.dart';
import 'package:vibechan/shared/providers/tab_manager_provider.dart';
import 'package:vibechan/shared/models/content_tab.dart';
import 'package:vibechan/shared/providers/search_provider.dart';
import 'package:vibechan/features/lobsters/presentation/providers/lobsters_story_refresher_provider.dart';

class LobstersStoryScreen extends ConsumerWidget {
  final String storyId;

  const LobstersStoryScreen({super.key, required this.storyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyDetailAsync = ref.watch(lobstersStoryDetailProvider(storyId));
    final refreshing = ref.watch(lobstersStoryRefresherProvider);
    final theme = Theme.of(context);
    // Define margin colors based on theme
    final List<Color> marginColors = [
      theme.colorScheme.primary,
      theme.colorScheme.secondary,
      theme.colorScheme.tertiary,
      theme.colorScheme.error, // Add more if needed
    ];

    // Get search state
    final isSearchActive = ref.watch(searchVisibleProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    // Return the body content directly
    return Container(
      // Use a Container for background color
      color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
      child: Stack(
        children: [
          storyDetailAsync.when(
            data: (story) {
              return RefreshIndicator(
                onRefresh: () async {
                  // Use the refresher provider to properly invalidate cache
                  await ref
                      .read(lobstersStoryRefresherProvider.notifier)
                      .refresh(storyId);
                },
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 6.0,
                  ),
                  itemCount: 1 + (story.comments?.length ?? 0),
                  separatorBuilder:
                      (context, index) => const SizedBox(height: 6),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      // Story Header Card
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
                                onPressed:
                                    refreshing
                                        ? null
                                        : () async {
                                          await ref
                                              .read(
                                                lobstersStoryRefresherProvider
                                                    .notifier,
                                              )
                                              .refresh(storyId);
                                        },
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
                            child: _buildStoryHeader(
                              context,
                              story,
                              theme,
                              isSearchActive ? searchQuery : null,
                            ),
                          ),
                        ],
                      );
                    } else {
                      // Comment Card
                      final comment = story.comments![index - 1];
                      final colorIndex = comment.depth % marginColors.length;
                      final marginColor = marginColors[colorIndex];
                      // Slightly increase indentation per level
                      final double indentation = comment.depth * 10.0;

                      // Use a Stack for potential future line drawing, but keep simple for now
                      return Padding(
                        padding: EdgeInsets.only(
                          left: indentation,
                        ), // Apply indentation outside the card
                        child: Card(
                          elevation: 1,
                          clipBehavior: Clip.antiAlias,
                          margin:
                              EdgeInsets
                                  .zero, // Margin is handled by Padding now
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
                        Text('Error loading story: $error'),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.refresh),
                          label: const Text('Try Again'),
                          onPressed: () {
                            ref.invalidate(
                              lobstersStoryDetailProvider(storyId),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
          ),
          // Overlay loading indicator during refresh
          if (refreshing)
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

  Widget _buildStoryHeader(
    BuildContext context,
    LobstersStory story,
    ThemeData theme,
    String? searchQuery,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0), // Slightly more padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (story.url.isNotEmpty) // Show URL only if it exists
            InkWell(
              child: Text(
                Uri.tryParse(story.url)?.host ??
                    story.url, // Show host or full URL
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              onTap: () async {
                final uri = Uri.tryParse(story.url);
                if (uri != null && await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
            ),
          if (story.url.isNotEmpty) const SizedBox(height: 12),
          // Story metadata row
          DefaultTextStyle(
            style: theme.textTheme.bodyMedium!.copyWith(
              color: theme.textTheme.bodyMedium!.color?.withOpacity(0.8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.arrow_upward_rounded,
                  size: 16,
                  color: theme.colorScheme.secondary,
                ),
                const SizedBox(width: 3),
                Text('${story.score}'),
                const SizedBox(width: 12),
                Icon(Icons.person_outline_rounded, size: 16),
                const SizedBox(width: 3),
                Text(story.submitterUser),
                const SizedBox(width: 12),
                Icon(Icons.access_time_rounded, size: 16),
                const SizedBox(width: 3),
                Text(formatTimeAgoSimple(story.createdAt)),
              ],
            ),
          ),
          // Separator before description
          if (story.description != null && story.description!.isNotEmpty)
            const Divider(height: 24, thickness: 0.5),
          // Display description if it exists with search highlighting
          if (story.description != null && story.description!.isNotEmpty)
            SimpleHtmlRenderer(
              htmlString: story.description!,
              baseStyle: theme.textTheme.bodyLarge,
              highlightTerms: searchQuery,
              highlightColor: theme.colorScheme.primaryContainer.withOpacity(
                0.5,
              ),
            ),
          // Display tags if they exist
          if (story.tags.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 6.0,
                children:
                    story.tags
                        .map(
                          (tag) => Chip(
                            label: Text(tag),
                            labelStyle: theme.textTheme.labelSmall,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 0,
                            ),
                            backgroundColor: theme
                                .colorScheme
                                .secondaryContainer
                                .withOpacity(0.5),
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            visualDensity: VisualDensity.compact,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                        )
                        .toList(),
              ),
            ),
        ],
      ),
    );
  }

  // Builds the content INSIDE the comment card, including the margin bar
  Widget _buildCommentItem(
    LobstersComment comment,
    ThemeData theme,
    Color marginColor,
    String? searchQuery,
  ) {
    return IntrinsicHeight(
      // Ensures Row children stretch vertically if needed
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.stretch, // Stretch children vertically
        children: [
          // Colored Margin Bar
          Container(
            width: 5.0, // Slightly thicker bar
            decoration: BoxDecoration(
              color: marginColor,
              // Match card's border radius on the left side
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
            ),
          ),
          // Comment Content (no extra SizedBox needed)
          Expanded(
            child: Padding(
              // Consistent padding inside
              padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // Take minimum vertical space
                children: [
                  // Comment header (user, score, time)
                  DefaultTextStyle(
                    style: theme.textTheme.labelMedium!.copyWith(
                      color: theme.textTheme.labelMedium!.color?.withOpacity(
                        0.7,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          comment.commentingUser,
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_upward_rounded,
                          size: 14,
                          color: theme.colorScheme.secondary,
                        ),
                        const SizedBox(width: 2),
                        Text('${comment.score}'),
                        const SizedBox(width: 8),
                        Icon(Icons.access_time_rounded, size: 14),
                        const SizedBox(width: 2),
                        Text(formatTimeAgoSimple(comment.createdAt)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8), // Spacing between header and body
                  // Display comment text with search highlighting
                  SimpleHtmlRenderer(
                    htmlString: comment.comment ?? '',
                    baseStyle: theme.textTheme.bodyMedium,
                    highlightTerms: searchQuery,
                    highlightColor: theme.colorScheme.primaryContainer
                        .withOpacity(0.5),
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
