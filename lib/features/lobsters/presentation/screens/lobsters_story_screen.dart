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
import 'package:vibechan/core/presentation/widgets/common/loading_indicator.dart';
import 'package:vibechan/core/presentation/widgets/common/error_state.dart';
import 'package:vibechan/features/lobsters/presentation/widgets/lobsters_story/lobsters_story_header.dart';
import 'package:vibechan/features/lobsters/presentation/widgets/lobsters_story/lobsters_comment_card.dart';

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
                      // Use LobstersStoryHeader widget
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
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
                            child: LobstersStoryHeader(
                              story: story,
                              searchQuery: isSearchActive ? searchQuery : null,
                            ),
                          ),
                        ],
                      );
                    } else {
                      // Use LobstersCommentCard widget
                      final comment = story.comments![index - 1];
                      final colorIndex = comment.depth % marginColors.length;
                      final marginColor = marginColors[colorIndex];
                      // Slightly increase indentation per level
                      final double indentation = comment.depth * 10.0;

                      return Padding(
                        padding: EdgeInsets.only(left: indentation),
                        child: Card(
                          elevation: 1,
                          clipBehavior: Clip.antiAlias,
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: LobstersCommentCard(
                            comment: comment,
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
            // Use common LoadingIndicator
            loading: () => const LoadingIndicator(),
            // Use common ErrorState
            error:
                (error, stack) => ErrorState(
                  message: 'Error loading story: $error',
                  onRetry: () {
                    ref.invalidate(lobstersStoryDetailProvider(storyId));
                  },
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
}
