import 'package:flutter/material.dart'; // For IconData
import 'package:vibechan/features/fourchan/domain/models/media.dart'; // Import Media model

/// Represents a single statistic item to be displayed on a preview card.
class PreviewStatItem {
  final IconData icon;
  final String value;
  final String? tooltip;

  const PreviewStatItem({
    required this.icon,
    required this.value,
    this.tooltip,
  });
}

/// Abstract interface for data that can be displayed in a generic preview card.
abstract class PreviewableItem {
  String get id;
  String? get subject;
  String? get commentSnippet;
  String? get mediaPreviewUrl; // URL for main image/video thumbnail
  String? get thumbnailUrl; // Smaller thumbnail URL
  double? get mediaAspectRatio;
  bool get isVideo;
  Media? get mediaObject; // Expose original Media object if needed
  List<PreviewStatItem> get stats;
}
