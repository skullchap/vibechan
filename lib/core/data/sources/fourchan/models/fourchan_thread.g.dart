// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fourchan_thread.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FourChanThread _$FourChanThreadFromJson(Map<String, dynamic> json) =>
    _FourChanThread(
      no: (json['no'] as num?)?.toInt() ?? 0,
      resto: (json['resto'] as num?)?.toInt() ?? 0,
      sticky: (json['sticky'] as num?)?.toInt() ?? 0,
      closed: (json['closed'] as num?)?.toInt() ?? 0,
      now: json['now'] as String?,
      time: (json['time'] as num?)?.toInt() ?? 0,
      lastModified: (json['last_modified'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? 'Anonymous',
      trip: json['trip'] as String?,
      id: json['id'] as String?,
      capcode: json['capcode'] as String?,
      country: json['country'] as String?,
      countryName: json['country_name'] as String?,
      boardFlag: json['board_flag'] as String?,
      flagName: json['flag_name'] as String?,
      sub: json['sub'] as String?,
      com: json['com'] as String? ?? '',
      tim: (json['tim'] as num?)?.toInt() ?? 0,
      filename: json['filename'] as String?,
      ext: json['ext'] as String?,
      fsize: (json['fsize'] as num?)?.toInt() ?? 0,
      md5: json['md5'] as String?,
      w: (json['w'] as num?)?.toInt() ?? 0,
      h: (json['h'] as num?)?.toInt() ?? 0,
      tnW: (json['tn_w'] as num?)?.toInt() ?? 0,
      tnH: (json['tn_h'] as num?)?.toInt() ?? 0,
      filedeleted: (json['filedeleted'] as num?)?.toInt() ?? 0,
      spoiler: (json['spoiler'] as num?)?.toInt() ?? 0,
      customSpoiler: (json['custom_spoiler'] as num?)?.toInt() ?? 0,
      omittedPosts: (json['omitted_posts'] as num?)?.toInt() ?? 0,
      omittedImages: (json['omitted_images'] as num?)?.toInt() ?? 0,
      replies: (json['replies'] as num?)?.toInt() ?? 0,
      images: (json['images'] as num?)?.toInt() ?? 0,
      bumplimit: (json['bumplimit'] as num?)?.toInt() ?? 0,
      imagelimit: (json['imagelimit'] as num?)?.toInt() ?? 0,
      semanticUrl: json['semantic_url'] as String?,
      since4pass: (json['since4pass'] as num?)?.toInt() ?? 0,
      mImg: (json['m_img'] as num?)?.toInt() ?? 0,
      archived: (json['archived'] as num?)?.toInt() ?? 0,
      archivedOn: (json['archived_on'] as num?)?.toInt() ?? 0,
      posts:
          (json['posts'] as List<dynamic>?)
              ?.map((e) => FourChanPost.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      lastReplies:
          (json['last_replies'] as List<dynamic>?)
              ?.map((e) => FourChanPost.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$FourChanThreadToJson(_FourChanThread instance) =>
    <String, dynamic>{
      'no': instance.no,
      'resto': instance.resto,
      'sticky': instance.sticky,
      'closed': instance.closed,
      'now': instance.now,
      'time': instance.time,
      'last_modified': instance.lastModified,
      'name': instance.name,
      'trip': instance.trip,
      'id': instance.id,
      'capcode': instance.capcode,
      'country': instance.country,
      'country_name': instance.countryName,
      'board_flag': instance.boardFlag,
      'flag_name': instance.flagName,
      'sub': instance.sub,
      'com': instance.com,
      'tim': instance.tim,
      'filename': instance.filename,
      'ext': instance.ext,
      'fsize': instance.fsize,
      'md5': instance.md5,
      'w': instance.w,
      'h': instance.h,
      'tn_w': instance.tnW,
      'tn_h': instance.tnH,
      'filedeleted': instance.filedeleted,
      'spoiler': instance.spoiler,
      'custom_spoiler': instance.customSpoiler,
      'omitted_posts': instance.omittedPosts,
      'omitted_images': instance.omittedImages,
      'replies': instance.replies,
      'images': instance.images,
      'bumplimit': instance.bumplimit,
      'imagelimit': instance.imagelimit,
      'semantic_url': instance.semanticUrl,
      'since4pass': instance.since4pass,
      'm_img': instance.mImg,
      'archived': instance.archived,
      'archived_on': instance.archivedOn,
      'posts': instance.posts.map((e) => e.toJson()).toList(),
      'last_replies': instance.lastReplies.map((e) => e.toJson()).toList(),
    };
