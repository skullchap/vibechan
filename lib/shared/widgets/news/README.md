# Generic News Components

This directory contains generic, reusable components for displaying news/stories from different sources (HackerNews, Lobsters, Reddit, etc.).

## Components Overview

1. `GenericNewsScreen` - A wrapper component that sets up the necessary providers and displays a list of news items
2. `GenericNewsItemScreen` - A wrapper component that sets up the necessary providers and displays a news item detail
3. `GenericNewsListScreen` - The actual list screen that displays news items
4. `GenericNewsDetailScreen` - The actual detail screen that displays a news item and its comments

## How to Use

### For Existing Sources (HackerNews, Lobsters)

You can use the generic components directly:

```dart
// For a list screen
return GenericNewsScreen(source: NewsSource.hackernews);

// For a detail screen
return GenericNewsItemScreen(
  source: NewsSource.lobsters,
  itemId: someId,
);
```

### Adding a New Source (e.g. Reddit)

1. **Update the NewsSource enum**:

   ```dart
   // In lib/shared/enums/news_source.dart
   enum NewsSource {
     hackernews,
     lobsters,
     reddit, // New source
   }
   ```

2. **Create provider implementations for the new source**:

   - Create a stories provider similar to `hackerNewsStoriesProvider` or `lobstersStoriesProvider`
   - Create an item detail provider similar to `hackerNewsItemDetailProvider` or `lobstersStoryDetailProvider`
   - Create a refresher provider similar to existing ones

3. **Update the NewsProviderFactory**:

   - Add your new providers to each of the factory methods in `NewsProviderFactory`
   - Ensure data fields match between sources or handle differences in the generic components

4. **Add routes to your app**:

   - Add routes for the new source (e.g., 'reddit' and 'reddit_post')
   - Make sure to use `GenericNewsScreen` and `GenericNewsItemScreen` in those routes

5. **Run the app**:
   - Your new source should now work with the existing generic components

## Adding New Features

When adding features that should work across all news sources:

1. Add the feature to the generic components
2. Make sure to handle source-specific differences using the `source` property and switch statements
3. Update any helper methods in `GenericNewsDetailScreen` and `GenericNewsListScreen`
4. If needed, update the models in `NewsItem` and `NewsComment`

## Extending for Other Content Types

This pattern can be extended to other types of content by:

1. Creating a new enum for the content type
2. Creating generic models for that content type
3. Creating generic screens and providers for that content type
4. Implementing source-specific providers that map to the generic interface
