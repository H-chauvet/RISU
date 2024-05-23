import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:risu/components/alert_dialog.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/components/filled_button.dart';
import 'package:risu/components/loader.dart';
import 'package:risu/components/text_input.dart';
import 'package:risu/components/toast.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/reset_password/reset_password_page.dart';
import 'package:risu/utils/errors.dart';
import 'package:risu/utils/providers/theme.dart';

class ResetPasswordPageState extends State<ResetPasswordPage> {
  final LoaderManager _loaderManager = LoaderManager();
  bool _isPasswordVisible = false;
  bool _isPasswordConfirmationVisible = false;
  String _password = '';
  String _passwordConfirmation = '';

  Future<void> resetPassword() async {
    try {
      if (_password == '' || _passwordConfirmation == '') {
        if (mounted) {
          await MyAlertDialog.showErrorAlertDialog(
            context: context,
            title: AppLocalizations.of(context)!.error,
            message: AppLocalizations.of(context)!.fieldsEmpty,
          );
        }
        return;
      }
      if (_password != _passwordConfirmation) {
        if (mounted) {
          await MyAlertDialog.showErrorAlertDialog(
            context: context,
            title: AppLocalizations.of(context)!.error,
            message: AppLocalizations.of(context)!.passwordsDoNotMatch,
          );
        }
        return;
      }

      final token = widget.token;
      setState(() {
        _loaderManager.setIsLoading(true);
      });
      final response = await http.put(
        Uri.parse('$baseUrl/api/mobile/user/password/reset'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'newPassword': _password,
        }),
      );
      setState(() {
        _loaderManager.setIsLoading(false);
      });
      if (response.statusCode == 200) {
        json.decode(response.body);
        if (mounted) {
          MyToastMessage.show(
            context: context,
            message: AppLocalizations.of(context)!.passwordUpdated,
          );
        }
      } else {
        if (response.statusCode == 401) {
          if (mounted) {
            printServerResponse(context, response, 'resetPassword',
                message:
                    AppLocalizations.of(context)!.passwordCurrentIncorrect);
          }
        } else {
          if (mounted) {
            printServerResponse(context, response, 'resetPassword',
                message: AppLocalizations.of(context)!
                    .errorOccurredDuringPasswordUpdate);
          }
        }
      }
    } catch (err, stacktrace) {
      if (mounted) {
        setState(() {
          _loaderManager.setIsLoading(false);
        });
        printCatchError(context, err, stacktrace,
            message:
                AppLocalizations.of(context)!.errorOccurredDuringSavingData);
        return;
      }
      return;
    }
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
      ),
      body: (_loaderManager.getIsLoading())
          ? Center(child: _loaderManager.getLoader())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.resetPasswordDescription,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context)
                          .inputDecorationTheme
                          .labelStyle!
                          .color,
                    ),
                  ),
                  const SizedBox(height: 16),
                  MyTextInput(
                    key: const Key('reset_password-textinput_password'),
                    labelText: AppLocalizations.of(context)!.passwordNew,
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
                    key: const Key('signup-textinput_password_confirmation'),
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
                ],
              ),
            ),
      floatingActionButton: MyButton(
        key: const Key('reset_password-confirm'),
        text: AppLocalizations.of(context)!.confirm,
        onPressed: resetPassword,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
