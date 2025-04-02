import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vibechan/core/di/injection.dart';
import 'package:vibechan/core/domain/models/generic_list_item.dart';
import 'package:vibechan/features/hackernews/data/models/hacker_news_item.dart';
import 'package:vibechan/features/hackernews/domain/repositories/hackernews_repository.dart';

part 'hackernews_stories_provider.g.dart'; // Rename generated file

enum HackerNewsSortType { top, newest, best }

// Provider to hold the current sort type for the active Hacker News view
final currentHackerNewsSortTypeProvider = StateProvider<HackerNewsSortType>(
  (ref) => HackerNewsSortType.top,
);

@riverpod
Future<List<GenericListItem>> hackerNewsStories(
  HackerNewsStoriesRef ref,
  HackerNewsSortType sortType,
) async {
  final repository = getIt<HackerNewsRepository>();
  List<HackerNewsItem> hnItems;
  const int count = 50; // Number of items to fetch

  switch (sortType) {
    case HackerNewsSortType.top:
      hnItems = await repository.getTopStories(count: count);
      break;
    case HackerNewsSortType.newest:
      hnItems = await repository.getNewStories(count: count);
      break;
    case HackerNewsSortType.best:
      hnItems = await repository.getBestStories(count: count);
      break;
  }

  // Map HackerNewsItem to GenericListItem (filter only stories)
  return hnItems
      .where((item) => item.type == 'story' && !item.deleted && !item.dead)
      .map((item) => _mapHnItemToGeneric(item))
      .toList();
}

// Added back the mapping function
GenericListItem _mapHnItemToGeneric(HackerNewsItem hnItem) {
  return GenericListItem(
    id: hnItem.id.toString(),
    source: ItemSource.hackernews,
    title: hnItem.title,
    // HN text can be HTML, GenericListCard assumes HTML for now
    body: hnItem.text,
    // HN doesn't provide direct image thumbnails/media in the item model
    // We might need to scrape the URL (hnItem.url) later if image previews are desired
    thumbnailUrl: null,
    mediaUrl: null,
    mediaType: MediaType.none,
    timestamp:
        hnItem.time != null
            ? DateTime.fromMillisecondsSinceEpoch(hnItem.time! * 1000)
            : null,
    metadata: {
      'score': hnItem.score,
      'by': hnItem.by,
      'descendants': hnItem.descendants, // Comment count
      'url': hnItem.url, // URL of the story
      'type': hnItem.type,
    },
    originalData: hnItem,
  );
}
