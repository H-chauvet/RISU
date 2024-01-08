import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:risu/components/alert_dialog.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/components/text_input.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/home/home_page.dart';
import 'package:risu/pages/signup/signup_page.dart';
import 'package:risu/utils/theme.dart';
import 'package:risu/utils/user_data.dart';

import 'login_page.dart';

class LoginPageState extends State<LoginPage> {
  String? _email;
  String? _password;
  bool _isPasswordVisible = false;

  Future<bool> apiLogin() async {
    if (_email == null || _password == null) {
      if (context.mounted) {
        await MyAlertDialog.showErrorAlertDialog(
            key: const Key('login-alertdialog_emptyfields'),
            context: context,
            title: 'Connexion',
            message: 'Please fill all the fields!');
        return false;
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
      print(err);
      if (context.mounted) {
        await MyAlertDialog.showErrorAlertDialog(
            key: const Key('login-alertdialog_connectionrefused'),
            context: context,
            title: 'Connexion',
            message: 'Connection refused.');
        return false;
      }
    }

    if (response.statusCode == 201) {
      try {
        final jsonData = jsonDecode(response.body);
        print(jsonData);
        if (jsonData.containsKey('user') && jsonData.containsKey('token')) {
          userInformation =
              UserData.fromJson(jsonData['user'], jsonData['token']);
          return true;
        } else {
          if (context.mounted) {
            await MyAlertDialog.showErrorAlertDialog(
                key: const Key('login-alertdialog_invaliddata'),
                context: context,
                title: 'Connexion',
                message: 'Invalid token... Please retry (data not found)');
            return false;
          }
        }
      } catch (err) {
        print(err);
        if (context.mounted) {
          await MyAlertDialog.showErrorAlertDialog(
              key: const Key('login-alertdialog_invalidtoken'),
              context: context,
              title: 'Connexion',
              message: 'Invalid token... Please retry.');
          return false;
        }
      }
    } else {
      try {
        final jsonData = jsonDecode(response.body);
        if (jsonData.containsKey('message')) {
          if (context.mounted) {
            await MyAlertDialog.showErrorAlertDialog(
                key: const Key('login-alertdialog_invalidresponse'),
                context: context,
                title: 'Connexion',
                message: jsonData['message']);
            return false;
          }
        } else {
          if (context.mounted) {
            await MyAlertDialog.showErrorAlertDialog(
                key: const Key('login-alertdialog_invalidcredentials'),
                context: context,
                title: 'Connexion',
                message: 'Invalid credentials.');
            return false;
          }
        }
      } catch (err) {
        print(err);
        if (context.mounted) {
          await MyAlertDialog.showErrorAlertDialog(
              key: const Key('login-alertdialog_error'),
              context: context,
              title: 'Connexion',
              message: 'Error while trying to login..');
          return false;
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
      appBar: MyAppBar(
        key: const Key('login-appbar'),
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
              key: const Key('login-text_title'),
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
                  key: const Key('login-textinput_email'),
                  labelText: "Email",
                  keyboardType: TextInputType.emailAddress,
                  icon: Icons.email_outlined,
                  onChanged: (value) => _email = value,
                ),
                const SizedBox(height: 16),
                MyTextInput(
                  key: const Key('login-textinput_password'),
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
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    children: [
                      TextButton(
                        key: const Key('login-textbutton_resetpassword'),
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
              key: const Key('login-button_signin'),
              onPressed: () {
                apiLogin().then((value) => {
                      if (value)
                        {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const HomePage();
                              },
                            ),
                            (route) => false,
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
                'Se connecter',
                style: TextStyle(
                  color: context.select((ThemeProvider themeProvider) =>
                      themeProvider.currentTheme.secondaryHeaderColor),
                  fontSize: 16.0,
                ),
              ),
            ),
            TextButton(
              key: const Key('login-textbutton_gotosignup'),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const SignupPage();
                    },
                  ),
                );
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
