import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../domain/models/thread.dart';
import '../../../../domain/models/post.dart';
import '../../../../domain/models/media.dart';
import 'fourchan_post.dart';

part 'fourchan_thread.freezed.dart';
part 'fourchan_thread.g.dart';

@freezed
abstract class FourChanThread with _$FourChanThread {
  const FourChanThread._();

  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory FourChanThread({
    // Core IDs
    @Default(0) int no,
    @Default(0) int resto, // If this is a reply, the OP's post number; 0 if OP
    @Default(0) int sticky,
    @Default(0) int closed,

    // Timestamps
    String? now,
    @Default(0) int time,
    @JsonKey(name: 'last_modified') @Default(0) int lastModified,

    // Poster Info
    @Default('Anonymous') String name,
    String? trip,
    String? id,
    String? capcode,
    String? country,
    String? countryName,
    String? boardFlag,
    String? flagName,

    // Content
    String? sub,
    @Default('') String com,

    // Image / Attachment
    @Default(0) int tim,
    String? filename,
    String? ext,
    @Default(0) int fsize,
    String? md5,
    @Default(0) int w,
    @Default(0) int h,
    @JsonKey(name: 'tn_w') @Default(0) int tnW,
    @JsonKey(name: 'tn_h') @Default(0) int tnH,
    @Default(0) int filedeleted,
    @Default(0) int spoiler,
    @JsonKey(name: 'custom_spoiler') @Default(0) int customSpoiler,

    // Thread aggregates
    @Default(0) int omittedPosts,
    @Default(0) int omittedImages,
    @Default(0) int replies,
    @Default(0) int images,
    @Default(0) int bumplimit,
    @Default(0) int imagelimit,
    String? semanticUrl,
    @Default(0) int since4pass,
    @Default(0) int mImg,
    @Default(0) int archived,
    @Default(0) int archivedOn,

    // "last_replies" from the catalog; "posts" from the thread endpoint
    @Default([]) List<FourChanPost> posts,
    @JsonKey(name: 'last_replies') @Default([]) List<FourChanPost> lastReplies,
  }) = _FourChanThread;

  factory FourChanThread.fromJson(Map<String, dynamic> json) =>
      _$FourChanThreadFromJson(json);

  /// Converts this DTO into your domain `Thread` model.
  Thread toThread(String boardId) {
    // Determine the source of the OP data
    final bool isFullThread = posts.isNotEmpty;
    final FourChanPost opSource =
        isFullThread
            ? posts[0]
            : FourChanPost(
              // Reconstruct a FourChanPost from top-level fields for catalog case
              no: no,
              resto: resto, // resto is 0 for OP
              sticky: sticky,
              closed: closed,
              now: now,
              time: time,
              name: name,
              trip: trip,
              id: id,
              capcode: capcode,
              country: country,
              countryName: countryName,
              boardFlag: boardFlag,
              flagName: flagName,
              sub: sub,
              com: com,
              tim: tim,
              filename: filename,
              ext: ext,
              fsize: fsize,
              md5: md5,
              w: w,
              h: h,
              tnW: tnW,
              tnH: tnH,
              filedeleted: filedeleted,
              spoiler: spoiler,
              customSpoiler: customSpoiler,
              // Aggregate fields aren't part of a single post DTO
            );

    // Build the OP post using the determined source
    final Post op = opSource.toPost(boardId, opSource.no.toString());

    // Select the correct list for replies (posts from full thread, lastReplies from catalog)
    final repliesList = isFullThread ? posts : lastReplies;

    return Thread(
      id: opSource.no.toString(), // Use OP's actual ID
      boardId: boardId,
      originalPost: op.copyWith(isOp: true), // Ensure isOp is true
      replies:
          repliesList
              .where((p) => p.resto != 0) // Keep this filter for replies
              .map((p) => p.toPost(boardId, opSource.no.toString()))
              .toList(),
      isSticky: sticky == 1,
      isClosed: closed == 1,
      repliesCount: replies, // Use aggregate count from thread data
      imagesCount: images, // Use aggregate count from thread data
      lastModified: DateTime.fromMillisecondsSinceEpoch(lastModified * 1000),
    );
  }
}
