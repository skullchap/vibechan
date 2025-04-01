import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:vibechan/core/domain/models/thread.dart';
import 'package:vibechan/features/board/presentation/widgets/thread_preview_card.dart';
import 'package:vibechan/shared/widgets/html_text.dart';
import '../../../../thread/presentation/widgets/post_video.dart';

class CatalogMediaFeed extends StatelessWidget {
  final List<Thread> threads;
  final void Function(Thread thread) onTap;

  const CatalogMediaFeed({
    super.key,
    required this.threads,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: threads.length,
      itemBuilder: (context, index) {
        final thread = threads[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: ThreadPreviewCard(
            thread: thread,
            onTap: () => onTap(thread),
            fullWidth: true,
            squareAspect: true,
            useFullMedia: true,
          ),
        );
      },
    );
  }
}
