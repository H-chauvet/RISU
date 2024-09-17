import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:risu/utils/colors.dart';
import 'package:risu/utils/providers/theme.dart';

/// Class to show alert dialog.
class MyAlertDialog {
  /// Show error alert dialog.
  /// Using custom title and message.
  /// params:
  /// [context] - context of the widget.
  /// [title] - title of the alert dialog.
  /// [message] - message of the alert dialog.
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

  /// Show info alert dialog.
  /// Using custom title and message.
  /// params:
  /// [context] - context of the widget.
  /// [title] - title of the alert dialog.
  /// [message] - message of the alert dialog.
  /// [barrierDismissible] - whether the dialog is dismissible.
  /// true - dialog can be dismissed by tapping outside the dialog.
  /// false - dialog can only be dismissed by tapping on the buttons.
  static Future<void> showInfoAlertDialog({
    Key? key,
    required BuildContext context,
    required String title,
    required String message,
    bool barrierDismissible = true,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
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

  /// Show choice alert dialog.
  /// Using custom title and message, with custom button.
  /// params:
  /// [context] - context of the widget.
  /// [title] - title of the alert dialog.
  /// [message] - message of the alert dialog.
  /// [onOkName] - name of the button.
  /// [onCancelName] - name of the button.
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
