import 'package:vibechan/features/lobsters/data/models/lobsters_story.dart';
import 'package:vibechan/features/fourchan/domain/models/media.dart';

abstract class LobstersRepository {
  Future<List<LobstersStory>> getHottestStories({int count = 25});
  Future<List<LobstersStory>> getNewestStories({int count = 25});

  /// Fetches details for a single story, including comments, by its short ID.
  Future<LobstersStory> getStory(String shortId);

  // Add media methods required by base interfaces (even if dummy)
  Future<List<Media>> getAllMediaFromBoard(String boardId);
  Future<List<Media>> getAllMediaFromThreadContext(
    String boardId,
    String threadId,
  );

  // Add hasMedia methods
  Future<bool> boardHasMedia(String boardId);
  Future<bool> threadHasMedia(String boardId, String threadId);
}
