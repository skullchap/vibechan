import 'package:media_kit/media_kit.dart';

class PostVideoManager {
  PostVideoManager._();
  static final instance = PostVideoManager._();

  final List<Player> _players = [];

  void register(Player player) {
    if (!_players.contains(player)) {
      _players.add(player);
    }
  }

  void unregister(Player player) {
    _players.remove(player);
  }

  /// Pauses all players except the [current] one.
  Future<void> pauseAllExcept(Player current) async {
    for (final player in _players) {
      if (player != current) {
        await player.pause();
      }
    }
  }

  /// Convenience method to pause all other players and then play [current].
  Future<void> play(Player current) async {
    await pauseAllExcept(current);
    await current.play();
  }
}
