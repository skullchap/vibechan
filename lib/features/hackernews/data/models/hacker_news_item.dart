import 'package:freezed_annotation/freezed_annotation.dart';

part 'hacker_news_item.freezed.dart';
part 'hacker_news_item.g.dart';

@freezed
abstract class HackerNewsItem with _$HackerNewsItem {
  const factory HackerNewsItem({
    required int id,
    @Default(false) bool deleted,
    String? type, // "job", "story", "comment", "poll", or "pollopt"
    String? by, // The username of the item's author.
    int? time, // Creation date of the item, in Unix Time.
    String? text, // The comment, story or poll text. HTML.
    @Default(false) bool dead,
    int? parent, // The comment's parent: either another comment or the story.
    int? poll, // The pollopt's associated poll.
    List<int>? kids, // The ids of the item's comments, in ranked display order.
    String? url, // The URL of the story.
    int? score, // The story's score, or the votes for a pollopt.
    String? title, // The title of the story, poll or job.
    List<int>?
    parts, // A list of related pollopts, descending ordered by score.
    int?
    descendants, // In the case of stories or polls, the total comment count.
  }) = _HackerNewsItem;

  factory HackerNewsItem.fromJson(Map<String, dynamic> json) =>
      _$HackerNewsItemFromJson(json);
}
