/// Abstract interface for data that can be displayed in a generic grid item card.
abstract class GridItem {
  String get id;
  String get title;
  String? get subtitle;
  bool get isSensitive; // Added flag for sensitive content (e.g., NSFW)
  // Add other common properties if needed, e.g., icon, image url
}
