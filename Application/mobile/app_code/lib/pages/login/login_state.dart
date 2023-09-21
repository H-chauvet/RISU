import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:risu/components/alert_dialog.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/components/text_input.dart';
import 'package:risu/network/informations.dart';
import 'package:risu/pages/history_location/history_functional.dart';
import 'package:risu/pages/signup/signup_functional.dart';
import 'package:risu/utils/theme.dart';
import 'package:risu/utils/user_data.dart';
import 'package:risu/utils/validators.dart';

import 'login_page.dart';

class LoginPageState extends State<LoginPage> {
  String? _email;
  String? _password;
  bool _isPasswordVisible = false;

  Future<bool> apiLogin() async {
    if (_email == null || _password == null) {
      if (context.mounted) {
        await MyAlertDialog.showInfoAlertDialog(
            context: context,
            title: 'Connexion',
            message: 'Please fill all the fields!');
      }
    }

    late http.Response response;
    try {
      response = await http.post(
        Uri.parse('http://$serverIp:8080/api/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
            <String, String>{'email': _email!, 'password': _password!}),
      );
    } catch (err) {
      if (context.mounted) {
        await MyAlertDialog.showInfoAlertDialog(
            context: context,
            title: 'Connexion',
            message: 'Connection refused.');
      }
    }

    if (response.statusCode == 201) {
      try {
        final jsonData = jsonDecode(response.body);
        if (jsonData.containsKey('data')) {
          userInformation = UserData.fromJson(jsonData['data']);
          return true;
        } else {
          if (context.mounted) {
            await MyAlertDialog.showInfoAlertDialog(
                context: context,
                title: 'Connexion',
                message: 'Invalid token... Please retry (data not found)');
          }
        }
      } catch (err) {
        debugPrint(err.toString());
        if (context.mounted) {
          await MyAlertDialog.showInfoAlertDialog(
              context: context,
              title: 'Connexion',
              message: 'Invalid token... Please retry.');
        }
      }
    } else {
      try {
        final jsonData = jsonDecode(response.body);
        if (jsonData.containsKey('message')) {
          if (context.mounted) {
            await MyAlertDialog.showInfoAlertDialog(
                context: context,
                title: 'Connexion',
                message: jsonData['message']);
          }
        } else {
          if (context.mounted) {
            await MyAlertDialog.showInfoAlertDialog(
                context: context,
                title: 'Connexion',
                message: 'Invalid credentials.');
          }
        }
      } catch (err) {
        if (context.mounted) {
          await MyAlertDialog.showInfoAlertDialog(
              context: context,
              title: 'Connexion',
              message: 'Invalid credentials.');
        }
      }
    }
    return false;
  }

  Future<String> apiResetPassword(BuildContext context) async {
    if (_email == null) {
      return 'Please provide a valid email !';
    }
    var response = await http.post(
      Uri.parse('http://$serverIp:8080/api/user/resetPassword'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'email': _email!}),
    );
    if (context.mounted) {
      await MyAlertDialog.showInfoAlertDialog(
          context: context,
          title: 'Email',
          message: 'A reset password has been sent to your email box.');
    }
    return jsonDecode(response.body)['message'].toString();
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
      appBar: CustomShapedAppBar(
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
              'Connexion',
              key: const Key('subtitle-text'),
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
                  labelText: "Email",
                  keyboardType: TextInputType.emailAddress,
                  icon: Icons.email_outlined,
                  onChanged: (value) => _email = value,
                ),
                const SizedBox(height: 16),
                MyTextInput(
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
                        key: const Key('reset_password-button'),
                        onPressed: () {
                          setState(() {
                            apiResetPassword(context);
                          });
                        },
                        child: Text(
                          'Mot de passe oublié ?',
                          style: TextStyle(
                            fontSize: 12,
                            decoration: TextDecoration.underline,
                            color: context.select(
                                (ThemeProvider themeProvider) => themeProvider
                                    .currentTheme.secondaryHeaderColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            OutlinedButton(
              key: const Key('login-button'),
              onPressed: () {
                apiLogin().then((value) => {
                      if (value)
                        {
                          goToHomePage(context),
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
                'Se connecter',
                style: TextStyle(
                  color: context.select((ThemeProvider themeProvider) =>
                      themeProvider.currentTheme.secondaryHeaderColor),
                  fontSize: 16.0,
                ),
              ),
            ),
            TextButton(
              key: const Key('goto_signup-button'),
              onPressed: () {
                goToSignupPage(context);
              },
              child: Text(
                'Pas de compte ? S\'inscrire',
                style: TextStyle(
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                  color: context.select((ThemeProvider themeProvider) =>
                      themeProvider.currentTheme.secondaryHeaderColor),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
