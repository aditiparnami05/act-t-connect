import 'package:intl/intl.dart';

/// Date formatting utilities.
abstract final class DateFormatter {
  static final DateFormat _display = DateFormat('dd MMM yyyy');
  static final DateFormat _displayTime = DateFormat('dd MMM yyyy, hh:mm a');
  static final DateFormat _short = DateFormat('dd/MM/yy');

  static String display(DateTime date) => _display.format(date);
  static String displayWithTime(DateTime date) => _displayTime.format(date);
  static String short(DateTime date) => _short.format(date);
}
