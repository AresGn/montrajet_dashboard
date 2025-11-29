import 'package:intl/intl.dart';

class DateFormatter {
  static final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  static final DateFormat _timeFormat = DateFormat('HH:mm:ss');
  static final DateFormat _dateTimeFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
  static final DateFormat _dayNameFormat = DateFormat('EEEE', 'fr_FR');
  static final DateFormat _monthNameFormat = DateFormat('MMMM', 'fr_FR');

  /// Format date as dd/MM/yyyy
  static String formatDate(DateTime date) {
    return _dateFormat.format(date);
  }

  /// Format time as HH:mm:ss
  static String formatTime(DateTime dateTime) {
    return _timeFormat.format(dateTime);
  }

  /// Format datetime as dd/MM/yyyy HH:mm:ss
  static String formatDateTime(DateTime dateTime) {
    return _dateTimeFormat.format(dateTime);
  }

  /// Format datetime as HH:mm
  static String formatTimeHM(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  /// Get day name (e.g., "Lundi")
  static String getDayName(DateTime date) {
    return _dayNameFormat.format(date);
  }

  /// Get month name (e.g., "Janvier")
  static String getMonthName(DateTime date) {
    return _monthNameFormat.format(date);
  }

  /// Check if two dates are the same day
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Get relative time (e.g., "2 hours ago")
  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final duration = now.difference(dateTime);

    if (duration.inSeconds < 60) {
      return 'À l\'instant';
    } else if (duration.inMinutes < 60) {
      return 'il y a ${duration.inMinutes} min';
    } else if (duration.inHours < 24) {
      return 'il y a ${duration.inHours}h';
    } else if (duration.inDays < 7) {
      return 'il y a ${duration.inDays}j';
    } else {
      return formatDate(dateTime);
    }
  }

  /// Parse French date string to DateTime
  static DateTime? parseDate(String dateString) {
    try {
      return _dateFormat.parse(dateString);
    } catch (e) {
      return null;
    }
  }
}
