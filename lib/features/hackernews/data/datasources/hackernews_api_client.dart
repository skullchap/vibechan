import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@injectable // Register with GetIt
class HackerNewsApiClient {
  final Dio _dio;
  final String _baseUrl = 'https://hacker-news.firebaseio.com/v0';

  HackerNewsApiClient(this._dio);

  /// Fetches top story IDs.
  Future<List<int>> getTopStoryIds() async {
    try {
      final response = await _dio.get('$_baseUrl/topstories.json');
      if (response.statusCode == 200 && response.data is List) {
        // The API returns a list of integers (IDs)
        return List<int>.from(response.data);
      } else {
        throw Exception('Failed to load top story IDs: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Handle Dio specific errors (network, timeout, etc.)
      throw Exception('Network error fetching top story IDs: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error fetching top story IDs: $e');
    }
  }

  /// Fetches a single item (story, comment, job, etc.) by its ID.
  Future<Map<String, dynamic>> getItemById(int id) async {
    try {
      final response = await _dio.get('$_baseUrl/item/$id.json');
      if (response.statusCode == 200 && response.data is Map) {
        return Map<String, dynamic>.from(response.data);
      } else if (response.data == null) {
        // HN API returns null for deleted or non-existent items
        throw Exception('Item with ID $id not found or is null.');
      } else {
        throw Exception('Failed to load item $id: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error fetching item $id: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error fetching item $id: $e');
    }
  }
}
