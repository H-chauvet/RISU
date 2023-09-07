import 'package:flutter/material.dart';

import '../utils/colors.dart';

class MyAlertDialog {
  static Future<void> showErrorAlertDialog({
    required BuildContext context,
    required String title,
    required String message,
  }) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text(title),
            titlePadding: const EdgeInsets.all(16.0),
            titleTextStyle: const TextStyle(
              color: MyColors.alertDialogErrorTitle,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
            content: Text(message),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context, 'OK'),
              ),
            ]);
      },
    );
  }

  static Future<void> showInfoAlertDialog({
    required BuildContext context,
    required String title,
    required String message,
  }) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text(title),
            titlePadding: const EdgeInsets.all(16.0),
            titleTextStyle: const TextStyle(
              color: MyColors.alertDialogInfoTitle,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
            content: Text(message),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context, 'OK'),
              ),
            ]);
      },
    );
  }
}
