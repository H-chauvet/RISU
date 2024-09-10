import 'package:intl/intl.dart';
import 'package:risu/globals.dart';

/// Format date time string to a readable format
/// params:
/// [dateTimeString] - date time string
String formatDateTime({required String dateTimeString}) {
  DateTime dateTime = DateTime.parse(dateTimeString);
  DateFormat formatter = DateFormat.yMd(language).add_Hm();
  return formatter.format(dateTime);
}
