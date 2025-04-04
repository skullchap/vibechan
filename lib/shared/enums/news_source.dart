enum NewsSource {
  hackernews,
  lobsters,
  reddit, // Future support
}

enum NewsSortType {
  top,
  best,
  latest,
  hot, // More for Reddit
  controversial, // More for Reddit
  new_, // Using new_ to avoid reserved keyword
}
