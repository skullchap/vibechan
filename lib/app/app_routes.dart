// lib/app/app_routes.dart

// Using an enum for type-safe route names
enum AppRoute {
  // Existing routes (assuming some exist)
  home(name: 'home', path: '/'),
  settings(name: 'settings', path: '/settings'),
  search(name: 'search', path: '/search'),

  // FourChan routes (assuming)
  board(name: 'board', path: '/board/:boardId'),
  thread(name: 'thread', path: '/board/:boardId/thread/:threadId'),

  // Lobsters routes (assuming)
  lobsters(name: 'lobsters', path: '/lobsters'),

  // --- New Reddit Routes ---
  subredditGrid(
    name: 'subredditGrid',
    path: '/reddit',
  ), // Entry point for Reddit section
  subreddit(
    name: 'subreddit',
    path: '/reddit/r/:subreddit',
  ), // Shows posts in a subreddit
  postDetail(
    name: 'postDetail',
    path: '/reddit/r/:subreddit/comments/:postId',
  ); // Shows post and comments

  const AppRoute({required this.name, required this.path});

  final String name;
  final String path;
}
