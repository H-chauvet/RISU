import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:front/services/storage_service.dart';
import 'package:go_router/go_router.dart';

/// MyAlertTest
///
/// Creation of class to define alerts with alert dialog widget
class MyAlertTest {
  /// [Function] : Check if you are connected
  static Future<void> checkSignInStatus(BuildContext context) async {
    dynamic object = await checkSignin(context);
    String title = object['title'];
    String message = object['message'];
    if (!object['isSignedIn']) {
      _showSignInAlertDialog(context, title, message);
    }
  }

  /// [Function] : Check if you are connected with admin account of Risu
  static Future<void> checkSignInStatusAdmin(BuildContext context) async {
    dynamic object = await checkSignInAdmin(context);
    String title = object['title'];
    String message = object['message'];
    if (!object['isSignedIn']) {
      _showSignInAlertDialog(context, title, message);
    }
  }

  /// [Widget] : Add login button if you are connected
  static Widget loginButton(BuildContext context) {
    if ('title' == AppLocalizations.of(context)!.logInRequired) {
      return TextButton(
        onPressed: () {
          context.go('/login');
        },
        child: Text(AppLocalizations.of(context)!.logInAction),
      );
    } else {
      return Container();
    }
  }

  /// [Widget] : Create pop up if you are not connected
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
              child: Text(AppLocalizations.of(context)!.backToHome),
            ),
            loginButton(context),
          ],
        );
      },
    );
  }
}

/// [Function] : Check if you can sign in
Future<Map<String, dynamic>> checkSignin(BuildContext context) async {
  String? token = await storageService.readStorage('token');

  if (token == '') {
    return {
      'isSignedIn': false,
      'title': AppLocalizations.of(context)!.logInRequired,
      'message': AppLocalizations.of(context)!.mustBeLoggedIn,
    };
  }

  bool isUserVerified = await storageService.isUserVerified();
  if (!isUserVerified) {
    return {
      'isSignedIn': false,
      'title': AppLocalizations.of(context)!.accountNotVerified,
      'message': AppLocalizations.of(context)!.mustVerifyAccount,
    };
  }
  return {'isSignedIn': true, 'title': '', 'message': ''};
}

/// [Function] : Check if you can sign in with admin account
Future<Map<String, dynamic>> checkSignInAdmin(BuildContext context) async {
  String? token = await storageService.readStorage('token');
  String? role;
  if (token != '') {
    role = await storageService.getUserRole();
  }
  if (token != '' && role == "admin") {
    return {'isSignedIn': true, 'title': '', 'message': ''};
  }
  return {
    'isSignedIn': false,
    'title': AppLocalizations.of(context)!.adminAccessNeeded,
    'message': AppLocalizations.of(context)!.mustBeAdmin
  };
}
