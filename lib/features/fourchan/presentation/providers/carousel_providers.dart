import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vibechan/features/fourchan/domain/models/media.dart';
import './board_providers.dart';
import './thread_providers.dart';

part 'carousel_providers.g.dart';

@riverpod
Future<List<Media>> carouselMediaList(Ref ref, String sourceInfo) async {
  final parts = sourceInfo.split(':');
  if (parts.length < 2) {
    throw ArgumentError('Invalid sourceInfo format: $sourceInfo');
  }
  final sourceName = parts[0];
  final argsString = parts[1];
  final sourceArgs = argsString.split('/');

  if (sourceName == '4chan') {
    if (sourceArgs.isEmpty) {
      throw ArgumentError('Missing boardId for 4chan source');
    }
    final boardId = sourceArgs[0];

    if (sourceArgs.length > 1) {
      final threadId = sourceArgs[1];
      try {
        final repository = ref.read(threadRepositoryProvider);
        return repository.getAllMediaFromThreadContext(boardId, threadId);
      } catch (e) {
        print('Error getting ThreadRepository for $sourceName: $e');
        rethrow;
      }
    } else {
      try {
        final repository = ref.read(boardRepositoryProvider);
        return repository.getAllMediaFromBoard(boardId);
      } catch (e) {
        print('Error getting BoardRepository for $sourceName: $e');
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
  final parts = sourceInfo.split(':');
  if (parts.length < 2) return false;
  final sourceName = parts[0];
  final boardId = parts[1];

  try {
    final repository = ref.read(boardRepositoryProvider);
    return await repository.boardHasMedia(boardId);
  } catch (e) {
    print('Error checking board media for $sourceName: $e');
    return false;
  }
}

@riverpod
Future<bool> threadHasMedia(Ref ref, String sourceInfo) async {
  final parts = sourceInfo.split(':');
  if (parts.length < 2) return false;
  final sourceName = parts[0];
  final args = parts[1].split('/');
  if (args.length < 2) return false;
  final boardId = args[0];
  final threadId = args[1];

  try {
    final repository = ref.read(threadRepositoryProvider);
    return await repository.threadHasMedia(boardId, threadId);
  } catch (e) {
    print('Error checking thread media for $sourceName: $e');
    return false;
  }
}
