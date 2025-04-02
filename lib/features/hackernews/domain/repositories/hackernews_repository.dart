import 'package:vibechan/features/hackernews/data/models/hacker_news_item.dart';

abstract class HackerNewsRepository {
  /// Fetches a list of top story items.
  /// [count] specifies the maximum number of items to fetch.
  Future<List<HackerNewsItem>> getTopStories({int count = 30});

  /// Fetches a list of new story items.
  Future<List<HackerNewsItem>> getNewStories({int count = 30});

  /// Fetches a list of best story items.
  Future<List<HackerNewsItem>> getBestStories({int count = 30});

  /// Fetches details for a single item by its ID.
  Future<HackerNewsItem> getItem(int id);

  // Add other methods as needed, e.g., getAskStories, etc.
}
