import 'package:vibechan/core/domain/models/post.dart';

/// Checks if a single post matches the search query.
bool postMatchesSearch(Post post, String query) {
  if (query.isEmpty) return true;

  final lowercaseQuery = query.toLowerCase();

  // Check post name
  if (post.name != null && post.name!.toLowerCase().contains(lowercaseQuery)) {
    return true;
  }

  // Check post subject
  if (post.subject != null &&
      post.subject!.toLowerCase().contains(lowercaseQuery)) {
    return true;
  }

  // Check post comment
  if (post.comment != null &&
      post.comment!.toLowerCase().contains(lowercaseQuery)) {
    return true;
  }

  return false;
}

/// Filters a list of posts based on a search query.
List<Post> filterPostsBySearch(List<Post> posts, String query) {
  if (query.isEmpty) return posts;

  return posts.where((post) => postMatchesSearch(post, query)).toList();
}
