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

  /// Converts this 4chan API post DTO to the domain [Post] model.
  Post toPost(String boardId, String threadId) => Post(
    // Core IDs
    id: no.toString(),
    boardId: boardId,
    threadId: resto == 0 ? no.toString() : threadId,

    // Timestamps
    timestamp: DateTime.fromMillisecondsSinceEpoch(time * 1000),

    // Poster Info
    name: name,
    tripcode: trip,
    subject: sub,
    comment: com,
    posterId: id,
    countryCode: country,
    countryName: countryName,
    boardFlag: boardFlag,

    // Media - Create Media object if relevant fields exist
    media:
        filename != null && ext != null && tim != 0
            ? Media(
              filename:
                  tim.toString() + ext!, // Use 'tim' + 'ext' for uniqueness
              // Construct the URLs directly here
              url: 'https://i.4cdn.org/$boardId/$tim$ext',
              thumbnailUrl:
                  'https://t.4cdn.org/$boardId/${tim}s.jpg', // Use t.4cdn.org for thumbs
              width: w,
              height: h,
              size: fsize, // Use 'fsize' for 'size'
              thumbnailWidth: tnW,
              thumbnailHeight: tnH,
              type: _mapMediaType(
                ext!,
              ), // Use helper to map extension to MediaType
            )
            : null,

    // Metadata
    referencedPosts: _extractReferencedPosts(com),
    isOp: resto == 0,
  );

  List<String> _extractReferencedPosts(String comment) {
    final RegExp regex = RegExp(r'>>(\d+)');
    final matches = regex.allMatches(comment);
    return matches.map((m) => m.group(1)!).toList();
  }

  // Map file extension to domain MediaType
  MediaType _mapMediaType(String extension) {
    switch (extension.toLowerCase()) {
      case '.jpg':
      case '.jpeg':
      case '.png':
        return MediaType.image;
      case '.gif':
        return MediaType.gif; // Correctly map .gif
      case '.webm':
      case '.mp4':
        return MediaType.video;
      default:
        // Default to image for unknown types, or handle differently if needed
        return MediaType.image;
    }
  }
}
