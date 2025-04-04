# Reddit Support

This directory will contain the implementation for Reddit support in the app.

## How to Implement

1. Create data models in `data/models/`:

   - `reddit_post.dart` - Model for a Reddit post
   - `reddit_comment.dart` - Model for a Reddit comment

2. Create data sources in `data/sources/`:

   - `reddit_api.dart` - API client for Reddit
   - (Optional) `reddit_cache.dart` - Cache for Reddit data

3. Create repositories in `data/repositories/`:

   - `reddit_repository.dart` - Repository for Reddit data

4. Create providers in `presentation/providers/`:

   - `reddit_posts_provider.dart` - Provider for Reddit posts listing
   - `reddit_post_detail_provider.dart` - Provider for Reddit post details
   - `reddit_refresher_provider.dart` - Provider for refreshing Reddit content

5. Add Reddit to the `NewsProviderFactory` in `lib/shared/providers/news_provider.dart`:

   - Add methods for `getNewsListProvider`, `getNewsItemDetailProvider`, etc.
   - Make sure to handle Reddit-specific data fields

6. Update the existing routes for Reddit in `lib/config/router.dart` to use `GenericNewsScreen` and `GenericNewsItemScreen` instead of placeholders.

## Example API Usage

```dart
// Example of how to fetch Reddit posts
final posts = await redditApi.getPosts(subreddit: 'all', sort: 'hot');

// Example of how to fetch a Reddit post and its comments
final postDetail = await redditApi.getPostDetail(postId: 'abc123');
```

## Integration with Generic News Components

Since we've created generic news components, adding Reddit will be straightforward. The generic components handle:

- Post listing
- Post detail view
- Comments display
- Searching
- Refreshing

All you need to do is implement the data layer and add the providers to the factory.
