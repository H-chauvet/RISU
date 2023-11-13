import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risu/components/outlined_button.dart';
import 'package:risu/network/informations.dart';
import 'package:risu/pages/Settings/settings_page.dart';
import 'package:risu/pages/login/login_page.dart';
import 'package:risu/pages/pre_auth/pre_auth_page.dart';
import 'package:risu/pages/profile/informations/informations_page.dart';
import 'package:risu/utils/theme.dart';
import 'package:risu/pages/pre_auth/pre_auth_page.dart';

import 'profile_page.dart';

class ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (userInformation == null) {
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
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: MyOutlinedButton(
                      text: 'Informations',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const ProfileInformationsPage();
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: MyOutlinedButton(
                      text: 'Paramètres',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const SettingsPage();
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  buildButton('Nous contacter', route: '/contact'),
                  const SizedBox(height: 16),
                  buildButton('Déconnexion', route: '/login'),
                  SizedBox(
                    width: double.infinity,
                    child: MyOutlinedButton(
                      text: 'Déconnexion',
                      onPressed: () {
                        userInformation = null;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const PreAuthPage();
                            },
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
