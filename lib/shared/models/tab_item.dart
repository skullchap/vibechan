import 'package:flutter/material.dart';

/// Represents a tab in the multi-tab interface
class TabItem {
  final String id;
  final String title;
  final String route;
  final Map<String, String> pathParameters;
  final IconData icon;
  bool isActive;
  
  TabItem({
    required this.id,
    required this.title,
    required this.route,
    this.pathParameters = const {},
    this.icon = Icons.web,
    this.isActive = false,
  });
  
  TabItem copyWith({
    String? title,
    String? route,
    Map<String, String>? pathParameters,
    IconData? icon,
    bool? isActive,
  }) {
    return TabItem(
      id: id,
      title: title ?? this.title,
      route: route ?? this.route,
      pathParameters: pathParameters ?? this.pathParameters,
      icon: icon ?? this.icon,
      isActive: isActive ?? this.isActive,
    );
  }
}