import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risu/utils/theme.dart';

class MyAlertDialog {
  static Future<void> showErrorAlertDialog({
    Key? key,
    required BuildContext context,
    required String title,
    required String message,
  }) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            key: key,
            title: Text(title),
            titlePadding: const EdgeInsets.all(16.0),
            titleTextStyle: context.select((ThemeProvider themeProvider) =>
                themeProvider.currentTheme.dialogTheme.titleTextStyle),
            backgroundColor: context.select((ThemeProvider themeProvider) =>
                themeProvider.currentTheme.dialogTheme.backgroundColor),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                key: const Key('alertdialog-button_ok'),
                child: const Text('OK'),
              ),
            ]);
      },
    );
  }

  static Future<void> showInfoAlertDialog({
    Key? key,
    required BuildContext context,
    required String title,
    required String message,
  }) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            key: key,
            title: Text(title),
            titlePadding: const EdgeInsets.all(16.0),
            titleTextStyle: context.select((ThemeProvider themeProvider) =>
                themeProvider.currentTheme.dialogTheme.titleTextStyle),
            backgroundColor: context.select((ThemeProvider themeProvider) =>
                themeProvider.currentTheme.dialogTheme.backgroundColor),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                key: const Key('alertdialog-button_ok'),
                child: const Text('OK'),
              ),
            ]);
      },
    );
  }

  static Future<void> showChoiceAlertDialog({
    required BuildContext context,
    required String title,
    required String message,
    String onOkName = 'OK',
    required VoidCallback onOk,
    String onCancelName = 'Cancel',
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
              child: Text(onCancelName),
              onPressed: () => Navigator.pop(context, 'Ok'),
            ),
            TextButton(
              child: Text(onOkName),
              onPressed: () {
                onOk();
              },
            ),
          ],
        );
      },
    );
  }
}
