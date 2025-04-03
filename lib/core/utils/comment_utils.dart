import 'package:flutter/material.dart'; // Need for MapEntry potentially

/// Generic interface for comment-like objects
abstract class CommentNode {
  List<CommentNode>? get childComments;
  bool get isDeleted;
  bool get isDead;
}

/// Flattens a tree of comments into a list with depth information.
///
/// Takes a list of top-level [comments] and returns a list of MapEntry,
/// where the key is the depth (int) and the value is the comment (T).
/// Only includes comments where `isDeleted` and `isDead` are false.
List<MapEntry<int, T>> flattenCommentsWithDepth<T extends CommentNode>(
  List<T>? comments,
) {
  final List<MapEntry<int, T>> flattenedList = [];

  void traverse(List<T>? currentComments, int depth) {
    if (currentComments == null) return;
    for (final comment in currentComments) {
      // Only add non-deleted/non-dead comments
      if (!comment.isDeleted && !comment.isDead) {
        flattenedList.add(MapEntry(depth, comment));
        // Recursively traverse children
        // Ensure childComments is cast correctly if needed, or use as List<T>?
        final children = comment.childComments?.cast<T>();
        traverse(children, depth + 1);
      }
    }
  }

  // Start traversal from the top-level comments
  traverse(comments, 0);
  return flattenedList;
}
