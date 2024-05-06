import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/components/filled_button.dart';
import 'package:risu/components/loader.dart';
import 'package:risu/components/text_input.dart';
import 'package:risu/pages/reset_password/reset_password_page.dart';
import 'package:risu/utils/providers/theme.dart';

class ResetPasswordPageState extends State<ResetPasswordPage> {
  final LoaderManager _loaderManager = LoaderManager();
  bool _isPasswordVisible = false;
  bool _isPasswordConfirmationVisible = false;
  String _password = '';
  String _passwordConfirmation = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.select((ThemeProvider themeProvider) =>
          themeProvider.currentTheme.colorScheme.background),
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
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
