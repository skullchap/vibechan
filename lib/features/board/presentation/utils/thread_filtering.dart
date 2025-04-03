import 'package:vibechan/core/domain/models/thread.dart';

/// Filters a list of threads based on a search query.
List<Thread> filterThreadsBySearch(List<Thread> threads, String query) {
  if (query.isEmpty) return threads;

  final searchTerms = query.toLowerCase();
  return threads.where((thread) {
    final post = thread.originalPost;
    final subject = post.subject?.toLowerCase() ?? '';
    final comment = post.comment?.toLowerCase() ?? '';
    final name = post.name?.toLowerCase() ?? '';

    return subject.contains(searchTerms) ||
        comment.contains(searchTerms) ||
        name.contains(searchTerms);
  }).toList();
}
