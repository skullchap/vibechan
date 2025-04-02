import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'content_tab.freezed.dart';

@freezed
abstract class ContentTab with _$ContentTab {
  const factory ContentTab({
    required String id,
    required String title,
    required String initialRouteName, // e.g., 'catalog', 'thread', 'favorites'
    required Map<String, String> pathParameters,
    @Default(Icons.web) IconData icon,
    @Default(false) bool isActive,
    // Add other relevant state if needed, e.g., scroll position
  }) = _ContentTab;
}
