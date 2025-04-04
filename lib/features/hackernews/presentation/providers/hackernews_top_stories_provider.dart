import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vibechan/features/fourchan/domain/models/generic_list_item.dart';
import 'package:vibechan/features/hackernews/data/models/hacker_news_item.dart';
import 'package:vibechan/features/hackernews/domain/repositories/hackernews_repository.dart';
import 'package:vibechan/core/di/injection.dart'; // Import getIt

part 'hackernews_top_stories_provider.g.dart';

@riverpod
Future<List<GenericListItem>> hackerNewsTopStories(Ref ref) async {
  final repository = getIt<HackerNewsRepository>();
  final hnItems = await repository.getTopStories(
    count: 50,
  ); // Fetch 50 top stories

  // Map HackerNewsItem to GenericListItem
  return hnItems
      .where(
        (item) => item.type == 'story' && !item.deleted && !item.dead,
      ) // Only show valid stories
      .map((item) => _mapHnItemToGeneric(item))
      .toList();
}

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
