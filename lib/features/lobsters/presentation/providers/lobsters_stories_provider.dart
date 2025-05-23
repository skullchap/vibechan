import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vibechan/core/di/injection.dart';
import 'package:vibechan/features/fourchan/domain/models/generic_list_item.dart';
import 'package:vibechan/features/lobsters/data/models/lobsters_story.dart';
import 'package:vibechan/features/lobsters/domain/repositories/lobsters_repository.dart';

part 'lobsters_stories_provider.g.dart';

enum LobstersSortType { hottest, newest }

// Add extension for display name
extension LobstersSortTypeExtension on LobstersSortType {
  String get displayName {
    switch (this) {
      case LobstersSortType.hottest:
        return 'Hottest';
      case LobstersSortType.newest:
        return 'Newest';
    }
  }
}

final currentLobstersSortTypeProvider = StateProvider<LobstersSortType>(
  (ref) => LobstersSortType.hottest,
);

@Riverpod(keepAlive: true)
Future<List<GenericListItem>> lobstersStories(
  Ref ref,
  LobstersSortType sortType,
) async {
  final repository = getIt<LobstersRepository>();
  List<LobstersStory> stories;
  const int count = 25;

  switch (sortType) {
    case LobstersSortType.hottest:
      stories = await repository.getHottestStories(count: count);
      break;
    case LobstersSortType.newest:
      stories = await repository.getNewestStories(count: count);
      break;
  }

  return stories.map((story) => _mapLobstersStoryToGeneric(story)).toList();
}

GenericListItem _mapLobstersStoryToGeneric(LobstersStory story) {
  return GenericListItem(
    id: story.shortId,
    source: ItemSource.lobsters,
    title: story.title,
    body: story.description,
    thumbnailUrl: null,
    mediaUrl: null,
    mediaType: MediaType.none,
    timestamp: story.createdAt,
    metadata: {
      'score': story.score,
      'comment_count': story.commentCount,
      'tags': story.tags,
      'url': story.url,
      'comments_url': story.commentsUrl,
      'submitter': story.submitterUser,
      'short_id': story.shortId,
    },
    originalData: story,
  );
}
