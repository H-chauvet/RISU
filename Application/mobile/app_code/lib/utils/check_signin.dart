import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:risu/components/alert_dialog.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/login/login_page.dart';

/// Check if user is signed in
/// If not, show an alert dialog and navigate to the sign in page
/// params:
/// [context] - the context of the widget
Function checkSignin = (BuildContext context) async {
  if (userInformation == null) {
    bool dialogConfirm = await MyAlertDialog.showChoiceAlertDialog(
      context: context,
      key: const Key('check_sign_in-alert_dialog-required_auth'),
      title: AppLocalizations.of(context)!.connectionRequired,
      message: AppLocalizations.of(context)!.signInRequired,
      onOkName: AppLocalizations.of(context)!.signIn,
      onCancelName: AppLocalizations.of(context)!.cancel,
    );

    if (dialogConfirm && context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const LoginPage(
              keepPath: true,
            );
          },
        ),
      );
    }
    return false;
  }
  return true;
};

/// Check if the token is expired
/// params:
/// [context] - the context of the widget
Function tokenExpiredShowDialog = (BuildContext context) async {
  userInformation = null;
  await MyAlertDialog.showInfoAlertDialog(
    context: context,
    key: const Key('token_expired-alert_dialog'),
    barrierDismissible: false,
    title: AppLocalizations.of(context)!.error,
    message: AppLocalizations.of(context)!.sessionExpired,
  );

  if (context.mounted) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const LoginPage(
            keepPath: false,
          );
        },
      ),
      (route) => false,
    );
    return false;
  }
  return true;
};
