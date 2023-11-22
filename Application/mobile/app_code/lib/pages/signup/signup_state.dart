import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:risu/components/alert_dialog.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/components/text_input.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/login/login_page.dart';
import 'package:risu/utils/theme.dart';
import 'package:risu/utils/validators.dart';

import 'signup_page.dart';

class SignupPageState extends State<SignupPage> {
  String? _email;
  String? _password;
  bool _isPasswordVisible = false;

  Future<bool> apiSignup() async {
    if (_email == null || _password == null) {
      await MyAlertDialog.showErrorAlertDialog(
          context: context,
          title: 'Creation de compte',
          message: 'Please fill all the field !');
      return false;
    }
    late http.Response response;
    try {
      response = await http.post(
        Uri.parse('http://$serverIp:8080/api/signup'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
            <String, String>{'email': _email!, 'password': _password!}),
      );
    } catch (err) {
      if (context.mounted) {
        await MyAlertDialog.showErrorAlertDialog(
            context: context,
            title: 'Connexion',
            message: 'Connection refused.');
      }
      return false;
    }
    if (response.statusCode == 201) {
      if (context.mounted) {
        await MyAlertDialog.showInfoAlertDialog(
            context: context,
            title: 'Email',
            message: 'A confirmation e-mail has been sent to you.');
        return true;
      }
    } else {
      if (context.mounted) {
        await MyAlertDialog.showErrorAlertDialog(
            context: context,
            title: 'Creation de compte',
            message: 'Invalid e-mail address !');
      }
      return false;
    }
    return false;
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
      appBar: MyAppBar(
        key: const Key('signup-appbar'),
        curveColor: context.select((ThemeProvider themeProvider) =>
            themeProvider.currentTheme.secondaryHeaderColor),
        showBackButton: true,
        showLogo: true,
        showBurgerMenu: false,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        transformAlignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Création de compte',
              key: const Key('signup-text_title'),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
                color: context.select((ThemeProvider themeProvider) =>
                    themeProvider.currentTheme.secondaryHeaderColor),
                shadows: [
                  Shadow(
                    color: context.select((ThemeProvider themeProvider) =>
                        themeProvider.currentTheme.secondaryHeaderColor),
                    blurRadius: 24,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Column(
              children: [
                MyTextInput(
                  key: const Key('signup-textinput_email'),
                  labelText: "Email",
                  keyboardType: TextInputType.emailAddress,
                  icon: Icons.email_outlined,
                  onChanged: (value) => _email = value,
                ),
                const SizedBox(height: 16),
                MyTextInput(
                    key: const Key('signup-textinput_password'),
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
                    children: [
                      TextButton(
                        key: Key('signup-textbutton_resetpassword'),
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
            OutlinedButton(
              key: const Key('signup-button_signup'),
              onPressed: () {
                apiSignup().then((value) => {
                      if (value)
                        {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Account created !'),
                            ),
                          ),
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const LoginPage();
                              },
                            ),
                          ),
                        }
                    });
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
                side: BorderSide(
                  color: context.select((ThemeProvider themeProvider) =>
                      themeProvider.currentTheme.secondaryHeaderColor),
                  width: 3.0,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 48.0,
                  vertical: 16.0,
                ),
              ),
              child: Text(
                'Créer un compte',
                style: TextStyle(
                  color: context.select((ThemeProvider themeProvider) =>
                      themeProvider.currentTheme.secondaryHeaderColor),
                  fontSize: 16.0,
                ),
              ),
            ),
            TextButton(
              key: const Key('signup-textbutton_gotologin'),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const LoginPage();
                    },
                  ),
                );
              },
              child: Text(
                'Déjà inscrit ? Se connecter',
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
