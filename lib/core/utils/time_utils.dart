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
