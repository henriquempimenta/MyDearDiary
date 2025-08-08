String formatRelativeTime(DateTime dateTime) {
  final Duration difference = DateTime.now().difference(dateTime);

  if (difference.inMinutes < 1) {
    return 'now';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} minutes ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} hours ago';
  } else if (difference.inDays < 7) {
    return '${difference.inDays} days ago';
  } else if (difference.inDays < 30) {
    return '${(difference.inDays / 7).round()} weeks ago';
  } else if (difference.inDays < 365) {
    return '${(difference.inDays / 30).round()} months ago';
  } else {
    return '${(difference.inDays / 365).round()} years ago';
  }
}
