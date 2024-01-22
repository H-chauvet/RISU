import 'dart:async';

import 'package:flutter/material.dart';
import 'package:front/services/storage_service.dart';
import 'package:go_router/go_router.dart';

class MyAlertTest {
  static Future<void> checkSignInStatus(BuildContext context) async {
    dynamic object = await checkSignin(context);
    String title = object['title'];
    String message = object['message'];
    if (!object['isSignedIn']) {
      _showSignInAlertDialog(context, title, message);
    }
  }

  static Future<void> checkSignInStatusAdmin(BuildContext context) async {
    dynamic object = await checkSignInAdmin(context);
    String title = object['title'];
    String message = object['message'];
    if (!object['isSignedIn']) {
      _showSignInAlertDialog(context, title, message);
    }
  }

  static Widget loginButton(BuildContext context) {
    if ('title' == 'Connexion requise') {
      return TextButton(
        onPressed: () {
          context.go('/login');
        },
        child: const Text('Se connecter'),
      );
    } else {
      return Container();
    }
  }

  static void _showSignInAlertDialog(
      BuildContext context, String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
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
            loginButton(context),
          ],
        );
      },
    );
  }
}

Future<Map<String, dynamic>> checkSignin(BuildContext context) async {
  String? token = await storageService.readStorage('token');

  if (token == '') {
    return {
      'isSignedIn': false,
      'title': 'Connexion requise',
      'message': 'Vous devez être connecté à un compte pour poursuivre.'
    };
  }

  bool isUserVerified = await storageService.isUserVerified();
  if (!isUserVerified) {
    return {
      'isSignedIn': false,
      'title': 'Compte non vérifié',
      'message': 'Vous devez vérifier votre compte pour poursuivre'
    };
  }
  return {'isSignedIn': true, 'title': '', 'message': ''};
}

Future<Map<String, dynamic>> checkSignInAdmin(BuildContext context) async {
  String? token = await storageService.readStorage('token');
  String? userMail;
  if (token != '') {
    userMail = await storageService.getUserMail();
  }
  if (token != '' && userMail == "risu.admin@gmail.com") {
    return {'isSignedIn': true, 'title': '', 'message': ''};
  }
  return {
    'isSignedIn': false,
    'title': 'Connexion Administrateur requise',
    'message':
        "Vous devez être connecté en tant qu'Administrateur à un compte pour poursuivre."
  };
}
