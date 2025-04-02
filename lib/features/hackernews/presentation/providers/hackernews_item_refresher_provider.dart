import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vibechan/features/hackernews/presentation/providers/hackernews_item_detail_provider.dart';

part 'hackernews_item_refresher_provider.g.dart';

@riverpod
class HackerNewsItemRefresher extends _$HackerNewsItemRefresher {
  @override
  bool build() {
    return false; // default state - not refreshing
  }

  Future<void> refresh(int itemId) async {
    state = true; // set refreshing state
    ref.invalidate(hackerNewsItemDetailProvider(itemId));
    await ref.read(hackerNewsItemDetailProvider(itemId).future);
    state = false; // reset refreshing state
  }
}
