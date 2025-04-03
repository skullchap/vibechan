/// Filters a list of boards based on a search query.
List<dynamic> filterBoards(List<dynamic> boards, String query) {
  final lowercaseQuery = query.toLowerCase().trim();
  if (lowercaseQuery.isEmpty) {
    return boards;
  }

  return boards.where((board) {
    // Get the board ID and remove any slashes that might be in it
    final rawId = board.id.toString().toLowerCase();
    // Strip any slashes from the ID for pure comparison
    final cleanId = rawId.replaceAll('/', '');

    final title = board.title.toString().toLowerCase();
    final description = board.description.toString().toLowerCase();

    // Check for matches on the clean ID without slashes
    final bool matchesShortName =
        cleanId ==
            lowercaseQuery || // Direct match (e.g., "gif" matches board with ID "/gif/")
        cleanId.startsWith(lowercaseQuery) || // Prefix match
        cleanId.contains(lowercaseQuery); // Substring match

    // Also check if the raw ID with slashes matches
    final bool matchesRawId = rawId.contains(lowercaseQuery);

    // Check if title or description matches
    final bool matchesLongName =
        title.contains(lowercaseQuery) || description.contains(lowercaseQuery);

    return matchesShortName || matchesRawId || matchesLongName;
  }).toList();
}
