import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart'
    as mk; // Import for Player with prefix
import 'package:media_kit_video/media_kit_video.dart';
import 'package:vibechan/features/fourchan/domain/models/media.dart';
import 'package:vibechan/features/fourchan/presentation/providers/carousel_providers.dart';

class CarouselScreen extends ConsumerStatefulWidget {
  // Accept the combined sourceInfo string
  final String sourceInfo;

  const CarouselScreen({super.key, required this.sourceInfo});

  @override
  ConsumerState<CarouselScreen> createState() => _CarouselScreenState();
}

class _CarouselScreenState extends ConsumerState<CarouselScreen> {
  // Video Player related state
  late final mk.Player _player; // Use prefix mk.Player
  late final VideoController _videoController;
  int _currentPage = 0; // Keep track of the current page
  final PageController _pageController = PageController();

  // Helper to parse title from sourceInfo for AppBar
  String _getTitleFromSourceInfo(String sourceInfo, int current, int total) {
    try {
      final parts = sourceInfo.split(':');
      final sourceName = parts[0];
      final args = parts[1].split('/');
      if (sourceName == '4chan') {
        final boardId = args[0];
        final threadId = args.length > 1 ? args[1] : null;
        final context = threadId != null ? '/$threadId' : '';
        return '$boardId$context (${current + 1} / $total)';
      } // Add other sources here
      return 'Carousel (${current + 1} / $total)'; // Generic fallback
    } catch (e) {
      return 'Media Carousel'; // Error fallback
    }
  }

  @override
  void initState() {
    super.initState();
    _player = mk.Player(); // Use prefix mk.Player
    _videoController = VideoController(_player);
  }

  @override
  void dispose() {
    // Release allocated resources.
    _player.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _playMediaAtIndex(Media media) {
    if (media.type == MediaType.video) {
      _player.open(mk.Media(media.url), play: true); // Use prefix mk.Media
    } else {
      _player.pause(); // Pause if switching away from a video
    }
  }

  void _jumpToPage(int index, List<Media> mediaList) {
    // ... same as before ...
  }

  @override
  Widget build(BuildContext context) {
    // Use the new provider with sourceInfo
    final mediaListAsync = ref.watch(
      carouselMediaListProvider(widget.sourceInfo),
    );

    return Scaffold(
      // Make AppBar transparent and overlay content
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: mediaListAsync.maybeWhen(
          data:
              (media) => Text(
                // Use helper to generate title from sourceInfo
                _getTitleFromSourceInfo(
                  widget.sourceInfo,
                  _currentPage,
                  media.length,
                ),
                style: const TextStyle(
                  color: Colors.white,
                  shadows: [Shadow(blurRadius: 2.0)],
                ), // Add shadow for visibility
              ),
          orElse:
              () => Text(
                // Fallback title if data isn't loaded yet
                _getTitleFromSourceInfo(widget.sourceInfo, 0, 0).split(' (')[0],
              ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: mediaListAsync.when(
        data: (mediaList) {
          if (mediaList.isEmpty) {
            return const Center(
              child: Text(
                'No media found in this thread.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          // Play the first media item initially if it's a video
          if (_player.state.playlist.medias.isEmpty && mediaList.isNotEmpty) {
            _playMediaAtIndex(mediaList[0]);
          }

          return PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: mediaList.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
              _playMediaAtIndex(mediaList[index]);
            },
            itemBuilder: (context, index) {
              final media = mediaList[index];
              return _buildMediaItem(media);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (err, stack) => Center(
              child: Text(
                'Error loading media: $err',
                style: const TextStyle(color: Colors.white),
              ),
            ),
      ),
    );
  }

  Widget _buildMediaItem(Media media) {
    switch (media.type) {
      case MediaType.image:
      case MediaType.gif:
        return InteractiveViewer(
          minScale: 1.0,
          maxScale: 4.0,
          child: CachedNetworkImage(
            imageUrl: media.url,
            fit: BoxFit.contain,
            placeholder:
                (context, url) =>
                    const Center(child: CircularProgressIndicator()),
            errorWidget:
                (context, url, error) =>
                    const Center(child: Icon(Icons.error, color: Colors.red)),
          ),
        );
      case MediaType.video:
        return Center(
          child: AspectRatio(
            aspectRatio:
                media.width > 0 && media.height > 0
                    ? media.width / media.height
                    : 16 / 9, // Default aspect ratio
            child: Video(
              controller: _videoController,
              fit: BoxFit.contain,
              controls: AdaptiveVideoControls,
            ),
          ),
        );
    }
  }
}
