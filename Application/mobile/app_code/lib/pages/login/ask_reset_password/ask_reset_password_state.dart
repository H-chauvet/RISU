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
import 'package:risu/globals.dart';
import 'package:risu/utils/errors.dart';
import 'package:risu/utils/providers/theme.dart';

import 'ask_reset_password_page.dart';

class AskResetPasswordPageState extends State<AskResetPasswordPage> {
  final LoaderManager _loaderManager = LoaderManager();
  String? _email;

  @override
  void initState() {
    super.initState();
    _email = widget.email;
  }

  Future<bool> apiResetPassword(BuildContext context) async {
    try {
      if (_email == null) {
        await MyAlertDialog.showErrorAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.error,
          message: AppLocalizations.of(context)!.emailNotFilled,
        );
        return false;
      }
      if (_email == 'admin@gmail.com') {
        await MyAlertDialog.showErrorAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.error,
          message: AppLocalizations.of(context)!.passwordCantResetAdmin,
        );
        return false;
      }
      setState(() {
        _loaderManager.setIsLoading(true);
      });
      var response = await http.post(
        Uri.parse('$baseUrl/api/mobile/user/password/reset'),
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
          return true;
        }
      } else {
        if (context.mounted) {
          printServerResponse(context, response, 'apiResetPassword',
              message: AppLocalizations.of(context)!
                  .errorOccurredDuringPasswordReset);
          return false;
        }
      }
    } catch (err, stacktrace) {
      if (context.mounted) {
        printCatchError(context, err, stacktrace,
            message:
                AppLocalizations.of(context)!.errorOccurredDuringPasswordReset);

        return false;
      }
      return false;
    }
    return false;
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
        showBackButton: true,
      ),
      body: (_loaderManager.getIsLoading())
          ? Center(child: _loaderManager.getLoader())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: Column(
                children: [
                  Text(
                    key: const Key('ask_reset_password-text_description'),
                    AppLocalizations.of(context)!.askResetPasswordDescription,
                    style: TextStyle(
                      fontSize: 16,
                      color: context.select((ThemeProvider themeProvider) =>
                          themeProvider.currentTheme.inputDecorationTheme
                              .labelStyle!.color),
                    ),
                  ),
                  const SizedBox(height: 16),
                  MyTextInput(
                    key: const Key('ask_reset_password-textinput_email'),
                    labelText: AppLocalizations.of(context)!.email,
                    initialValue: widget.email,
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) => _email = value,
                  ),
                  TextButton(
                    key: const Key('ask_reset_password-textbutton_gotologin'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      AppLocalizations.of(context)!.goBackToLogin,
                      style: TextStyle(
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                        decorationColor: context.select(
                            (ThemeProvider themeProvider) =>
                                themeProvider.currentTheme.primaryColor),
                        color: context.select((ThemeProvider themeProvider) =>
                            themeProvider.currentTheme.primaryColor),
                      ),
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  Center(
                    child: MyButton(
                      key: const Key('ask_reset_password-button_send'),
                      text: AppLocalizations.of(context)!.send,
                      onPressed: () {
                        apiResetPassword(context).then(
                            (value) => {if (value) Navigator.pop(context)});
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
