import 'package:vibechan/features/hackernews/data/models/hacker_news_item.dart';
import 'package:vibechan/features/fourchan/domain/models/media.dart';

abstract class HackerNewsRepository {
  /// Fetches a list of top story items.
  /// [count] specifies the maximum number of items to fetch.
  Future<List<HackerNewsItem>> getTopStories({int count = 30});

  /// Fetches a list of new story items.
  Future<List<HackerNewsItem>> getNewStories({int count = 30});

  /// Fetches a list of best story items.
  Future<List<HackerNewsItem>> getBestStories({int count = 30});

  /// Fetches basic details for a single item by its ID, without comments.
  Future<HackerNewsItem> getItem(int id);

  /// Fetches details for a single item by its ID, including comments.
  Future<HackerNewsItem> getItemWithComments(int id);

  // Add media methods required by base interfaces (even if dummy)
  Future<List<Media>> getAllMediaFromBoard(String boardId);
  Future<List<Media>> getAllMediaFromThreadContext(
    String boardId,
    String threadId,
  );

  // Add hasMedia methods
  Future<bool> boardHasMedia(String boardId);
  Future<bool> threadHasMedia(String boardId, String threadId);

  // Add other methods as needed, e.g., getAskStories, etc.
}
