import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
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
    final logger = GetIt.instance<Logger>(
      instanceName: "AppLogger",
    ); // Get logger

    if (showAsMenu) {
      return PopupMenuButton<String>(
        icon: Icon(icon ?? Icons.more_vert, size: iconSize),
        tooltip: 'Thread actions',
        onSelected: (action) {
          if (action == 'open_browser') {
            _openInBrowser(context, logger);
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
        onPressed: () => _openInBrowser(context, logger),
      );
    }
  }

  void _openInBrowser(BuildContext context, Logger logger) async {
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
      } else {
        logger.w('Could not launch URL: $url'); // Use logger
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Could not open URL: $url')));
        }
      }
    } catch (e) {
      logger.e('Error opening URL', error: e); // Use logger
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error opening URL: $e')));
      }
    }
  }
}
