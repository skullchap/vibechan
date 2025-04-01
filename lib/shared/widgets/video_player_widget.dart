import 'dart:async';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart' as mk;
import 'package:media_kit_video/media_kit_video.dart';
import '../../core/presentation/managers/post_video_manager.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({super.key, required this.videoUrl});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late final mk.Player player;
  late final VideoController controller;
  late final StreamSubscription<bool> playingSub;

  @override
  void initState() {
    super.initState();
    player = mk.Player();
    controller = VideoController(player);

    // Listen for play state changes.
    playingSub = player.stream.playing.listen((isPlaying) async {
      if (isPlaying) {
        // When this player is playing, ensure all others are paused.
        await PostVideoManager.instance.play(player);
      }
    });

    player.open(mk.Media(widget.videoUrl));
    PostVideoManager.instance.register(player);
  }

  @override
  void dispose() {
    playingSub.cancel();
    PostVideoManager.instance.unregister(player);
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Video(controller: controller);
  }
}
