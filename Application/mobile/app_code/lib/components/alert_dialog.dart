import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:risu/utils/colors.dart';
import 'package:risu/utils/providers/theme.dart';

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
          titleTextStyle: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
          backgroundColor: context.select((ThemeProvider themeProvider) =>
              themeProvider.currentTheme.dialogTheme.backgroundColor),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              key: const Key('alertdialog-button_ok'),
              child: Text(AppLocalizations.of(context)!.ok),
            ),
          ],
        );
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
              child: Text(AppLocalizations.of(context)!.ok),
            ),
          ],
        );
      },
    );
  }

  static Future<bool> showChoiceAlertDialog({
    Key? key,
    required BuildContext context,
    required String title,
    required String message,
    String? onOkName,
    String? onCancelName,
  }) {
    Completer<bool> completer = Completer<bool>();
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        onOkName = onOkName ?? AppLocalizations.of(context)!.ok;
        onCancelName = onCancelName ?? AppLocalizations.of(context)!.cancel;
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
              key: const Key('alertdialog-button_cancel'),
              child: Text(
                onCancelName!,
                style: const TextStyle(
                  color: MyColors.alertDialogChoiceCancel,
                ),
              ),
              onPressed: () {
                Navigator.pop(context, false);
                completer.complete(false);
              },
            ),
            TextButton(
              child: Text(onOkName!,
                  key: const Key('alertdialog-button_ok'),
                  style: TextStyle(
                      color: context.select((ThemeProvider themeProvider) =>
                          themeProvider.currentTheme.dialogTheme.titleTextStyle
                              ?.color))),
              onPressed: () {
                Navigator.pop(context, true);
                completer.complete(true);
              },
            ),
          ],
        );
      },
    );
    return completer.future;
  }
}
