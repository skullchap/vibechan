import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vibechan/features/fourchan/domain/models/media.dart';
import './board_providers.dart';
import './thread_providers.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

part 'carousel_providers.g.dart';

@riverpod
Future<List<Media>> carouselMediaList(Ref ref, String sourceInfo) async {
  final logger = GetIt.instance<Logger>(instanceName: "AppLogger");
  final parts = sourceInfo.split(':');
  if (parts.length < 2) {
    throw ArgumentError('Invalid sourceInfo format: $sourceInfo');
  }
  final sourceName = parts[0];
  final argsString = parts[1];
  final sourceArgs = argsString.split('/');

  // Support both '4chan' and 'boards' as source names for 4chan content
  if (sourceName == '4chan' || sourceName == 'boards') {
    if (sourceArgs.isEmpty) {
      throw ArgumentError('Missing boardId for ${sourceName} source');
    }
    final boardId = sourceArgs[0];

    if (sourceArgs.length > 1) {
      final threadId = sourceArgs[1];
      try {
        final repository = ref.read(threadRepositoryProvider);
        logger.d(
          'Getting media from thread context: $boardId/$threadId (source: $sourceName)',
        );
        return repository.getAllMediaFromThreadContext(boardId, threadId);
      } catch (e) {
        logger.e('Error getting ThreadRepository for $sourceName', error: e);
        rethrow;
      }
    } else {
      try {
        final repository = ref.read(boardRepositoryProvider);
        logger.d('Getting media from board: $boardId (source: $sourceName)');
        return repository.getAllMediaFromBoard(boardId);
      } catch (e) {
        logger.e('Error getting BoardRepository for $sourceName', error: e);
        rethrow;
      }
    }
  } else if (sourceName == 'hackernews' || sourceName == 'lobsters') {
    return [];
  } else {
    throw ArgumentError('Unsupported source name: $sourceName');
  }
}

@riverpod
Future<bool> boardHasMedia(Ref ref, String sourceInfo) async {
  final logger = GetIt.instance<Logger>(instanceName: "AppLogger");
  final parts = sourceInfo.split(':');
  if (parts.length < 2) return false;
  final sourceName = parts[0];
  final boardId = parts[1];

  // Support both '4chan' and 'boards' as source names
  if (sourceName != '4chan' && sourceName != 'boards') {
    logger.w('boardHasMedia called with unsupported source: $sourceName');
    return false;
  }

  try {
    final repository = ref.read(boardRepositoryProvider);
    return await repository.boardHasMedia(boardId);
  } catch (e) {
    logger.e('Error checking board media for $sourceName', error: e);
    return false;
  }
}

@riverpod
Future<bool> threadHasMedia(Ref ref, String sourceInfo) async {
  final logger = GetIt.instance<Logger>(instanceName: "AppLogger");
  final parts = sourceInfo.split(':');
  if (parts.length < 2) return false;
  final sourceName = parts[0];
  final args = parts[1].split('/');
  if (args.length < 2) return false;
  final boardId = args[0];
  final threadId = args[1];

  // Support both '4chan' and 'boards' as source names
  if (sourceName != '4chan' && sourceName != 'boards') {
    logger.w('threadHasMedia called with unsupported source: $sourceName');
    return false;
  }

  try {
    final repository = ref.read(threadRepositoryProvider);
    return await repository.threadHasMedia(boardId, threadId);
  } catch (e) {
    logger.e('Error checking thread media for $sourceName', error: e);
    return false;
  }
}
