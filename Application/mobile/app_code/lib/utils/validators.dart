import 'package:flutter/widgets.dart';

class Validators {
  String? phoneNumber(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your phone number.";
    }
    final RegExp phoneRegex = RegExp(
      r"^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$",
    );
    if (!phoneRegex.hasMatch(value)) {
      return "Please enter a valid phone number.";
    }
    return null;
  }

  String? email(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your email.";
    }
    final RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$",
    );
    if (!emailRegex.hasMatch(value)) {
      return "Please enter a valid email.";
    }
    return null;
  }

  String? date(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter a date.";
    }
    final dateRegex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
    if (!dateRegex.hasMatch(value)) {
      return "Invalid date format. Please use the format \"dd/mm/yyyy\"";
    }
    final dateParts = value.split('/');
    final day = int.tryParse(dateParts[0]);
    final month = int.tryParse(dateParts[1]);
    final year = int.tryParse(dateParts[2]);

    if (day == null || month == null || year == null) {
      return "Invalid date format. Please use the format \"dd/mm/yyyy\"";
    }
    if (month < 1 || month > 12) {
      return "Invalid month. Please enter a value between 1 and 12";
    }
    final daysInMonth = DateTime(year, month + 1, 0).day;
    if (day < 1 || day > daysInMonth) {
      return "Invalid day. Please enter a value between 1 and $daysInMonth";
    }
    return null; // The date is valid
  }

  String? notEmpty(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return "This field is required";
    }
    return null;
  }
}
