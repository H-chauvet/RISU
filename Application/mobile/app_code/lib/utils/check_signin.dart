import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:risu/components/alert_dialog.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/login/login_page.dart';

Function checkSignin = (BuildContext context) async {
  if (userInformation == null) {
    bool isUserSignedIn = await MyAlertDialog.showChoiceAlertDialog(
      context: context,
      key: const Key('check_sign_in-alert_dialog-required_auth'),
      title: AppLocalizations.of(context)!.connectionRequired,
      message: AppLocalizations.of(context)!.signInRequired,
      onOkName: AppLocalizations.of(context)!.signIn,
      onCancelName: AppLocalizations.of(context)!.cancel,
    );

    if (isUserSignedIn && context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const LoginPage();
          },
        ),
      );
    }
    return false;
  }
  return true;
};
