/// Formats a timestamp into a human-readable string.
///
/// Examples:
/// - "2 minutes ago"
/// - "1 hour ago"
/// - "2 days ago"
/// - "3 weeks ago"
/// - "2 months ago"
/// - "1 year ago"
/// - "Jan 15, 2024" (for dates older than 1 year)
String formatTimestamp(DateTime timestamp) {
  final now = DateTime.now();
  final difference = now.difference(timestamp);

  // If the date is more than a year old, show the full date
  if (difference.inDays > 365) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[timestamp.month - 1]} ${timestamp.day}, ${timestamp.year}';
  }

  // If the date is more than a month old, show months
  if (difference.inDays > 30) {
    final months = (difference.inDays / 30).floor();
    return '$months ${months == 1 ? 'month' : 'months'} ago';
  }

  // If the date is more than a week old, show weeks
  if (difference.inDays > 7) {
    final weeks = (difference.inDays / 7).floor();
    return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
  }

  // If the date is more than a day old, show days
  if (difference.inDays > 0) {
    return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
  }

  // If the date is more than an hour old, show hours
  if (difference.inHours > 0) {
    return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
  }

  // If the date is more than a minute old, show minutes
  if (difference.inMinutes > 0) {
    return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
  }

  // If less than a minute, show "just now"
  return 'just now';
}
