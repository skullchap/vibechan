import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import '../../domain/models/models.dart';
import 'reddit_remote_data_source.dart';

@LazySingleton(as: RedditRemoteDataSource)
class RedditRemoteDataSourceImpl implements RedditRemoteDataSource {
  final Dio _dio;
  // Using www.reddit.com as it often works better for the JSON API than old.reddit.com
  // and handles redirects automatically if needed. Adding .json suffix.
  final String _baseUrl = 'https://www.reddit.com';
  late final Logger _logger;

  RedditRemoteDataSourceImpl(this._dio) {
    _logger = GetIt.instance<Logger>(instanceName: "AppLogger");
  }

  // Helper to handle potential Dio errors and response structure
  dynamic _handleResponse(Response response) {
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      // Check for empty body which can happen on 204s etc.
      if (response.data == null || response.data == '') {
        return null; // Or return an empty map/list as appropriate for context
      }
      return response.data;
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error:
            'Reddit API Error: ${response.statusCode} ${response.statusMessage}',
        type: DioExceptionType.badResponse,
      );
    }
  }

  @override
  Future<List<RedditPost>> getSubredditPosts({
    required String subreddit,
    String? sort = 'hot', // Keep default here for clarity if desired
    String? timeFilter,
    String? after,
    int? limit = 25, // Default limit
  }) async {
    // Ensure sort is never null when used later
    final effectiveSort = sort ?? 'hot';

    final Map<String, dynamic> queryParameters = {
      if (after != null) 'after': after,
      if (limit != null) 'limit': limit,
      // Use effectiveSort for the condition
      if (timeFilter != null &&
          (effectiveSort == 'top' || effectiveSort == 'controversial'))
        't': timeFilter,
    };

    // Use effectiveSort in the URL
    final url = '$_baseUrl/r/$subreddit/$effectiveSort.json';

    try {
      final response = await _dio.get(url, queryParameters: queryParameters);
      final responseData = _handleResponse(response);

      if (responseData is Map<String, dynamic> &&
          responseData.containsKey('data') &&
          responseData['data'] is Map<String, dynamic>) {
        final listingData = responseData['data'] as Map<String, dynamic>;
        if (listingData.containsKey('children') &&
            listingData['children'] is List) {
          final List<dynamic> children = listingData['children'];
          return children
              .whereType<Map<String, dynamic>>()
              .map(
                (json) => RedditPost.fromJson(json),
              ) // Use the model's fromJson
              .toList();
        }
      }
      // If structure is invalid or empty, return empty list or throw
      _logger.w(
        'Invalid or empty response structure for subreddit posts: $responseData',
      );
      return []; // Return empty list as a fallback
      // throw Exception('Invalid response structure for subreddit posts');
    } on DioException catch (e) {
      _logger.e(
        "DioError fetching subreddit posts for r/$subreddit",
        error: e,
        stackTrace: StackTrace.current,
      );
      // Consider mapping Dio errors to domain-specific errors
      rethrow;
    } catch (e) {
      _logger.e("Error fetching subreddit posts for r/$subreddit", error: e);
      rethrow;
    }
  }

  @override
  Future<SubredditInfo> getSubredditInfo({required String subreddit}) async {
    final url = '$_baseUrl/r/$subreddit/about.json';
    try {
      final response = await _dio.get(url);
      final responseData = _handleResponse(response);
      // Ensure responseData is not null before parsing
      if (responseData != null) {
        return SubredditInfo.fromJson(responseData);
      } else {
        throw Exception(
          'Received null response for subreddit info for r/$subreddit',
        );
      }
    } on DioException catch (e) {
      _logger.e(
        "DioError fetching subreddit info for r/$subreddit",
        error: e,
        stackTrace: StackTrace.current,
      );
      rethrow;
    } catch (e) {
      _logger.e("Error fetching subreddit info for r/$subreddit", error: e);
      rethrow;
    }
  }

  @override
  Future<(RedditPost, List<RedditComment>)> getPostAndComments({
    required String subreddit,
    required String postId,
    String? commentId,
    int? depth,
    String? sort,
  }) async {
    final Map<String, dynamic> queryParameters = {
      if (commentId != null) 'comment': commentId,
      if (depth != null) 'depth': depth,
      if (sort != null) 'sort': sort,
      // 'limit' could be added if needed, but defaults usually load enough top-level comments
    };

    // Using the /comments/article endpoint
    final url = '$_baseUrl/r/$subreddit/comments/$postId.json';

    try {
      final response = await _dio.get(url, queryParameters: queryParameters);

      final responseData = _handleResponse(response);

      if (responseData is List && responseData.length >= 2) {
        // The first element is the listing containing the post data
        final postListing = responseData[0];
        if (postListing is Map<String, dynamic> &&
            postListing['kind'] == 'Listing' &&
            postListing.containsKey('data') &&
            postListing['data'] is Map<String, dynamic>) {
          final postListingData = postListing['data'] as Map<String, dynamic>;
          if (postListingData.containsKey('children') &&
              postListingData['children'] is List &&
              (postListingData['children'] as List).isNotEmpty) {
            final postJson = (postListingData['children'] as List)[0];
            if (postJson is Map<String, dynamic>) {
              final post = RedditPost.fromJson(postJson);

              // The second element is the listing containing the comments
              final commentListing = responseData[1];
              if (commentListing is Map<String, dynamic> &&
                  commentListing['kind'] == 'Listing' &&
                  commentListing.containsKey('data') &&
                  commentListing['data'] is Map<String, dynamic>) {
                final commentListingData =
                    commentListing['data'] as Map<String, dynamic>;
                if (commentListingData.containsKey('children') &&
                    commentListingData['children'] is List) {
                  final List<dynamic> commentChildren =
                      commentListingData['children'];
                  final comments =
                      commentChildren
                          .whereType<Map<String, dynamic>>()
                          .map(
                            (json) =>
                                const RedditCommentConverter().fromJson(json),
                          )
                          .toList();
                  return (post, comments);
                }
              }
              // If comment structure is invalid, still return post with empty comments?
              _logger.w(
                "Post found, but comment structure invalid for $subreddit/$postId",
              );
              return (post, <RedditComment>[]);
            }
          }
        }
      }
      throw Exception(
        'Invalid response structure for post $subreddit/$postId and comments: $responseData',
      );
    } on DioException catch (e, stackTrace) {
      _logger.e(
        "DioError fetching post/comments for $subreddit/$postId",
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    } catch (e, stackTrace) {
      _logger.e(
        "Error fetching post/comments for $subreddit/$postId",
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<List<SubredditInfo>> searchSubreddits({
    required String query,
    bool includeOver18 = false,
    String? after,
    int? limit = 25,
  }) async {
    final Map<String, dynamic> queryParameters = {
      'q': query,
      'include_over_18': includeOver18 ? 'on' : 'off', // API uses 'on'/'off'
      if (after != null) 'after': after,
      if (limit != null) 'limit': limit,
    };

    final url = '$_baseUrl/subreddits/search.json';

    try {
      final response = await _dio.get(url, queryParameters: queryParameters);
      final responseData = _handleResponse(response);

      if (responseData is Map<String, dynamic> &&
          responseData.containsKey('data') &&
          responseData['data'] is Map<String, dynamic>) {
        final listingData = responseData['data'] as Map<String, dynamic>;
        if (listingData.containsKey('children') &&
            listingData['children'] is List) {
          final List<dynamic> children = listingData['children'];
          return children
              .whereType<Map<String, dynamic>>()
              .map(
                (json) => SubredditInfo.fromJson(json),
              ) // Use model's fromJson
              .toList();
        }
      }
      // If structure is invalid or empty, return empty list
      _logger.w('Invalid or empty response structure for subreddit search');
      return []; // Return empty list as a fallback
      // throw Exception('Invalid response structure for subreddit search');
    } on DioException catch (e) {
      _logger.e(
        "DioError searching subreddits for '$query'",
        error: e,
        stackTrace: StackTrace.current,
      );
      rethrow;
    } catch (e) {
      _logger.e("Error searching subreddits for '$query'", error: e);
      rethrow;
    }
  }
}
