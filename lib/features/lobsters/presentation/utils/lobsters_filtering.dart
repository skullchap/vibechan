import 'package:vibechan/core/domain/models/generic_list_item.dart';

List<GenericListItem> filterLobstersStoriesBySearch(
  List<GenericListItem> stories,
  String query,
) {
  if (query.isEmpty) return stories;

  final searchTerms = query.toLowerCase();
  return stories.where((item) {
    final title = item.title?.toLowerCase() ?? '';
    final body = item.body?.toLowerCase() ?? '';
    final metadata = item.metadata;

    return title.contains(searchTerms) ||
        body.contains(searchTerms) ||
        (metadata['submitter_user']?.toString().toLowerCase().contains(
              searchTerms,
            ) ==
            true);
  }).toList();
}
