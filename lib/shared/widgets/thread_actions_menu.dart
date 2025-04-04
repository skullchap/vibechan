import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibechan/shared/enums/news_source.dart';
import 'package:vibechan/shared/services/thread_url_service.dart';

/// A widget that provides actions for opening threads in external browsers
class ThreadActionsButton extends StatelessWidget {
  /// The source platform of the thread
  final NewsSource? source;

  /// The board ID (for 4chan)
  final String? boardId;

  /// The thread ID (for 4chan)
  final String? threadId;

  /// The item ID (for HackerNews or Lobsters)
  final String? itemId;

  /// Icon size for the button
  final double iconSize;

  /// Custom icon to use
  final IconData? icon;

  /// Whether to show as a menu button or simple button
  final bool showAsMenu;

  const ThreadActionsButton({
    super.key,
    this.source,
    this.boardId,
    this.threadId,
    this.itemId,
    this.iconSize = 20,
    this.icon,
    this.showAsMenu = true,
  });

  @override
  Widget build(BuildContext context) {
    if (showAsMenu) {
      return PopupMenuButton<String>(
        icon: Icon(icon ?? Icons.more_vert, size: iconSize),
        tooltip: 'Thread actions',
        onSelected: (action) {
          if (action == 'open_browser') {
            _openInBrowser();
          }
        },
        itemBuilder:
            (context) => [
              const PopupMenuItem(
                value: 'open_browser',
                child: Row(
                  children: [
                    Icon(Icons.open_in_browser),
                    SizedBox(width: 8),
                    Text('Open in browser'),
                  ],
                ),
              ),
            ],
      );
    } else {
      return IconButton(
        icon: Icon(icon ?? Icons.open_in_browser, size: iconSize),
        tooltip: 'Open in browser',
        onPressed: () => _openInBrowser(),
      );
    }
  }

  void _openInBrowser() async {
    try {
      String url = ThreadUrlService.getExternalUrl(
        source: source,
        boardId: boardId,
        threadId: threadId,
        itemId: itemId,
      );

      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Error opening URL: $e');
    }
  }
}
