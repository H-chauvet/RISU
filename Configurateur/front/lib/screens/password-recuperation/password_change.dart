// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/components/custom_header.dart';
import 'package:front/components/custom_toast.dart';
import 'package:front/components/custom_footer.dart';
import 'package:front/components/pw_validator_strings.dart';
import 'package:front/network/informations.dart';
import 'package:front/services/size_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/globalStyle.dart';
import 'package:front/styles/themes.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import 'password_change_style.dart';

/// PasswordChange
///
/// Page where the user can change is password
/// [params] : uuid of the user
class PasswordChange extends StatefulWidget {
  const PasswordChange({super.key, required this.params});

  final String params;

  @override
  State<PasswordChange> createState() => PasswordChangeState();
}

/// PasswordChangeState
///
class PasswordChangeState extends State<PasswordChange> {
  /// [Widget] : Build the password change page
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscurePasswordConfirm = true;
  bool isPasswordValid = false;

  @override
  Widget build(BuildContext context) {
    ScreenFormat screenFormat = SizeService().getScreenFormat(context);

    return Scaffold(
      body: FooterView(
        footer: Footer(
          padding: EdgeInsets.zero,
          child: const CustomFooter(),
        ),
        children: [
          LandingAppBar(context: context),
          Text(
            AppLocalizations.of(context)!.passwordNew,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: screenFormat == ScreenFormat.desktop
                  ? desktopBigFontSize
                  : tabletBigFontSize,
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              color: Provider.of<ThemeService>(context).isDark
                  ? darkTheme.secondaryHeaderColor
                  : lightTheme.secondaryHeaderColor,
              shadows: [
                Shadow(
                  color: Provider.of<ThemeService>(context).isDark
                      ? darkTheme.secondaryHeaderColor
                      : lightTheme.secondaryHeaderColor,
                  offset: const Offset(0.75, 0.75),
                  blurRadius: 1.5,
                ),
              ],
            ),
          ),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.7,
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 150),
                    TextFormField(
                      key: const Key('password'),
                      controller: passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.passwordFill,
                        labelText: AppLocalizations.of(context)!.password,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.askCompleteField;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    FlutterPwValidator(
                      controller: passwordController,
                      minLength: 8,
                      uppercaseCharCount: 1,
                      numericCharCount: 1,
                      specialCharCount: 1,
                      failureColor: const Color(0xFF990000),
                      successColor: const Color(0xFF009900),
                      width: 320,
                      height: 100,
                      strings: PasswordStrings(context),
                      onSuccess: () {
                        setState(
                          () {
                            isPasswordValid = true;
                          },
                        );
                      },
                      onFail: () {
                        setState(
                          () {
                            isPasswordValid = false;
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      key: const Key('confirm-password'),
                      controller: confirmPasswordController,
                      obscureText: _obscurePasswordConfirm,
                      decoration: InputDecoration(
                        hintText:
                            AppLocalizations.of(context)!.passwordConfirmation,
                        labelText:
                            AppLocalizations.of(context)!.passwordConfirm,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePasswordConfirm =
                                  !_obscurePasswordConfirm;
                            });
                          },
                        ),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.askCompleteField;
                        }
                        if (value != passwordController.text) {
                          return AppLocalizations.of(context)!
                              .passwordDontMatch;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 40,
                      width: screenFormat == ScreenFormat.desktop
                          ? desktopSendButtonWidth
                          : tabletSendButtonWidth,
                      child: ElevatedButton(
                        key: const Key('change-password'),
                        onPressed: () async {
                          if (passwordController.text ==
                                  confirmPasswordController.text &&
                              isPasswordValid) {
                            var response = await http.post(
                              Uri.parse(
                                  'http://$serverIp:3000/api/auth/update-password'),
                              headers: <String, String>{
                                'Content-Type':
                                    'application/json; charset=UTF-8',
                                'Access-Control-Allow-Origin': '*',
                              },
                              body: jsonEncode(<String, String>{
                                'uuid': widget.params,
                                'password': passwordController.text,
                              }),
                            );
                            if (response.statusCode == 200) {
                              showCustomToast(
                                  context,
                                  AppLocalizations.of(context)!
                                      .passwordModifySuccess,
                                  true);
                            } else {
                              showCustomToast(context, response.body, false);
                            }
                            context.go("/");
                          } else {
                            showCustomToast(
                                context,
                                AppLocalizations.of(context)!.passwordDontMatch,
                                false);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.passwordModify,
                          style: TextStyle(
                            fontSize: screenFormat == ScreenFormat.desktop
                                ? desktopFontSize
                                : tabletFontSize,
                            color: Provider.of<ThemeService>(context).isDark
                                ? darkTheme.primaryColor
                                : lightTheme.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
