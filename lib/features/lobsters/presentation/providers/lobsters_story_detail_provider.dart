import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vibechan/core/di/injection.dart';
import 'package:vibechan/features/lobsters/data/models/lobsters_story.dart';
import 'package:vibechan/features/lobsters/domain/repositories/lobsters_repository.dart';

part 'lobsters_story_detail_provider.g.dart';

@riverpod
Future<LobstersStory> lobstersStoryDetail(
  LobstersStoryDetailRef ref,
  String storyId,
) async {
  final repository = getIt<LobstersRepository>();
  // Fetch the story details using the repository
  final story = await repository.getStory(storyId);
  return story;
}
