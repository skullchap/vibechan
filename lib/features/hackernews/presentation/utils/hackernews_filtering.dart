import 'package:vibechan/core/domain/models/generic_list_item.dart';

/// Filters a list of HackerNews stories (as GenericListItems) based on a search query.
List<GenericListItem> filterHackerNewsStories(
  List<GenericListItem> stories,
  String query,
) {
  if (query.isEmpty) return stories;

  final searchTerms = query.toLowerCase();
  return stories.where((item) {
    final title = item.title?.toLowerCase() ?? '';
    final body =
        item.body?.toLowerCase() ?? ''; // Usually empty for HN top-level
    final metadata = item.metadata;
    final author = (metadata['by'] as String?)?.toLowerCase();

    return title.contains(searchTerms) ||
        body.contains(searchTerms) || // Less likely to match but included
        (author?.contains(searchTerms) ?? false);
  }).toList();
}
