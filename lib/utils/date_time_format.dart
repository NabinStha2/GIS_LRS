import 'package:intl/intl.dart';

class DateTimeFormat {
  static DateTime dateFormat(DateTime? input) => DateTime.parse(DateFormat("yyyyMMdd").format(input ?? DateTime.now()));

  static String timeAgoFormat(DateTime input) {
    Duration diff = DateTime.now().difference(input);
    if (diff.inDays > 365) {
      return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} ago";
    } else if (diff.inDays > 30) {
      return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} ago";
    } else if (diff.inDays > 7) {
      return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
    } else if (diff.inDays > 0) {
      return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago";
    } else if (diff.inHours > 0) {
      return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago";
    } else if (diff.inMinutes > 0) {
      return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago";
    }
    return "Just now";
  }

  static String timeFormat(DateTime? input) => DateFormat("h:mm a").format(input ?? DateTime.now());
}
