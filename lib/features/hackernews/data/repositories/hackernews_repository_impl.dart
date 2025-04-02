import 'package:vibechan/features/hackernews/data/datasources/hackernews_api_client.dart';
import 'package:vibechan/features/hackernews/data/models/hacker_news_item.dart';
import 'package:vibechan/features/hackernews/domain/repositories/hackernews_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: HackerNewsRepository)
class HackerNewsRepositoryImpl implements HackerNewsRepository {
  final HackerNewsApiClient _apiClient;

  HackerNewsRepositoryImpl(this._apiClient);

  @override
  Future<List<HackerNewsItem>> getTopStories({int count = 30}) async {
    try {
      final ids = await _apiClient.getTopStoryIds();
      final limitedIds = ids.take(count).toList();

      // Fetch items in parallel
      final futureItems = limitedIds.map((id) => getItem(id)).toList();
      final results = await Future.wait(futureItems);

      // Filter out potential nulls/errors if getItem handles them that way,
      // although the current getItem throws exceptions.
      return results.whereType<HackerNewsItem>().toList();
    } catch (e) {
      // Log error or handle appropriately
      print('Error fetching top stories: $e');
      rethrow; // Rethrow to be handled by the caller (e.g., provider)
    }
  }

  @override
  Future<HackerNewsItem> getItem(int id) async {
    try {
      final itemJson = await _apiClient.getItemById(id);
      return HackerNewsItem.fromJson(itemJson);
    } catch (e) {
      // Log error or handle appropriately
      print('Error fetching item $id: $e');
      rethrow;
    }
  }
}
