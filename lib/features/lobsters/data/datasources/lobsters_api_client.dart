import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@injectable
class LobstersApiClient {
  final Dio _dio;
  final String _baseUrl = 'https://lobste.rs';

  LobstersApiClient(this._dio);

  // Fetches stories based on the specified path (e.g., /hottest.json, /newest.json)
  // Change return type to List<dynamic> to avoid premature casting
  Future<List<dynamic>> getStories(String path) async {
    final url = '$_baseUrl$path'; // Path should include .json extension
    try {
      final response = await _dio.get(url);
      if (response.statusCode == 200 && response.data is List) {
        // Return the raw list
        return response.data as List<dynamic>;
      } else {
        throw Exception(
          'Failed to load Lobsters stories from $url: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        'Network error fetching Lobsters stories from $url: ${e.message}',
      );
    } catch (e) {
      throw Exception(
        'Unexpected error fetching Lobsters stories from $url: $e',
      );
    }
  }

  // Specific methods now return Future<List<dynamic>>
  Future<List<dynamic>> getHottestStories() => getStories('/hottest.json');
  Future<List<dynamic>> getNewestStories() => getStories('/newest.json');
  // Add other feeds like /t/tag.json if needed later

  /// Fetches details for a single story
  Future<Map<String, dynamic>> getStory(String shortId) async {
    final url = '$_baseUrl/s/$shortId.json';
    try {
      final response = await _dio.get(url);
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception(
          'Failed to load Lobsters story from $url: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        'Network error fetching Lobsters story from $url: ${e.message}',
      );
    } catch (e) {
      throw Exception('Unexpected error fetching Lobsters story from $url: $e');
    }
  }
}
