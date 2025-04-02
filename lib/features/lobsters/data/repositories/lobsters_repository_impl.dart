import 'package:injectable/injectable.dart';
import 'package:vibechan/features/lobsters/data/datasources/lobsters_api_client.dart';
import 'package:vibechan/features/lobsters/data/models/lobsters_story.dart';
import 'package:vibechan/features/lobsters/domain/repositories/lobsters_repository.dart';

@LazySingleton(as: LobstersRepository)
class LobstersRepositoryImpl implements LobstersRepository {
  final LobstersApiClient _apiClient;

  LobstersRepositoryImpl(this._apiClient);

  Future<List<LobstersStory>> _fetchStories(
    Future<List<dynamic>> Function() fetcher,
    int count,
  ) async {
    try {
      final dynamicList = await fetcher();
      final stories = <LobstersStory>[];
      for (final item in dynamicList) {
        if (item is Map<String, dynamic>) {
          try {
            stories.add(LobstersStory.fromJson(item));
          } catch (e) {
            print('Failed to parse Lobsters item: $e\nItem Data: $item');
          }
        } else {
          print(
            'Skipping unexpected item type in Lobsters feed: ${item.runtimeType}',
          );
        }
        if (stories.length >= count) break;
      }
      return stories;
    } catch (e) {
      print('Error fetching Lobsters stories: $e');
      rethrow;
    }
  }

  @override
  Future<List<LobstersStory>> getHottestStories({int count = 25}) {
    return _fetchStories(_apiClient.getHottestStories, count);
  }

  @override
  Future<List<LobstersStory>> getNewestStories({int count = 25}) {
    return _fetchStories(_apiClient.getNewestStories, count);
  }
}
