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
import 'package:risu/pages/login/ask_reset_password/ask_reset_password_page.dart';
import 'package:risu/pages/signup/signup_page.dart';
import 'package:risu/utils/errors.dart';
import 'package:risu/utils/providers/language.dart';
import 'package:risu/utils/providers/theme.dart';
import 'package:risu/utils/user_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';

/// LoginPageState
/// This class is the state of the LoginPage
/// It contains the logic of the page: the login api call
/// and the redirection to the HomePage or the SignupPage
/// It also contains the logic of the stay connected checkbox
/// and the password visibility
class LoginPageState extends State<LoginPage> {
  late bool keepPath;
  bool _stayLoggedIn = false;
  String? _email;
  String? _password;
  bool _isPasswordVisible = false;
  final LoaderManager _loaderManager = LoaderManager();

  /// apiLogin
  /// This function is called when the user press the login button
  Future<bool> apiLogin() async {
    if (_email == null || _password == null) {
      if (mounted) {
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
        body: jsonEncode(<String, dynamic>{
          'email': _email!,
          'password': _password!,
          'longTerm': _stayLoggedIn ? true : false,
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
          Provider.of<LanguageProvider>(context, listen: false)
              .changeLanguage(Locale(userInformation!.language!));
          final refreshToken = jsonData['user']['refreshToken'];
          if (refreshToken != null && refreshToken != '') {
            SharedPreferences.getInstance().then((prefs) {
              prefs.setString('refreshToken', refreshToken);
            });
          }
        });
        return true;
      } else {
        if (jsonData.containsKey('message')) {
          if (mounted) {
            printServerResponse(context, response, 'apiLogin',
                message: jsonData['message']);
            return false;
          }
        }
      }
    } catch (err, stacktrace) {
      if (mounted) {
        printCatchError(context, err, stacktrace,
            message: AppLocalizations.of(context)!.connectionRefused);
        setState(() {
          _loaderManager.setIsLoading(false);
        });
        return false;
      }
      return false;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    keepPath = widget.keepPath ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.select((ThemeProvider themeProvider) =>
          themeProvider.currentTheme.colorScheme.surface),
      appBar: MyAppBar(
        key: const Key('login-appbar'),
        curveColor: context.select((ThemeProvider themeProvider) =>
            themeProvider.currentTheme.secondaryHeaderColor),
        showBackButton: false,
        textTitle: AppLocalizations.of(context)!.connection,
      ),
      body: (_loaderManager.getIsLoading())
          ? Center(child: _loaderManager.getLoader())
          : Container(
              margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              transformAlignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                      Row(
                        children: [
                          Checkbox(
                            key: const Key('login-checkbox_stayconnected'),
                            value: _stayLoggedIn,
                            onChanged: (value) {
                              setState(() {
                                _stayLoggedIn = value!;
                              });
                            },
                            side: BorderSide(
                              color: context.select(
                                  (ThemeProvider themeProvider) =>
                                      themeProvider.currentTheme.primaryColor),
                            ),
                            checkColor: context.select(
                                (ThemeProvider themeProvider) => themeProvider
                                    .currentTheme.secondaryHeaderColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            activeColor: context.select(
                                (ThemeProvider themeProvider) =>
                                    themeProvider.currentTheme.primaryColor),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _stayLoggedIn = !_stayLoggedIn;
                              });
                            },
                            child: Text(
                              AppLocalizations.of(context)!.stayConnected,
                              key: const Key('login-text_stayconnected'),
                              style: TextStyle(
                                fontSize: 12,
                                color: context.select(
                                    (ThemeProvider themeProvider) =>
                                        themeProvider
                                            .currentTheme.primaryColor),
                              ),
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            key: const Key('login-textbutton_resetpassword'),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return AskResetPasswordPage(email: _email);
                                  },
                                ),
                              );
                            },
                            child: Text(
                              "${AppLocalizations.of(context)!.passwordForgotten} ?",
                              style: TextStyle(
                                fontSize: 12,
                                decoration: TextDecoration.underline,
                                decorationColor: context.select(
                                    (ThemeProvider themeProvider) =>
                                        themeProvider
                                            .currentTheme.primaryColor),
                                color: context.select(
                                    (ThemeProvider themeProvider) =>
                                        themeProvider
                                            .currentTheme.primaryColor),
                              ),
                            ),
                          ),
                        ],
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
                            themeProvider.currentTheme.primaryColor),
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
                            themeProvider.currentTheme.primaryColor),
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
                        decorationColor: context.select(
                            (ThemeProvider themeProvider) =>
                                themeProvider.currentTheme.primaryColor),
                        color: context.select((ThemeProvider themeProvider) =>
                            themeProvider.currentTheme.primaryColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
