import 'package:flutter/material.dart';
import 'package:risu/components/alert_dialog.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/login/login_page.dart';

Function checkSignin = (BuildContext context) async {
  if (userInformation?.email == null) {
    MyAlertDialog.showChoiceAlertDialog(
      context: context,
      title: 'Connexion requise',
      message: 'Vous devez êtres connecté à un compte pour poursuivre.',
      onOkName: 'Me connecter',
      onCancelName: 'Annuler',
    ).then(
      (value) => {
        if (value)
          {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const LoginPage();
                },
              ),
            ),
          }
      },
    );
    return false;
  }
  return true;
};
