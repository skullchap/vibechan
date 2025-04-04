// Remove intl import
// import 'package:intl/intl.dart';

/// Formats a DateTime into a relative time string (e.g., "5 minutes ago").
/// English only, simplified logic. No external dependencies.
String formatTimeAgoSimple(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inSeconds < 60) {
    // Handle pluralization simply
    final s = difference.inSeconds == 1 ? '' : 's';
    return '${difference.inSeconds} second$s ago';
  } else if (difference.inMinutes < 60) {
    final s = difference.inMinutes == 1 ? '' : 's';
    return '${difference.inMinutes} minute$s ago';
  } else if (difference.inHours < 24) {
    final s = difference.inHours == 1 ? '' : 's';
    return '${difference.inHours} hour$s ago';
  } else if (difference.inDays < 7) {
    final s = difference.inDays == 1 ? '' : 's';
    return '${difference.inDays} day$s ago';
  } else {
    // Fallback to MM/DD/YYYY format
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    final year = dateTime.year;
    return '$month/$day/$year';
  }
}

/// Formats a timestamp for display in list cards and detail views.
///
/// Takes a DateTime object or Unix timestamp (int/double) and returns a
/// formatted string. For recent dates it shows relative time (e.g., "2 hours ago"),
/// and for older dates it shows the date in a standard format.
///
/// If [useShortFormat] is true, it uses more compact representations.
String formatTimestamp(dynamic timestamp, {bool useShortFormat = false}) {
  DateTime dateTime;

  if (timestamp is DateTime) {
    dateTime = timestamp;
  } else if (timestamp is int) {
    // Assuming Unix timestamp in seconds
    dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  } else if (timestamp is double) {
    // Assuming Unix timestamp in seconds with millisecond precision
    dateTime = DateTime.fromMillisecondsSinceEpoch((timestamp * 1000).toInt());
  } else if (timestamp is String) {
    // Try to parse as ISO 8601 format
    try {
      dateTime = DateTime.parse(timestamp);
    } catch (e) {
      return 'Invalid date';
    }
  } else {
    return 'Invalid date';
  }

  final now = DateTime.now();
  final difference = now.difference(dateTime);

  // For very recent times
  if (difference.inMinutes < 1) {
    return useShortFormat ? 'now' : 'Just now';
  }

  // For times within the last day, use relative format
  if (difference.inHours < 24) {
    if (difference.inMinutes < 60) {
      final m = difference.inMinutes;
      return useShortFormat ? '${m}m' : '$m min${m == 1 ? '' : 's'} ago';
    } else {
      final h = difference.inHours;
      return useShortFormat ? '${h}h' : '$h hour${h == 1 ? '' : 's'} ago';
    }
  }

  // For times within the last week
  if (difference.inDays < 7) {
    final d = difference.inDays;
    return useShortFormat ? '${d}d' : '$d day${d == 1 ? '' : 's'} ago';
  }

  // For older dates, use a standard date format
  final day = dateTime.day.toString().padLeft(2, '0');
  final month = dateTime.month.toString().padLeft(2, '0');
  final year = dateTime.year.toString();

  if (useShortFormat) {
    // Shorter format for space-constrained UI
    return '$month/$day/${year.substring(2)}';
  } else {
    // Standard format
    return '$month/$day/$year';
  }
}
