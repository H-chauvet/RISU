import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risu/pages/pre_auth/pre_auth_page.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'package:risu/flutter_objects/filled_button.dart';
import '../../flutter_objects/outlined_button.dart';
import '../../utils/colors.dart';
import '../../utils/theme.dart';
import '../login/login_functional.dart';
import '../signup/signup_functional.dart';

class PreAuthState extends State<PreAuthPage> {
  void _signInWithGoogle() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.select((ThemeProvider themeProvider) =>
          themeProvider.currentTheme.primaryColor),
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(32, 64, 32, 64),
            child: Image.asset(
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
                const Text(
                  "Voici quelques informations sur l'application.",
                  key: Key('subtitle-text'),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.0, color: MyColors.textPrimary),
                ),
                const SizedBox(height: 32.0),
                SignInButton(
                  Buttons.Google,
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
                        onPressed: () {
                          goToLoginPage(context);
                        },
                        text: "Connexion",
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: MyOutlinedButton(
                        onPressed: () {
                          goToSignupPage(context);
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
