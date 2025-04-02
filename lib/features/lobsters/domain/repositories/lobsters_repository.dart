import 'package:vibechan/features/lobsters/data/models/lobsters_story.dart';

abstract class LobstersRepository {
  Future<List<LobstersStory>> getHottestStories({int count = 25});
  Future<List<LobstersStory>> getNewestStories({int count = 25});

  /// Fetches details for a single story, including comments, by its short ID.
  Future<LobstersStory> getStory(String shortId);
}
