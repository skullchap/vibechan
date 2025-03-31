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
    required int no,
    required int time,
    required String com,
    String? name,
    String? trip,
    String? sub,
    String? filename,
    String? ext,
    int? w,
    int? h,
    int? fsize,
    @Default([]) List<String> repliesTo,
  }) = _FourChanPost;

  factory FourChanPost.fromJson(Map<String, dynamic> json) =>
      _$FourChanPostFromJson(json);

  Post toPost(String boardId, String threadId) => Post(
        id: no.toString(),
        boardId: boardId,
        threadId: threadId,
        timestamp: DateTime.fromMillisecondsSinceEpoch(time * 1000),
        name: name,
        tripcode: trip,
        subject: sub,
        comment: com,
        referencedPosts: repliesTo,
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
}