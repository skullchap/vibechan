import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart' as mk;
import 'package:media_kit_video/media_kit_video.dart';
import '../../../../core/domain/models/media.dart' as domain;
import '../../../../core/presentation/managers/post_video_manager.dart';

class PostVideo extends StatefulWidget {
  final domain.Media media;

  const PostVideo({super.key, required this.media});

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
    final aspectRatio = widget.media.width / widget.media.height;
    return GestureDetector(
      onTap: _handlePlayPressed,
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child:
            _isPlaying
                ? Video(controller: _controller)
                : Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      color: ColorScheme.of(context).onSurface,
                      child: Image.network(
                        widget.media.thumbnailUrl,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const Center(
                      child: Icon(
                        Icons.play_circle_fill,
                        size: 64,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
