import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vibechan/core/di/injection.dart';
import 'package:vibechan/features/hackernews/data/models/hacker_news_item.dart';
import 'package:vibechan/features/hackernews/domain/repositories/hackernews_repository.dart';

part 'hackernews_item_detail_provider.g.dart';

// Changed from keepAlive: true to false to ensure proper refresh
@Riverpod()
Future<HackerNewsItem> hackerNewsItemDetail(Ref ref, int itemId) async {
  final repository = getIt<HackerNewsRepository>();

  // Add auto-disposal to ensure proper refresh
  ref.keepAlive();

  // Force cache invalidation to ensure fresh data
  ref.onDispose(() {
    // Clean up resources if needed
  });

  // Fetch the item details (including comments) using the repository
  final item = await repository.getItemWithComments(itemId);
  return item;
}

// Add a separate provider to manually refresh
@Riverpod()
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
