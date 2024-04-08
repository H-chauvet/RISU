import 'package:intl/intl.dart';

String formatDateTime(
    {required String dateTimeString, String locale = "fr_FR"}) {
  DateTime dateTime = DateTime.parse(dateTimeString);
  DateFormat formatter = DateFormat.yMd(locale).add_Hm();
  return formatter.format(dateTime);
}
