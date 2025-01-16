import 'package:intl/intl.dart';

class TimeHelper {
  static DateTime parseDateTime(String dateTimeString) {
    return DateTime.parse(dateTimeString);
  }

  static String formatDate(String dateTimeString) {
    DateTime dateTime = parseDateTime(dateTimeString);
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  static String formatTime(String dateTimeString) {
    DateTime dateTime = parseDateTime(dateTimeString);
    return DateFormat('HH:mm').format(dateTime);
  }

  static String formatDateTime(String dateTimeString) {
    DateTime dateTime = parseDateTime(dateTimeString);
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  static String formatFullDate(String dateTimeString) {
    DateTime dateTime = parseDateTime(dateTimeString);
    return DateFormat('MMMM dd, yyyy').format(dateTime);
  }

  static String formatFullTime(String dateTimeString) {
    DateTime dateTime = parseDateTime(dateTimeString);
    return DateFormat('h:mm a').format(dateTime);
  }
}
