import 'dart:async';

import 'package:flutter/material.dart';
import 'package:front/screens/landing-page/landing_page.dart';
import 'package:front/screens/login/login.dart';
import 'package:front/services/theme_service.dart';
import 'package:provider/provider.dart';

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