import 'package:flutter_riverpod/flutter_riverpod.dart';

enum RedditSortType { hot, new_, top, rising, controversial }

// Extension to get display names for the sort types
extension RedditSortTypeExtension on RedditSortType {
  String get displayName {
    switch (this) {
      case RedditSortType.hot:
        return 'Hot';
      case RedditSortType.new_:
        return 'New';
      case RedditSortType.top:
        return 'Top';
      case RedditSortType.rising:
        return 'Rising';
      case RedditSortType.controversial:
        return 'Controversial';
    }
  }

  String get apiValue {
    switch (this) {
      case RedditSortType.new_:
        return 'new'; // Use 'new' for API but 'new_' for enum to avoid keyword conflict
      default:
        return name; // For other cases, enum name matches API value
    }
  }
}

// Provider to hold the current sort type for Reddit
final currentRedditSortTypeProvider = StateProvider<RedditSortType>(
  (ref) => RedditSortType.hot, // Default to hot
);
