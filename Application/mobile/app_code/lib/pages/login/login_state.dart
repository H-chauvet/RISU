import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:risu/components/alert_dialog.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/components/loader.dart';
import 'package:risu/components/text_input.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/home/home_page.dart';
import 'package:risu/pages/signup/signup_page.dart';
import 'package:risu/utils/errors.dart';
import 'package:risu/utils/providers/theme.dart';
import 'package:risu/utils/user_data.dart';

import 'login_page.dart';

class LoginPageState extends State<LoginPage> {
  late bool keepPath;
  String? _email;
  String? _password;
  bool _isPasswordVisible = false;
  final LoaderManager _loaderManager = LoaderManager();

  Future<bool> apiLogin() async {
    if (_email == null || _password == null) {
      if (context.mounted) {
        await MyAlertDialog.showErrorAlertDialog(
          key: const Key('login-alertdialog_emptyfields'),
          context: context,
          title: AppLocalizations.of(context)!.error,
          message: AppLocalizations.of(context)!.fieldsEmpty,
        );
        return false;
      }
    }

    try {
      setState(() {
        _loaderManager.setIsLoading(true);
      });
      http.Response response = await http.post(
        Uri.parse('$baseUrl/api/mobile/auth/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': _email!,
          'password': _password!,
        }),
      );
      setState(() {
        _loaderManager.setIsLoading(false);
      });
      final jsonData = jsonDecode(response.body);
      if (response.statusCode == 201) {
        setState(() {
          userInformation =
              UserData.fromJson(jsonData['user'], jsonData['token']);
        });
        return true;
      } else {
        if (jsonData.containsKey('message')) {
          if (context.mounted) {
            printServerResponse(context, response, 'apiLogin',
                message: jsonData['message']);
            return false;
          }
        }
      }
    } catch (err, stacktrace) {
      if (context.mounted) {
        printCatchError(context, err, stacktrace,
            message: AppLocalizations.of(context)!.connectionRefused);
        setState(() {
          _loaderManager.setIsLoading(false);
        });
        return false;
      }
    }
    return false;
  }

  void apiResetPassword(BuildContext context) async {
    try {
      if (_email == null) {
        await MyAlertDialog.showErrorAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.error,
          message: AppLocalizations.of(context)!.emailNotFilled,
        );
        return;
      }
      if (_email == 'admin@gmail.com') {
        await MyAlertDialog.showErrorAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.error,
          message: AppLocalizations.of(context)!.passwordCantResetAdmin,
        );
        return;
      }
      setState(() {
        _loaderManager.setIsLoading(true);
      });
      var response = await http.post(
        Uri.parse('$baseUrl/api/mobile/user/resetPassword'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': _email!,
        }),
      );
      setState(() {
        _loaderManager.setIsLoading(false);
      });
      if (response.statusCode == 200) {
        if (context.mounted) {
          await MyAlertDialog.showInfoAlertDialog(
            context: context,
            title: AppLocalizations.of(context)!.email,
            message:
                AppLocalizations.of(context)!.passwordTemporarySent(_email!),
          );
        }
      } else {
        if (context.mounted) {
          printServerResponse(context, response, 'apiResetPassword',
              message: AppLocalizations.of(context)!
                  .errorOccurredDuringPasswordReset);
        }
      }
    } catch (err, stacktrace) {
      if (context.mounted) {
        printCatchError(context, err, stacktrace,
            message:
                AppLocalizations.of(context)!.errorOccurredDuringPasswordReset);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    keepPath = widget.keepPath ?? false;
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
      ),
      body: (_loaderManager.getIsLoading())
          ? Center(child: _loaderManager.getLoader())
          : Container(
              margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              transformAlignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.connection,
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
                        labelText: AppLocalizations.of(context)!.email,
                        keyboardType: TextInputType.emailAddress,
                        icon: Icons.email_outlined,
                        onChanged: (value) => _email = value,
                      ),
                      const SizedBox(height: 16),
                      MyTextInput(
                        key: const Key('login-textinput_password'),
                        labelText: AppLocalizations.of(context)!.password,
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
                                "${AppLocalizations.of(context)!.passwordForgotten} ?",
                                style: TextStyle(
                                  fontSize: 12,
                                  decoration: TextDecoration.underline,
                                  color: context.select(
                                      (ThemeProvider themeProvider) =>
                                          themeProvider.currentTheme
                                              .secondaryHeaderColor),
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
                                if (keepPath)
                                  Navigator.pop(context)
                                else
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
                      AppLocalizations.of(context)!.signIn,
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
                      "${AppLocalizations.of(context)!.noAccount}? ${AppLocalizations.of(context)!.register}",
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
