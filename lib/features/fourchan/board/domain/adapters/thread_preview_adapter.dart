import 'package:flutter/material.dart'; // For Icons
import 'package:vibechan/features/fourchan/domain/models/thread.dart';
import 'package:vibechan/shared/models/previewable_item.dart';
import 'package:vibechan/features/fourchan/domain/models/media.dart';

/// Extension to adapt a 4chan [Thread] to the generic [PreviewableItem] interface.
extension ThreadPreviewAdapter on Thread {
  PreviewableItem toPreviewableItem() {
    return _FourchanPreviewItemAdapter(this);
  }
}

// Private implementation class for the adapter
class _FourchanPreviewItemAdapter implements PreviewableItem {
  final Thread _thread;

  _FourchanPreviewItemAdapter(this._thread);

  @override
  String get id => _thread.id.toString();

  @override
  String? get subject => _thread.originalPost.subject;

  @override
  String? get commentSnippet => _thread.originalPost.comment;

  @override
  String? get mediaPreviewUrl => _thread.originalPost.media?.url;

  @override
  String? get thumbnailUrl => _thread.originalPost.media?.thumbnailUrl;

  @override
  double? get mediaAspectRatio {
    final media = _thread.originalPost.media;
    if (media != null && media.width > 0 && media.height > 0) {
      return media.width / media.height;
    }
    return 1.0; // Default aspect ratio
  }

  @override
  bool get isVideo => _thread.originalPost.media?.type == MediaType.video;

  @override
  Media? get mediaObject => _thread.originalPost.media;

  @override
  List<PreviewStatItem> get stats {
    final List<PreviewStatItem> items = [];
    items.add(
      PreviewStatItem(
        icon: Icons.comment,
        value: _thread.repliesCount.toString(),
      ),
    );
    items.add(
      PreviewStatItem(icon: Icons.image, value: _thread.imagesCount.toString()),
    );
    if (_thread.isSticky) {
      items.add(
        const PreviewStatItem(
          icon: Icons.push_pin,
          value: '',
          tooltip: 'Sticky',
        ),
      );
    }
    if (_thread.isClosed) {
      items.add(
        const PreviewStatItem(icon: Icons.lock, value: '', tooltip: 'Closed'),
      );
    }
    // Add more stats here if needed
    return items;
  }
}
