/// Helper class to track HTML list state during parsing
class ListContext {
  /// The type of list: 'ul' for unordered or 'ol' for ordered
  final String type;

  /// The current item index, incremented for each list item
  int itemIndex = 0;

  /// Creates a new list context
  ListContext(this.type);
}
