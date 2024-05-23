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
import 'package:risu/pages/login/login_page.dart';
import 'package:risu/utils/errors.dart';
import 'package:risu/utils/providers/theme.dart';
import 'package:risu/utils/validators.dart';

import 'signup_page.dart';

class SignupPageState extends State<SignupPage> {
  String? _email;
  String? _password;
  String? _passwordConfirmation;
  bool _isPasswordVisible = false;
  bool _isPasswordConfirmationVisible = false;
  final LoaderManager _loaderManager = LoaderManager();

  @override
  void initState() {
    super.initState();
  }

  Future<bool> apiSignup() async {
    if (_email == null) {
      await MyAlertDialog.showErrorAlertDialog(
        context: context,
        title: AppLocalizations.of(context)!.accountCreation,
        message: AppLocalizations.of(context)!.fieldsEmpty,
      );
      return false;
    }
    String? passwordError = _isPasswordValid();
    if (passwordError != null) {
      await MyAlertDialog.showErrorAlertDialog(
        context: context,
        title: AppLocalizations.of(context)!.accountCreation,
        message: passwordError,
      );
      return false;
    }
    if (Validators().email(context, _email!) != null) {
      await MyAlertDialog.showErrorAlertDialog(
        context: context,
        title: AppLocalizations.of(context)!.accountCreation,
        message: AppLocalizations.of(context)!.emailInvalid,
      );
      return false;
    }
    late http.Response response;
    try {
      setState(() {
        _loaderManager.setIsLoading(true);
      });
      response = await http.post(
        Uri.parse('$baseUrl/api/mobile/auth/signup'),
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
      if (response.statusCode == 201) {
        if (mounted) {
          await MyAlertDialog.showInfoAlertDialog(
            context: context,
            title: AppLocalizations.of(context)!.email,
            message: AppLocalizations.of(context)!
                .accountEmailConfirmationSent(_email!),
          );
          return true;
        }
      } else {
        if (mounted) {
          printServerResponse(context, response, 'apiSignup',
              message: AppLocalizations.of(context)!.emailInvalid);
        }
        return false;
      }
      return false;
    } catch (err, stacktrace) {
      if (mounted) {
        setState(() {
          _loaderManager.setIsLoading(false);
        });
        printCatchError(context, err, stacktrace,
            message: AppLocalizations.of(context)!.connectionRefused);
        return false;
      }
      return false;
    }
  }

  String? _isPasswordValid() {
    if (_password == null || _password!.isEmpty) {
      return AppLocalizations.of(context)!.passwordEmpty;
    }
    if (_password! != _passwordConfirmation) {
      return AppLocalizations.of(context)!.passwordsDoNotMatch;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: context.select((ThemeProvider themeProvider) =>
          themeProvider.currentTheme.colorScheme.surface),
      appBar: MyAppBar(
        key: const Key('signup-appbar'),
        curveColor: context.select((ThemeProvider themeProvider) =>
            themeProvider.currentTheme.secondaryHeaderColor),
        showBackButton: true,
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
                    AppLocalizations.of(context)!.accountCreation,
                    key: const Key('signup-text_title'),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      color: context.select((ThemeProvider themeProvider) =>
                          themeProvider.currentTheme.primaryColor),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Column(
                    children: [
                      MyTextInput(
                        key: const Key('signup-textinput_email'),
                        labelText: AppLocalizations.of(context)!.email,
                        keyboardType: TextInputType.emailAddress,
                        icon: Icons.email_outlined,
                        onChanged: (value) => _email = value,
                      ),
                      const SizedBox(height: 16),
                      MyTextInput(
                        key: const Key('signup-textinput_password'),
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
                      const SizedBox(height: 16),
                      MyTextInput(
                        key:
                            const Key('signup-textinput_password_confirmation'),
                        labelText:
                            AppLocalizations.of(context)!.passwordConfirmation,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: !_isPasswordConfirmationVisible,
                        icon: Icons.lock_outline,
                        rightIconKey: const Key(
                            'signup-textinput_password_confirmation_righticon'),
                        rightIcon: _isPasswordConfirmationVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        rightIconOnPressed: () {
                          setState(() {
                            _isPasswordConfirmationVisible =
                                !_isPasswordConfirmationVisible;
                          });
                        },
                        onChanged: (value) => _passwordConfirmation = value,
                      ),
                      const Align(
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
                                  SnackBar(
                                    content: Text(AppLocalizations.of(context)!
                                        .accountCreatedSuccessfully),
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
                            themeProvider.currentTheme.primaryColor),
                        width: 3.0,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48.0,
                        vertical: 16.0,
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.accountCreate,
                      style: TextStyle(
                        color: context.select((ThemeProvider themeProvider) =>
                            themeProvider.currentTheme.primaryColor),
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
                      "${AppLocalizations.of(context)!.alreadyHaveAnAccount}? ${AppLocalizations.of(context)!.signIn}",
                      style: TextStyle(
                        fontSize: 14,
                        decoration: TextDecoration.underline,
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
