import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';

/// A service to handle downloading and saving media files.
@lazySingleton
class DownloadService {
  static const String _downloadPathKey = 'download_path';

  final SharedPreferences _prefs;
  final Logger _logger;
  final Dio _dio;

  DownloadService({
    required SharedPreferences prefs,
    @Named("AppLogger") required Logger logger,
    required Dio dio,
  }) : _prefs = prefs,
       _logger = logger,
       _dio = dio;

  /// Returns the currently set download directory
  Future<String?> getDownloadDirectory() async {
    // First check if user has a saved directory
    String? savedDir = _prefs.getString(_downloadPathKey);

    if (savedDir != null && Directory(savedDir).existsSync()) {
      return savedDir;
    }

    // If not, use default directory by platform
    try {
      if (Platform.isAndroid) {
        // Use downloads folder on Android
        Directory? directory = await getExternalStorageDirectory();
        if (directory != null) {
          final downloadsDir = Directory('${directory.path}/Download');
          if (!downloadsDir.existsSync()) {
            await downloadsDir.create(recursive: true);
          }
          return downloadsDir.path;
        }
      } else if (Platform.isIOS) {
        // iOS doesn't have a "Downloads" folder concept like Android
        // but we can use the Documents directory
        Directory directory = await getApplicationDocumentsDirectory();
        final downloadsDir = Directory('${directory.path}/Downloads');
        if (!downloadsDir.existsSync()) {
          await downloadsDir.create(recursive: true);
        }
        return downloadsDir.path;
      } else if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
        // On desktop, use the Downloads folder
        final home =
            Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
        if (home != null) {
          final downloadDir = Directory('$home/Downloads');
          if (downloadDir.existsSync()) {
            return downloadDir.path;
          }
        }

        // Fall back to temp directory if Downloads doesn't exist
        Directory directory = await getTemporaryDirectory();
        return directory.path;
      }
    } catch (e) {
      _logger.e('Failed to get download directory', error: e);
    }

    // Last resort, use temporary directory
    try {
      Directory tempDir = await getTemporaryDirectory();
      return tempDir.path;
    } catch (e) {
      _logger.e('Failed to get temporary directory', error: e);
      return null;
    }
  }

  /// Allows the user to select a download directory
  /// Returns the selected path or null if cancelled
  Future<String?> selectDownloadDirectory() async {
    try {
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

      if (selectedDirectory != null) {
        // Save the selected directory
        await _prefs.setString(_downloadPathKey, selectedDirectory);
        _logger.i('Download directory set to: $selectedDirectory');
      }

      return selectedDirectory;
    } catch (e) {
      _logger.e('Error selecting download directory', error: e);
      return null;
    }
  }

  /// Check if storage permissions are granted
  /// Returns true if granted, false otherwise
  Future<bool> _checkPermissions() async {
    if (Platform.isAndroid || Platform.isIOS) {
      PermissionStatus status = await Permission.storage.status;

      if (status.isDenied) {
        status = await Permission.storage.request();
      }

      // On newer Android, we need to request media permissions
      if (Platform.isAndroid && await Permission.photos.isRestricted) {
        await Permission.photos.request();
      }

      // Adding media location permission for completeness
      if (Platform.isAndroid && await Permission.accessMediaLocation.isDenied) {
        await Permission.accessMediaLocation.request();
      }

      if (status.isPermanentlyDenied) {
        _logger.w('Storage permission permanently denied');
        return false;
      }

      return status.isGranted;
    }

    // For desktop platforms, permissions are not required
    return true;
  }

  /// Download and save media file from URL
  /// Returns true if successful, false otherwise
  Future<bool> saveMedia(String url, String suggestedFilename) async {
    // Check permissions first
    bool hasPermission = await _checkPermissions();
    if (!hasPermission) {
      _logger.w('Permission denied for saving media');
      return false;
    }

    // Get the download directory
    String? downloadPath = await getDownloadDirectory();
    if (downloadPath == null) {
      _logger.e('Failed to determine download directory');
      return false;
    }

    try {
      // Clean up the filename to make it filesystem-safe
      final cleanedFilename = _sanitizeFilename(suggestedFilename);

      // Create full destination path
      final fullPath = '$downloadPath/${cleanedFilename}';

      // Check if file exists, add number suffix if it does
      final File file = await _createUniqueFile(fullPath);

      // Download the file
      _logger.i('Downloading: $url to ${file.path}');

      final response = await _dio.download(
        url,
        file.path,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = (received / total * 100).toStringAsFixed(0);
            _logger.d('Download progress: $progress%');
          }
        },
      );

      if (response.statusCode == 200) {
        _logger.i('Download completed: ${file.path}');
        return true;
      } else {
        _logger.e('Download failed with status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      _logger.e('Error downloading file', error: e);
      return false;
    }
  }

  /// Download media to a temporary location for sharing
  /// Returns the downloaded file or null if unsuccessful
  Future<File?> downloadMediaToTemp(
    String url,
    String suggestedFilename,
  ) async {
    try {
      // Get temp directory
      final tempDir = await getTemporaryDirectory();
      final cleanedFilename = _sanitizeFilename(suggestedFilename);
      final tempPath = '${tempDir.path}/$cleanedFilename';

      // Create a unique file
      final File file = await _createUniqueFile(tempPath);

      // Download file
      final response = await _dio.download(url, file.path);

      if (response.statusCode == 200) {
        _logger.i('Downloaded temp file: ${file.path}');
        return file;
      } else {
        _logger.e('Failed to download temp file: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      _logger.e('Error creating temp file', error: e);
      return null;
    }
  }

  /// Sanitize filename to be safe for filesystems
  String _sanitizeFilename(String filename) {
    // Remove characters that are problematic in filenames
    var cleaned = filename
        .replaceAll(RegExp(r'[\\/:*?"<>|]'), '_')
        .replaceAll('\n', '')
        .replaceAll('\r', '');

    // Ensure it's not empty
    if (cleaned.isEmpty) {
      cleaned = 'download';
    }

    return cleaned;
  }

  /// Creates a unique file path by adding a suffix if file exists
  Future<File> _createUniqueFile(String filePath) async {
    File file = File(filePath);

    // If file doesn't exist, return it directly
    if (!await file.exists()) {
      return file;
    }

    // If file exists, add a number suffix
    final basename = path.basenameWithoutExtension(filePath);
    final extension = path.extension(filePath);
    final directory = path.dirname(filePath);

    int counter = 1;
    String newPath;

    do {
      newPath = '$directory/$basename($counter)$extension';
      file = File(newPath);
      counter++;
    } while (await file.exists());

    return file;
  }
}
