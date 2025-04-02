import 'package:vibechan/features/hackernews/data/datasources/hackernews_api_client.dart';
import 'package:vibechan/features/hackernews/data/models/hacker_news_item.dart';
import 'package:vibechan/features/hackernews/domain/repositories/hackernews_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: HackerNewsRepository)
class HackerNewsRepositoryImpl implements HackerNewsRepository {
  final HackerNewsApiClient _apiClient;

  HackerNewsRepositoryImpl(this._apiClient);

  // Helper function to fetch items for a given list of IDs
  Future<List<HackerNewsItem>> _fetchItemsByIds(
    List<int> ids,
    int count,
  ) async {
    final limitedIds = ids.take(count).toList();
    final futureItems = limitedIds.map((id) => getItem(id)).toList();
    final results = await Future.wait(futureItems);
    return results.whereType<HackerNewsItem>().toList();
  }

  // Helper function to fetch story IDs and then their items
  Future<List<HackerNewsItem>> _fetchStoriesByPath(
    Future<List<int>> Function() idFetcher,
    int count,
  ) async {
    try {
      final ids = await idFetcher();
      return await _fetchItemsByIds(ids, count);
    } catch (e) {
      print('Error fetching stories: $e');
      rethrow;
    }
  }

  @override
  Future<List<HackerNewsItem>> getTopStories({int count = 30}) async {
    return _fetchStoriesByPath(_apiClient.getTopStoryIds, count);
  }

  @override
  Future<List<HackerNewsItem>> getNewStories({int count = 30}) async {
    return _fetchStoriesByPath(_apiClient.getNewStoryIds, count);
  }

  @override
  Future<List<HackerNewsItem>> getBestStories({int count = 30}) async {
    return _fetchStoriesByPath(_apiClient.getBestStoryIds, count);
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
