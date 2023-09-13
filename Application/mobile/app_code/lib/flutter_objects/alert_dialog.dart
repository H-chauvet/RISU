import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/theme.dart';

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
            titleTextStyle: context.select((ThemeProvider themeProvider) =>
                themeProvider.currentTheme.dialogTheme.titleTextStyle),
            backgroundColor: context.select((ThemeProvider themeProvider) =>
                themeProvider.currentTheme.dialogTheme.backgroundColor),
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
            titleTextStyle: context.select((ThemeProvider themeProvider) =>
                themeProvider.currentTheme.dialogTheme.titleTextStyle),
            backgroundColor: context.select((ThemeProvider themeProvider) =>
                themeProvider.currentTheme.dialogTheme.backgroundColor),
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
