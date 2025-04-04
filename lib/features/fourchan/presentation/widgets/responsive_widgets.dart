import 'package:flutter/material.dart';
import '../../../../core/utils/responsive_layout.dart';

/// A responsive container that adapts its constraints based on screen size
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double? width;
  final double? height;
  final BoxDecoration? decoration;
  final BoxConstraints? constraints;
  final AlignmentGeometry? alignment;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.width,
    this.height,
    this.decoration,
    this.constraints,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    // Apply responsive padding if not specified
    final effectivePadding = padding ?? ResponsiveLayout.getPadding(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: effectivePadding,
      margin: margin,
      color: color,
      width: width,
      height: height,
      decoration: decoration,
      constraints: constraints,
      alignment: alignment,
      child: child,
    );
  }
}

/// A responsive grid that adapts its column count based on screen size
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final EdgeInsetsGeometry padding;
  final int? fixedColumnCount;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
    this.padding = EdgeInsets.zero,
    this.fixedColumnCount,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate column count based on screen size, unless explicitly specified
    final columnCount =
        fixedColumnCount ?? ResponsiveLayout.getColumnCount(context);

    return AnimatedLayoutBuilder(
      key: ValueKey('grid-$columnCount'),
      child: GridView.builder(
        padding: padding,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columnCount,
          crossAxisSpacing: spacing,
          mainAxisSpacing: runSpacing,
        ),
        itemCount: children.length,
        itemBuilder: (context, index) => children[index],
      ),
    );
  }
}

/// A responsive list that adapts between list view and grid view based on screen size
class ResponsiveList extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry padding;
  final bool Function(BuildContext) useGridView;
  final ScrollController? controller;
  final int gridColumnCount;

  const ResponsiveList({
    super.key,
    required this.children,
    this.padding = EdgeInsets.zero,
    this.useGridView = ResponsiveBreakpoints.isExpanded,
    this.controller,
    this.gridColumnCount = 2,
  });

  @override
  Widget build(BuildContext context) {
    final isGrid = useGridView(context);

    return AnimatedLayoutBuilder(
      child:
          isGrid
              ? GridView.builder(
                controller: controller,
                padding: padding,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridColumnCount,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: children.length,
                itemBuilder: (context, index) => children[index],
              )
              : ListView.builder(
                controller: controller,
                padding: padding,
                itemCount: children.length,
                itemBuilder: (context, index) => children[index],
              ),
    );
  }
}

/// A scaffold with responsive padding and animations
class ResponsiveScaffold extends StatelessWidget {
  final Widget? body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? drawer;
  final Widget? endDrawer;
  final Color? backgroundColor;

  const ResponsiveScaffold({
    super.key,
    this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.drawer,
    this.endDrawer,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveBreakpoints.getDeviceType(context);

    // For desktop, consider using different layout with permanent drawer if specified
    if (deviceType == DeviceType.desktop && drawer != null) {
      return Scaffold(
        appBar: appBar,
        backgroundColor: backgroundColor,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        bottomNavigationBar: bottomNavigationBar,
        endDrawer: endDrawer,
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Permanent drawer for desktop
            SizedBox(width: 250, child: Drawer(elevation: 0, child: drawer)),
            // Expanded body with responsive padding
            Expanded(child: body ?? const SizedBox.shrink()),
          ],
        ),
      );
    }

    // Standard scaffold for mobile and tablet
    return Scaffold(
      appBar: appBar,
      body: AnimatedPadding(
        duration: const Duration(milliseconds: 300),
        padding:
            deviceType == DeviceType.mobile
                ? EdgeInsets.zero
                : const EdgeInsets.symmetric(horizontal: 16.0),
        child: body ?? const SizedBox.shrink(),
      ),
      drawer: drawer,
      endDrawer: endDrawer,
      backgroundColor: backgroundColor,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

/// A widget that animates its child when the layout changes
class AnimatedLayoutBuilder extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;

  const AnimatedLayoutBuilder({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: curve,
      switchOutCurve: curve,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: child,
    );
  }
}
