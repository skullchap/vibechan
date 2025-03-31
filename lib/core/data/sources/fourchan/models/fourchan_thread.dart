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

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory FourChanThread({
    required int no,
    @JsonKey(name: 'sticky') @Default(0) int isSticky,
    @JsonKey(name: 'closed') @Default(0) int isClosed,
    required int time,
    @Default([]) List<FourChanPost> posts,
    @Default(0) int replies,
    @Default(0) int images,
    required String com,
    String? sub,
    String? filename,
    String? ext,
    int? w,
    int? h,
    int? fsize,
  }) = _FourChanThread;

  factory FourChanThread.fromJson(Map<String, dynamic> json) =>
      _$FourChanThreadFromJson(json);

  Thread toThread(String boardId) {
    final Post op = Post(
      id: no.toString(),
      boardId: boardId,
      threadId: no.toString(),
      timestamp: DateTime.fromMillisecondsSinceEpoch(time * 1000),
      subject: sub,
      comment: com,
      isOp: true,
      media: filename != null && ext != null
          ? Media(
              filename: '$filename$ext',
              url: '$filename$ext',
              thumbnailUrl: '${filename}s.jpg',
              type: ext == '.webm' ? MediaType.video : 
                    ext == '.gif' ? MediaType.gif : MediaType.image,
              width: w ?? 0,
              height: h ?? 0,
              size: fsize ?? 0,
            )
          : null,
    );

    return Thread(
      id: no.toString(),
      boardId: boardId,
      originalPost: op,
      replies: posts.map((p) => p.toPost(boardId, no.toString())).toList(),
      isSticky: isSticky == 1,
      isClosed: isClosed == 1,
      repliesCount: replies,
      imagesCount: images,
      lastModified: DateTime.fromMillisecondsSinceEpoch(time * 1000),
    );
  }
}