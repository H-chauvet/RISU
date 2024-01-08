import 'dart:async';

import 'package:flutter/material.dart';
import 'package:front/screens/landing-page/landing_page.dart';
import 'package:front/screens/login/login.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:provider/provider.dart';

class MyAlertTest {
  static Future<void> checkSignInStatus(BuildContext context) async {
    bool isSignedIn = await checkSignin(context);
    String title = 'Connexion requise';
    String message = 'Vous devez être connecté à un compte pour poursuivre.';
    if (!isSignedIn) {
      _showSignInAlertDialog(context, title, message);
    }
  }

  static Future<void> checkSignInStatusAdmin(BuildContext context) async {
    bool isSignedIn = await checkSignInAdmin(context);
    String title = 'Connexion Administrateur requise';
    String message = "Vous devez être connecté en tant qu'Administrateur à un compte pour poursuivre.";
    if (!isSignedIn) {
      _showSignInAlertDialog(context, title, message);
    }
  }

  static void _showSignInAlertDialog(
      BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          titlePadding: const EdgeInsets.all(16.0),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const LandingPage();
                    },
                  ),
                );
              },
              child: const Text("Retour à l'accueil"),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const LoginScreen();
                    },
                  ),
                );
              },
              child: const Text('Se connecter'),
            ),
          ],
        );
      },
    );
  }
}

Future<bool> checkSignin(BuildContext context) async {
  if (token.isEmpty) {
    return false;
  }
  return true;
}

Future<bool> checkSignInAdmin(BuildContext context) async {
  if (token.isNotEmpty && userMail == "risu.admin@gmail.com") {
    return true;
  }
  return false;
}

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
            backgroundColor: Colors.blue,
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
            backgroundColor: Colors.blue,
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

  static Future<bool> showChoiceAlertDialog({
    Key? key,
    required BuildContext context,
    required String title,
    required String message,
    String onOkName = 'OK',
    String onCancelName = 'Cancel',
  }) {
    Completer<bool> completer = Completer<bool>();
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          key: key,
          title: Text(title),
          titlePadding: const EdgeInsets.all(16.0),
          backgroundColor: Colors.blue,
          content: Text(message),
          actions: [
            TextButton(
              key: const Key('alertdialog-button_cancel'),
              child: Text(
                onCancelName,
                style: const TextStyle(
                  color: Colors.blue,
                ),
              ),
              onPressed: () {
                Navigator.pop(context, false);
                completer.complete(false);
              },
            ),
            TextButton(
              child: Text(onOkName,
                  key: const Key('alertdialog-button_ok'),
                  style: TextStyle(color: Colors.blue)),
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

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String message;

  const CustomAlertDialog({
    Key? key,
    required this.title,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AlertDialog(
        title: Text(title),
        titlePadding: const EdgeInsets.all(16.0),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const LandingPage();
                  },
                ),
              );
            },
            child: const Text("Retour à l'accueil"),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen();
                  },
                ),
              );
            },
            child: const Text('Se connecter'),
          ),
        ],
      ),
    );
  }
}
