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
      // Initial parse without nested comments
      final item = HackerNewsItem.fromJson(itemJson);

      // If the item has kids, fetch them recursively
      if (item.kids != null && item.kids!.isNotEmpty) {
        // Fetch all direct children concurrently
        final futureComments =
            item.kids!
                // Filter out potential nulls from API before fetching
                .where((kidId) => kidId != null)
                // Recursively call getItem for each child ID
                .map((kidId) => getItem(kidId))
                .toList();

        final fetchedComments = await Future.wait(futureComments);

        // Filter out nulls/errors and assign to comments field
        final validComments =
            fetchedComments.whereType<HackerNewsItem>().toList();

        // Return the item with its direct children (which themselves have comments populated)
        return item.copyWith(comments: validComments);
      } else {
        // No kids, return the item as is
        return item;
      }
    } catch (e) {
      print('Error fetching HN item $id or its children: $e');
      rethrow;
    }
  }
}
