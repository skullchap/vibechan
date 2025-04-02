import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vibechan/core/di/injection.dart';
import 'package:vibechan/features/hackernews/data/models/hacker_news_item.dart';
import 'package:vibechan/features/hackernews/domain/repositories/hackernews_repository.dart';

part 'hackernews_item_detail_provider.g.dart';

@riverpod
Future<HackerNewsItem> hackerNewsItemDetail(
  HackerNewsItemDetailRef ref,
  int itemId,
) async {
  final repository = getIt<HackerNewsRepository>();
  // Fetch the item details (including comments) using the repository
  final item = await repository.getItem(itemId);
  return item;
}
