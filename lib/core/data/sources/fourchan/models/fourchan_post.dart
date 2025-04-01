import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../domain/models/post.dart';
import '../../../../domain/models/media.dart';

part 'fourchan_post.freezed.dart';
part 'fourchan_post.g.dart';

@freezed
abstract class FourChanPost with _$FourChanPost {
  const FourChanPost._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory FourChanPost({
    // Core IDs
    @Default(0) int no, // post number
    @Default(0) int resto, // thread number if this is a reply; 0 if OP
    // Thread settings
    @Default(0) int sticky,
    @Default(0) int closed,

    // Timestamps
    String? now, // "MM/DD/YY(Day)HH:MM"
    @Default(0) int time, // Unix timestamp
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
    @Default(0) int tim, // 4chan's unique image timestamp
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

    // Thread aggregates (for OP posts)
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
  }) = _FourChanPost;

  factory FourChanPost.fromJson(Map<String, dynamic> json) =>
      _$FourChanPostFromJson(json);

  /// Converts this DTO into your domain `Post` model.
  Post toPost(String boardId, String threadId) => Post(
    id: no.toString(),
    boardId: boardId,
    threadId: threadId,
    timestamp: DateTime.fromMillisecondsSinceEpoch(time * 1000),
    name: name.isEmpty ? 'Anonymous' : name,
    tripcode: trip,
    subject: sub,
    comment: com,
    // If we have some notion of "referencedPosts," define it here
    // e.g. referencedPosts: ...
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
}
