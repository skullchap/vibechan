import 'package:flutter/material.dart';
import 'package:vibechan/core/domain/models/thread.dart';
import 'package:vibechan/features/board/presentation/widgets/thread_preview_card.dart';
import 'package:vibechan/core/services/layout_service.dart';

class CatalogMediaFeed extends StatelessWidget {
  final List<Thread> threads;
  final void Function(Thread thread) onTap;
  final EdgeInsetsGeometry? padding;
  final AppLayout? layoutType;

  const CatalogMediaFeed({
    super.key,
    required this.threads,
    required this.onTap,
    this.padding,
    this.layoutType,
  });

  @override
  Widget build(BuildContext context) {
    // Determine item spacing based on layout type
    final double verticalSpacing = (layoutType == AppLayout.mobile) ? 4.0 : 8.0;
    final EdgeInsetsGeometry effectivePadding =
        padding ?? const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0);

    // Determine if we should use staggered animation based on layout
    final bool useAnimations =
        layoutType != null && layoutType != AppLayout.mobile;

    return ListView.builder(
      padding: effectivePadding,
      itemCount: threads.length,
      itemBuilder: (context, index) {
        final thread = threads[index];

        // Build the card with or without animations
        Widget card = ThreadPreviewCard(
          thread: thread,
          onTap: () => onTap(thread),
          fullWidth: true,
          squareAspect: true,
          useFullMedia: true,
        );

        // Add animations for non-mobile layouts
        if (useAnimations) {
          // Stagger the animation based on index
          final delay = Duration(milliseconds: 25 * (index % 15));

          return FutureBuilder(
            future: Future.delayed(delay),
            builder: (context, snapshot) {
              final isVisible =
                  snapshot.connectionState == ConnectionState.done;

              return AnimatedSlide(
                offset: isVisible ? Offset.zero : const Offset(0, 0.05),
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                child: AnimatedOpacity(
                  opacity: isVisible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeInOut,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: verticalSpacing),
                    child: card,
                  ),
                ),
              );
            },
          );
        }

        // Basic padding for mobile layout
        return Padding(
          padding: EdgeInsets.only(bottom: verticalSpacing),
          child: card,
        );
      },
    );
  }
}
