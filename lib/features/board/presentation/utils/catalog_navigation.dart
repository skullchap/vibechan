import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibechan/core/domain/models/thread.dart';
import 'package:vibechan/shared/providers/tab_manager_provider.dart';

/// Navigates to the selected thread detail view.
void navigateToThread(WidgetRef ref, String boardId, Thread thread) {
  final tabNotifier = ref.read(tabManagerProvider.notifier);
  final threadTitle =
      thread.originalPost.subject?.isNotEmpty == true
          ? thread.originalPost.subject!
          : 'Thread #${thread.id}';

  tabNotifier.navigateToOrReplaceActiveTab(
    title: threadTitle,
    initialRouteName: 'thread',
    pathParameters: {'boardId': boardId, 'threadId': thread.id.toString()},
    icon: Icons.comment,
  );
}
