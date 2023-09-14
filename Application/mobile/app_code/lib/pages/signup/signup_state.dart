import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:risu/flutter_objects/alert_dialog.dart';
import 'package:risu/flutter_objects/text_input.dart';

import '../../flutter_objects/filled_button.dart';
import '../../material_lib_functions/material_functions.dart';
import '../../network/informations.dart';
import '../../utils/theme.dart';
import '../../utils/validators.dart';
import '../login/login_functional.dart';
import 'signup_page.dart';

class SignupPageState extends State<SignupPage> {
  String? _email;
  String? _password;
  bool _isPasswordVisible = false;

  void apiSignup() async {
    if (_email == null || _password == null) {
      await MyAlertDialog.showInfoAlertDialog(
          context: context,
          title: 'Creation de compte',
          message: 'Please fill all the field !');
    }
    final response = await http.post(
      Uri.parse('http://$serverIp:8080/api/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{'email': _email!, 'password': _password!}),
    );

    if (response.statusCode == 201) {
      if (context.mounted) {
        await MyAlertDialog.showInfoAlertDialog(
            context: context,
            title: 'Email',
            message: 'A confirmation e-mail has been sent to you.');
      }
    } else {
      if (context.mounted) {
        await MyAlertDialog.showInfoAlertDialog(
            context: context,
            title: 'Creation de compte',
            message: 'Invalid e-mail address !');
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: context.select((ThemeProvider themeProvider) =>
          themeProvider.currentTheme.colorScheme.background),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        transformAlignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            displayLogo(90),
            const SizedBox(height: 8),
            Text(
              'Création de mon compte',
              key: const Key('subtitle-text'),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: context.select((ThemeProvider themeProvider) =>
                      themeProvider.currentTheme.secondaryHeaderColor)),
            ),
            const SizedBox(height: 16),
            Column(
              children: [
                MyTextInput(
                  hintText: "Email",
                  labelText: "Email",
                  keyboardType: TextInputType.emailAddress,
                  icon: Icons.email_outlined,
                  onChanged: (value) => _email = value,
                ),
                const SizedBox(height: 16),
                MyTextInput(
                    hintText: "Mot de passe",
                    labelText: "Mot de passe",
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: !_isPasswordVisible,
                    icon: Icons.lock_outline,
                    rightIcon: _isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                    rightIconOnPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    onChanged: (value) => _password = value,
                    validator: (value) =>
                        Validators().notEmpty(context, value)),
                Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    children: const [
                      TextButton(
                        key: Key('reset_password-button'),
                        onPressed: null,
                        child: Text(
                          '',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            MyButton(
              key: const Key('send_signup-button'),
              text: 'Inscription',
              onPressed: () {
                apiSignup();
              },
            ),
            TextButton(
              key: const Key('go_login-button'),
              onPressed: () {
                goToLoginPage(context);
              },
              child: Text(
                'Retour à l\'écran de connexion...',
                style: TextStyle(
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                  color: context.select((ThemeProvider themeProvider) =>
                      themeProvider.currentTheme.secondaryHeaderColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
