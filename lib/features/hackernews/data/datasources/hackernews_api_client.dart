import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'dart:async';

@injectable // Register with GetIt
class HackerNewsApiClient {
  final Dio _dio;
  final String _baseUrl = 'https://hacker-news.firebaseio.com/v0';

  HackerNewsApiClient(this._dio);

  /// Fetches story IDs based on the specified sort type.
  Future<List<int>> _getStoryIds(String pathSegment) async {
    try {
      final response = await _dio.get('$_baseUrl/$pathSegment.json');

      if (response.statusCode == 200) {
        if (response.data == null) {
          return [];
        }

        if (response.data is List) {
          final List<dynamic> data = response.data;
          return data.whereType<int>().toList();
        } else {
          return [];
        }
      } else {
        throw Exception(
          'Failed to load $pathSegment IDs: HTTP ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Network error fetching $pathSegment IDs: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error fetching $pathSegment IDs: $e');
    }
  }

  /// Fetches top story IDs.
  Future<List<int>> getTopStoryIds() => _getStoryIds('topstories');

  /// Fetches new story IDs.
  Future<List<int>> getNewStoryIds() => _getStoryIds('newstories');

  /// Fetches best story IDs.
  Future<List<int>> getBestStoryIds() => _getStoryIds('beststories');

  /// Fetches a single item (story, comment, job, etc.) by its ID.
  Future<Map<String, dynamic>> getItemById(int id) async {
    try {
      final response = await _dio.get('$_baseUrl/item/$id.json');

      if (response.statusCode == 200) {
        if (response.data == null) {
          throw Exception('Item with ID $id not found or is null.');
        }

        if (response.data is Map) {
          return Map<String, dynamic>.from(response.data);
        } else {
          throw Exception('Unexpected data type for item $id');
        }
      } else {
        throw Exception('Failed to load item $id: HTTP ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error fetching item $id: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error fetching item $id: $e');
    }
  }
}
