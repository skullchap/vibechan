import 'package:flutter/material.dart';

/// Breakpoints based on Material 3 guidelines
/// https://m3.material.io/foundations/adaptive-design/large-screens/overview
class ResponsiveBreakpoints {
  // Material 3 breakpoint values
  static const double compact = 0;
  static const double medium = 600;
  static const double expanded = 840;
  static const double large = 1240;
  static const double xlarge = 1440;

  // Layout type helpers
  static bool isCompact(BuildContext context) =>
      MediaQuery.of(context).size.width < medium;

  static bool isMedium(BuildContext context) =>
      MediaQuery.of(context).size.width >= medium &&
      MediaQuery.of(context).size.width < expanded;

  static bool isExpanded(BuildContext context) =>
      MediaQuery.of(context).size.width >= expanded;

  static bool isLarge(BuildContext context) =>
      MediaQuery.of(context).size.width >= large;

  static bool isXLarge(BuildContext context) =>
      MediaQuery.of(context).size.width >= xlarge;

  // Use to get the current device type
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < medium) return DeviceType.mobile;
    if (width < expanded) return DeviceType.tablet;
    return DeviceType.desktop;
  }
}

/// Device type classification
enum DeviceType { mobile, tablet, desktop }

/// A utility class for responsive layout helpers
class ResponsiveLayout {
  // Helper to get appropriate width based on screen size
  static double getWidthValue({
    required BuildContext context,
    required double compact,
    required double medium,
    required double expanded,
  }) {
    final width = MediaQuery.of(context).size.width;

    if (width < ResponsiveBreakpoints.medium) {
      return compact;
    } else if (width < ResponsiveBreakpoints.expanded) {
      return medium;
    } else {
      return expanded;
    }
  }

  // Helper to get appropriate height based on screen size
  static double getHeightValue({
    required BuildContext context,
    required double compact,
    required double medium,
    required double expanded,
  }) {
    final width = MediaQuery.of(context).size.width;

    if (width < ResponsiveBreakpoints.medium) {
      return compact;
    } else if (width < ResponsiveBreakpoints.expanded) {
      return medium;
    } else {
      return expanded;
    }
  }

  // Get appropriate padding based on screen size
  static EdgeInsets getPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < ResponsiveBreakpoints.medium) {
      return const EdgeInsets.all(8.0);
    } else if (width < ResponsiveBreakpoints.expanded) {
      return const EdgeInsets.all(16.0);
    } else {
      return const EdgeInsets.all(24.0);
    }
  }

  // Get grid columns count based on screen size
  static int getColumnCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < ResponsiveBreakpoints.medium) {
      return 2; // Mobile: 2 columns
    } else if (width < ResponsiveBreakpoints.expanded) {
      return 3; // Tablet: 3 columns
    } else if (width < ResponsiveBreakpoints.large) {
      return 4; // Desktop: 4 columns
    } else {
      return 5; // Large desktop: 5+ columns
    }
  }
}

/// Widget that builds different layouts based on screen size
class AdaptiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext, DeviceType) builder;

  const AdaptiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveBreakpoints.getDeviceType(context);
    return builder(context, deviceType);
  }
}
