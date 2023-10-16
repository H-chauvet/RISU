import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:risu/components/outlined_button.dart';
import 'package:risu/network/informations.dart';
import 'package:risu/pages/login/login_page.dart';
import 'package:risu/utils/theme.dart';

import 'profile_functional.dart';
import 'profile_page.dart';

class ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (logout || userInformation == null) {
      userInformation = null;
      return const LoginPage();
    } else {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: context.select((ThemeProvider themeProvider) =>
            themeProvider.currentTheme.colorScheme.background),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /*! DONT USE ROUTES LIKE THIS */
                  const SizedBox(height: 16),
                  buildButton('Informations', route: '/profile/informations'),
                  const SizedBox(height: 16),
                  buildButton('Paramètres', route: '/settings'),
                  const SizedBox(height: 16),
                  buildButton('Déconnexion', route: '/login'),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget buildButton(
    String text, {
    double fontSize = 18,
    double width = double.infinity,
    String route = '',
  }) {
    return Container(
      width: width,
      child: MyOutlinedButton(
        text: text,
        onPressed: () {
          if (route.isNotEmpty) {
            context.go(route);
          }
        },
      ),
    );
  }
}
