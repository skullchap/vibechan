import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../utils/responsive_layout.dart';

part 'layout_service.g.dart';

/// Layouts available in the app
enum AppLayout {
  // Standard layouts
  mobile,
  tablet,
  desktop,

  // Special cases
  compactDesktop, // For desktop with small window
  wideDesktop, // For ultra-wide displays
}

/// Layout service for managing responsive layout
class LayoutService {
  // Determine current layout
  AppLayout getLayoutForContext(BuildContext context) {
    final deviceType = ResponsiveBreakpoints.getDeviceType(context);
    final width = MediaQuery.of(context).size.width;

    // Ultra-wide desktop
    if (width >= ResponsiveBreakpoints.xlarge) {
      return AppLayout.wideDesktop;
    }

    // Regular desktop
    if (deviceType == DeviceType.desktop) {
      // Small desktop window
      if (width < ResponsiveBreakpoints.large) {
        return AppLayout.compactDesktop;
      }
      return AppLayout.desktop;
    }

    // Tablet layout
    if (deviceType == DeviceType.tablet) {
      return AppLayout.tablet;
    }

    // Default to mobile
    return AppLayout.mobile;
  }

  // Helper methods for different layout adjustments

  // Get appropriate edge padding based on layout
  EdgeInsets getPaddingForLayout(AppLayout layout) {
    switch (layout) {
      case AppLayout.mobile:
        return const EdgeInsets.all(8.0);
      case AppLayout.tablet:
        return const EdgeInsets.all(16.0);
      case AppLayout.compactDesktop:
        return const EdgeInsets.all(20.0);
      case AppLayout.desktop:
        return const EdgeInsets.all(24.0);
      case AppLayout.wideDesktop:
        return const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0);
    }
  }

  // Get appropriate grid column count based on layout
  int getColumnCountForLayout(AppLayout layout) {
    switch (layout) {
      case AppLayout.mobile:
        return 2;
      case AppLayout.tablet:
        return 3;
      case AppLayout.compactDesktop:
        return 4;
      case AppLayout.desktop:
        return 5;
      case AppLayout.wideDesktop:
        return 6;
    }
  }

  // Determine if side panel should be shown
  bool shouldShowSidePanel(AppLayout layout) {
    return layout == AppLayout.desktop || layout == AppLayout.wideDesktop;
  }

  // Get side panel width based on layout
  double getSidePanelWidth(AppLayout layout) {
    switch (layout) {
      case AppLayout.compactDesktop:
        return 220.0;
      case AppLayout.desktop:
        return 250.0;
      case AppLayout.wideDesktop:
        return 280.0;
      default:
        return 0.0; // No side panel for mobile/tablet
    }
  }

  // Get appropriate animation duration based on layout change
  Duration getAnimationDuration(AppLayout oldLayout, AppLayout newLayout) {
    // For dramatic layout changes, use longer animations
    if ((oldLayout == AppLayout.mobile &&
            (newLayout == AppLayout.desktop ||
                newLayout == AppLayout.wideDesktop)) ||
        ((oldLayout == AppLayout.desktop ||
                oldLayout == AppLayout.wideDesktop) &&
            newLayout == AppLayout.mobile)) {
      return const Duration(milliseconds: 400);
    }

    // Default animation duration
    return const Duration(milliseconds: 300);
  }
}

/// State class for current layout
class LayoutState {
  final AppLayout currentLayout;
  final bool isAnimating;

  const LayoutState({required this.currentLayout, this.isAnimating = false});

  LayoutState copyWith({AppLayout? currentLayout, bool? isAnimating}) {
    return LayoutState(
      currentLayout: currentLayout ?? this.currentLayout,
      isAnimating: isAnimating ?? this.isAnimating,
    );
  }
}

/// Riverpod provider for layout service
@riverpod
LayoutService layoutService(LayoutServiceRef ref) {
  return LayoutService();
}

/// Riverpod provider for current layout state
@riverpod
class LayoutStateNotifier extends _$LayoutStateNotifier {
  @override
  LayoutState build() {
    return const LayoutState(currentLayout: AppLayout.mobile);
  }

  // Update layout based on context
  void updateLayout(BuildContext context) {
    final service = ref.read(layoutServiceProvider);
    final newLayout = service.getLayoutForContext(context);

    if (state.currentLayout != newLayout) {
      // Mark the start of animation
      state = state.copyWith(isAnimating: true);

      // Update to new layout
      state = state.copyWith(currentLayout: newLayout);

      // Store current animation state for comparison in the callback
      final oldState = state;

      // Mark the end of animation after duration
      Future.delayed(
        service.getAnimationDuration(state.currentLayout, newLayout),
        () {
          // Only update if the state hasn't changed since we started the timer
          // This prevents updating disposed or changed notifiers
          try {
            if (state.currentLayout == oldState.currentLayout) {
              state = state.copyWith(isAnimating: false);
            }
          } catch (e) {
            // Ignore errors that might occur if the notifier is disposed
          }
        },
      );
    }
  }
}
