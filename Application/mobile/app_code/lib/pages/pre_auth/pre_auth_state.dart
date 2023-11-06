import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';
import 'package:risu/components/filled_button.dart';
import 'package:risu/components/outlined_button.dart';
import 'package:risu/main.dart';
import 'package:risu/pages/pre_auth/pre_auth_page.dart';
import 'package:risu/utils/theme.dart';

import '../login/login_page.dart';
import '../signup/signup_page.dart';

class PreAuthState extends State<PreAuthPage> {
  void _signInWithGoogle() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.select((ThemeProvider themeProvider) =>
          themeProvider.currentTheme.colorScheme.background),
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(32, 64, 32, 64),
            child: Image.asset(
              key: const Key('pre_auth-risu_logo'),
              'assets/logo_noir.png',
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Voici quelques informations sur l'application.",
                  key: const Key('pre_auth-text_subtitle'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12.0,
                      color: context.select((ThemeProvider themeProvider) =>
                          themeProvider.currentTheme.secondaryHeaderColor)),
                ),
                const SizedBox(height: 32.0),
                SignInButton(
                  isDarkTheme ? Buttons.GoogleDark : Buttons.Google,
                  text: "Se connecter avec Google",
                  onPressed: () {
                    _signInWithGoogle();
                  },
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: MyButton(
                        key: const Key('pre_auth-button_gotologin'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const LoginPage();
                              },
                            ),
                          );
                        },
                        text: "Connexion",
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: MyOutlinedButton(
                        key: const Key('pre_auth-button_gotosignup'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const SignupPage();
                              },
                            ),
                          );
                        },
                        text: "Inscription",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
