import 'dart:async';

import 'package:flutter/material.dart';
import 'package:front/main.dart';
import 'package:front/screens/landing-page/landing_page.dart';
import 'package:front/screens/login/login.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:go_router/go_router.dart';
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
    String message =
        "Vous devez être connecté en tant qu'Administrateur à un compte pour poursuivre.";
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
                Navigator.pop(context);
                context.go('/');
              },
              child: const Text("Retour à l'accueil"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.go('/login');
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
  String? token = await storageService.readStorage('token');

  if (token == '') {
    return false;
  }

  bool isUserVerified = await storageService.isUserVerified();
  if (!isUserVerified) {
    return false;
  }
  return true;
}

Future<bool> checkSignInAdmin(BuildContext context) async {
  String? token = await storageService.readStorage('token');
  String? userMail;
  if (token != '') {
    userMail = await storageService.getUserMail();
  }
  if (token != '' && userMail == "risu.admin@gmail.com") {
    return true;
  }
  return false;
}
