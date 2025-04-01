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
    // Build the OP post
    final Post op = Post(
      id: no.toString(),
      boardId: boardId,
      threadId: no.toString(),
      timestamp: DateTime.fromMillisecondsSinceEpoch(time * 1000),
      name: name.isEmpty ? 'Anonymous' : name,
      tripcode: trip,
      subject: sub,
      comment: com,
      isOp: true,
      media:
          (tim != 0 && ext != null && ext!.isNotEmpty)
              ? Media(
                filename: '$filename$ext',
                url: 'https://i.4cdn.org/$boardId/$tim$ext',
                thumbnailUrl: 'https://i.4cdn.org/$boardId/${tim}s.jpg',
                type:
                    (ext == '.webm' || ext == '.mp4')
                        ? MediaType.video
                        : ext == '.gif'
                        ? MediaType.gif
                        : MediaType.image,
                width: w,
                height: h,
                size: fsize,
              )
              : null,
    );

    // If we're viewing the actual thread endpoint, "posts" is populated
    // If from the catalog, "last_replies" is used
    final repliesList = posts.isNotEmpty ? posts : lastReplies;

    return Thread(
      id: no.toString(),
      boardId: boardId,
      originalPost: op,
      replies:
          repliesList.map((p) => p.toPost(boardId, no.toString())).toList(),
      isSticky: sticky == 1,
      isClosed: closed == 1,
      repliesCount: replies,
      imagesCount: images,
      lastModified: DateTime.fromMillisecondsSinceEpoch(lastModified * 1000),
    );
  }
}
