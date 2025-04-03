import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart' as mk;
import 'package:media_kit_video/media_kit_video.dart';
import '../../../../core/domain/models/media.dart' as domain;
import '../../../../core/presentation/managers/post_video_manager.dart';

class PostVideo extends StatefulWidget {
  final domain.Media media;
  final bool isPreview;

  const PostVideo({super.key, required this.media, this.isPreview = false});

  @override
  State<PostVideo> createState() => _PostVideoState();
}

class _PostVideoState extends State<PostVideo> {
  late final mk.Player _player;
  late final VideoController _controller;
  bool _isPlaying = false;
  bool _opened = false;

  @override
  void initState() {
    super.initState();
    _player = mk.Player();
    _controller = VideoController(_player);
    PostVideoManager.instance.register(_player);

    // Listen for play state changes.
    _player.stream.playing.listen((isPlaying) async {
      if (isPlaying) {
        await PostVideoManager.instance.play(_player);
      }
    });
  }

  @override
  void dispose() {
    PostVideoManager.instance.unregister(_player);
    _player.dispose();
    super.dispose();
  }

  Future<void> _handlePlayPressed() async {
    if (!_opened) {
      await _player.open(mk.Media(widget.media.url), play: false);
      _opened = true;
      setState(() {
        _isPlaying = true;
      });
    }
    await PostVideoManager.instance.play(_player);
    setState(() {
      _isPlaying = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final aspectRatio =
        widget.media.width > 0 && widget.media.height > 0
            ? widget.media.width / widget.media.height
            : 16.0 / 9.0;

    if (widget.isPreview) {
      return GestureDetector(
        onTap: () {
          print('Video preview tapped');
        },
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: Image.network(
                  widget.media.thumbnailUrl,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => Center(
                        child: Icon(
                          Icons.broken_image_outlined,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                ),
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: _handlePlayPressed,
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child:
            _opened && _isPlaying
                ? Video(controller: _controller)
                : Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      child: Image.network(
                        widget.media.thumbnailUrl,
                        fit: BoxFit.contain,
                        errorBuilder:
                            (context, error, stackTrace) => Center(
                              child: Icon(
                                Icons.broken_image_outlined,
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                      ),
                    ),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_circle_filled_rounded,
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
