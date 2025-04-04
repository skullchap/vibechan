import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// For navigation
import 'package:shimmer/shimmer.dart'; // For loading placeholder
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import 'package:vibechan/app/app_routes.dart'; // Assuming routes are defined here
import 'package:vibechan/features/reddit/domain/models/subreddit_info.dart';
import 'package:vibechan/shared/providers/tab_manager_provider.dart'; // Import TabManager

class SubredditGridTile extends ConsumerWidget {
  final SubredditInfo subreddit;

  const SubredditGridTile({super.key, required this.subreddit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // Basic fallback icon if iconImg is missing/invalid
    final Widget fallbackIcon = CircleAvatar(
      backgroundColor: colorScheme.primaryContainer,
      radius: 20, // Match radius with CachedNetworkImage
      child: Text(
        // Add null/empty check for displayName
        (subreddit.displayName.isNotEmpty == true
            ? subreddit.displayName[0].toUpperCase()
            : 'R'),
        style: textTheme.titleMedium?.copyWith(
          color: colorScheme.onPrimaryContainer,
        ),
      ),
    );

    // Helper to check if URL is likely valid (basic check)
    bool isValidUrl(String? url) {
      if (url == null || url.isEmpty) return false;
      // Reddit sometimes returns empty strings or placeholder URLs
      return Uri.tryParse(url)?.hasAbsolutePath ?? false;
    }

    return Card(
      clipBehavior:
          Clip.antiAlias, // Ensures InkWell ripple stays within bounds
      child: InkWell(
        onTap: () {
          // Get the TabManagerNotifier
          final tabNotifier = ref.read(tabManagerProvider.notifier);
          // Use the TabManager to navigate within the active tab
          tabNotifier.navigateToOrReplaceActiveTab(
            title:
                subreddit.displayNamePrefixed ??
                'r/?', // Use prefixed name for title
            initialRouteName: AppRoute.subreddit.name,
            pathParameters: {'subreddit': subreddit.displayName ?? 'unknown'},
            icon: Icons.reddit, // Or a more specific icon if available
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Fit content
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Use CachedNetworkImage for the subreddit icon
                  SizedBox(
                    width: 40, // Explicit size for CircleAvatar area
                    height: 40,
                    child:
                        isValidUrl(subreddit.iconImg)
                            ? CachedNetworkImage(
                              imageUrl: subreddit.iconImg!,
                              imageBuilder:
                                  (context, imageProvider) => CircleAvatar(
                                    radius: 20,
                                    backgroundImage: imageProvider,
                                    backgroundColor: Colors.transparent,
                                  ),
                              placeholder:
                                  (context, url) => Shimmer.fromColors(
                                    baseColor: colorScheme.surfaceContainerHighest,
                                    highlightColor: colorScheme.onSurfaceVariant
                                        .withOpacity(0.1),
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundColor:
                                          colorScheme.surfaceContainerHighest,
                                    ),
                                  ),
                              errorWidget:
                                  (context, url, error) => fallbackIcon,
                            )
                            : fallbackIcon, // Fallback if no valid icon URL
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      // Add null check for displayNamePrefixed
                      subreddit.displayNamePrefixed ?? 'r/?',
                      style: textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Use Flexible with FlexFit.loose instead of Expanded
              Flexible(
                fit: FlexFit.loose,
                child:
                    (subreddit.publicDescription != null &&
                            subreddit.publicDescription!.isNotEmpty)
                        ? Text(
                          // Provide fallback for Text widget
                          subreddit.publicDescription ?? '',
                          style: textTheme.bodySmall,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        )
                        : const SizedBox.shrink(), // Use SizedBox if no description
              ),
              const SizedBox(height: 8),
              Text(
                // Add null check and formatting for subscriberCount
                '${subreddit.subscriberCount ?? 0} subscribers',
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
