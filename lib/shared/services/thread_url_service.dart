import 'package:vibechan/shared/enums/news_source.dart';

/// Utility class to generate external URLs for threads and posts
/// across different supported platforms
class ThreadUrlService {
  /// Generate a 4chan thread URL for viewing in a browser
  static String getFourChanUrl(String boardId, String threadId) {
    return 'https://boards.4chan.org/$boardId/thread/$threadId';
  }

  /// Generate a Hacker News item URL for viewing in a browser
  static String getHackerNewsUrl(String itemId) {
    return 'https://news.ycombinator.com/item?id=$itemId';
  }

  /// Generate a Lobsters story URL for viewing in a browser
  static String getLobstersUrl(String storyId) {
    return 'https://lobste.rs/s/$storyId';
  }

  /// Get the appropriate URL based on the news source and IDs
  static String getExternalUrl({
    NewsSource? source,
    String? boardId,
    String? threadId,
    String? itemId,
  }) {
    // If we have boardId and threadId, it's a 4chan URL regardless of source
    if (boardId != null && threadId != null) {
      return getFourChanUrl(boardId, threadId);
    }

    // Otherwise, check the source for other platforms
    if (source != null) {
      switch (source) {
        case NewsSource.hackernews:
          return getHackerNewsUrl(itemId ?? '');
        case NewsSource.lobsters:
          return getLobstersUrl(itemId ?? '');
        case NewsSource.reddit:
          // Future implementation
          throw UnimplementedError('Reddit URLs not yet implemented');
      }
    }

    throw ArgumentError('Missing required parameters for URL generation');
  }
}
