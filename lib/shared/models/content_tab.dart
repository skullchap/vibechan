import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'content_tab.freezed.dart';
part 'content_tab.g.dart';

// --- Icon Converter ---
// Simple map for common icons used in tabs
const Map<String, IconData> _iconMap = {
  'dashboard': Icons.dashboard,
  'view_list': Icons.view_list,
  'comment': Icons.comment,
  'favorite': Icons.favorite,
  'settings': Icons.settings,
  'newspaper': Icons.newspaper,
  'rss_feed': Icons.rss_feed,
  'web': Icons.web, // Default
};

String _iconDataToString(IconData icon) {
  return _iconMap.entries
      .firstWhere(
        (entry) => entry.value == icon,
        orElse: () => _iconMap.entries.firstWhere((e) => e.key == 'web'),
      )
      .key;
}

IconData _stringToIconData(String iconString) {
  return _iconMap[iconString] ?? Icons.web;
}

// Custom JsonConverter for IconData
class IconDataConverter implements JsonConverter<IconData, String> {
  const IconDataConverter();

  @override
  IconData fromJson(String json) => _stringToIconData(json);

  @override
  String toJson(IconData icon) => _iconDataToString(icon);
}
// --- End Icon Converter ---

@freezed
abstract class ContentTab with _$ContentTab {
  const factory ContentTab({
    required String id,
    required String title,
    required String initialRouteName, // e.g., 'catalog', 'thread', 'favorites'
    required Map<String, String> pathParameters,
    @IconDataConverter() @Default(Icons.web) IconData icon,
    @Default(false) bool isActive,
    // Add other relevant state if needed, e.g., scroll position
  }) = _ContentTab;

  // Add fromJson factory
  factory ContentTab.fromJson(Map<String, dynamic> json) =>
      _$ContentTabFromJson(json);
}
