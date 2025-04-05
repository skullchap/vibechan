// lib/app/app_routes.dart

// Using an enum for type-safe route names
enum AppRoute {
  // Core Shell route
  home(name: 'home', path: '/'),

  // Settings (likely within shell context)
  settings(name: 'settings', path: '/settings'),

  // FourChan (assuming top-level access needed for TabManager)
  boardList(name: 'boards', path: '/boards'),
  boardCatalog(name: 'catalog', path: '/boards/board/:boardId'),
  thread(name: 'thread', path: '/boards/board/:boardId/thread/:threadId'),
  favorites(name: 'favorites', path: '/favorites'),

  // Lobsters (top-level)
  lobsters(name: 'lobsters', path: '/lobsters'),
  lobstersStory(name: 'lobsters_story', path: '/lobsters/story/:storyId'),

  // HackerNews (top-level)
  hackernews(name: 'hackernews', path: '/hackernews'),
  hackernewsItem(name: 'hackernews_item', path: '/hackernews/item/:itemId'),

  // Reddit (top-level)
  subredditGrid(name: 'subredditGrid', path: '/reddit'),
  subreddit(name: 'subreddit', path: '/reddit/r/:subredditName'),
  postDetail(
    name: 'postDetail',
    path: '/reddit/r/:subredditName/comments/:postId',
  ),

  // Carousel (separate/non-shell)
  carousel(name: 'carousel', path: '/carousel/:sourceInfo');

  const AppRoute({required this.name, required this.path});

  final String name;
  final String path;
}
