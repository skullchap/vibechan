import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vibechan/features/lobsters/presentation/providers/lobsters_story_detail_provider.dart';

part 'lobsters_story_refresher_provider.g.dart';

@riverpod
class LobstersStoryRefresher extends _$LobstersStoryRefresher {
  @override
  bool build() {
    return false; // default state - not refreshing
  }

  Future<void> refresh(String storyId) async {
    state = true; // set refreshing state
    ref.invalidate(lobstersStoryDetailProvider(storyId));
    await ref.read(lobstersStoryDetailProvider(storyId).future);
    state = false; // reset refreshing state
  }
}
