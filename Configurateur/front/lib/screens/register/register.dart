import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:front/components/custom_footer.dart';
import 'package:front/components/custom_header.dart';
import 'package:front/components/google/google.dart';
import 'package:front/components/pw_validator_strings.dart';
import 'package:front/network/informations.dart';
import 'package:front/services/http_service.dart';
import 'package:front/services/size_service.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/globalStyle.dart';
import 'package:front/styles/themes.dart';
import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'register_style.dart';

/// RegisterScreen
///
/// Page for the account creation
// ignore: must_be_immutable
class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key, this.orgId});

  String? orgId = '';

  @override
  State<RegisterScreen> createState() => RegisterScreenState();
}

/// RegisterScreenState
///
class RegisterScreenState extends State<RegisterScreen> {
  /// [Widget] : Build of the register page
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscurePasswordConfirm = true;
  bool isPasswordValid = false;

  @override
  Widget build(BuildContext context) {
    dynamic response;

    ScreenFormat screenFormat = SizeService().getScreenFormat(context);

    return Scaffold(
      body: FooterView(
        footer: Footer(
          padding: EdgeInsets.zero,
          child: const CustomFooter(),
        ),
        children: [
          Column(
            children: [
              LandingAppBar(context: context),
              Text(
                AppLocalizations.of(context)!.registerRisu,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 150),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.65,
                      height: MediaQuery.of(context).size.height * 0.85,
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: firstNameController,
                              key: const Key('firstname'),
                              decoration: InputDecoration(
                                hintText:
                                    AppLocalizations.of(context)!.firstNameFill,
                                labelText:
                                    AppLocalizations.of(context)!.firstName,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .askCompleteField;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: lastNameController,
                              key: const Key('lastname'),
                              decoration: InputDecoration(
                                hintText:
                                    AppLocalizations.of(context)!.lastNameFill,
                                labelText:
                                    AppLocalizations.of(context)!.lastName,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .askCompleteField;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: mailController,
                              key: const Key('email'),
                              decoration: InputDecoration(
                                hintText:
                                    AppLocalizations.of(context)!.emailFill,
                                labelText:
                                    AppLocalizations.of(context)!.emailAddress,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .askCompleteField;
                                }
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                    .hasMatch(value)) {
                                  return AppLocalizations.of(context)!
                                      .emailNotValid;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              key: const Key('password'),
                              controller: passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                hintText:
                                    AppLocalizations.of(context)!.passwordFill,
                                labelText:
                                    AppLocalizations.of(context)!.password,
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
                                  return AppLocalizations.of(context)!
                                      .askCompleteField;
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
                              height: 120,
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
                                hintText: AppLocalizations.of(context)!
                                    .passwordConfirmation,
                                labelText: AppLocalizations.of(context)!
                                    .passwordConfirm,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePasswordConfirm
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
                                  return AppLocalizations.of(context)!
                                      .askCompleteField;
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
                              height: screenFormat == ScreenFormat.desktop
                                  ? desktopButtonHeight
                                  : tabletButtonHeight,
                              width: screenFormat == ScreenFormat.desktop
                                  ? desktopButtonWidth
                                  : tabletButtonWidth,
                              child: ElevatedButton(
                                key: const Key(
                                  'register',
                                ),
                                onPressed: () async {
                                  if (formKey.currentState!.validate() &&
                                      isPasswordValid) {
                                    var body = {
                                      'firstName': firstNameController.text,
                                      'lastName': lastNameController.text,
                                      'email': mailController.text,
                                      'password': passwordController.text,
                                    };
                                    var header = <String, String>{
                                      'Content-Type':
                                          'application/json; charset=UTF-8',
                                      'Access-Control-Allow-Origin': '*',
                                    };
                                    await HttpService()
                                        .request(
                                            'http://$serverIp:3000/api/auth/register',
                                            header,
                                            body)
                                        .then((value) => {
                                              if (value.statusCode == 200)
                                                {
                                                  response =
                                                      jsonDecode(value.body),
                                                  storageService.writeStorage(
                                                    'token',
                                                    response['accessToken'],
                                                  ),
                                                }
                                            });
                                    if (response != null) {
                                      header.addEntries(
                                        [
                                          MapEntry('Authorization',
                                              '${response['accessToken']}'),
                                        ],
                                      );
                                      await HttpService().request(
                                          'http://$serverIp:3000/api/auth/register-confirmation',
                                          header,
                                          body);
                                      // ignore: use_build_context_synchronously
                                      if (widget.orgId == null) {
                                        context.go("/company-register",
                                            extra: mailController.text);
                                      } else {
                                        body = {
                                          'companyId': widget.orgId!,
                                        };
                                        await HttpService().request(
                                            'http://$serverIp:3000/api/organization/add-member',
                                            header,
                                            body);
                                        context.go("/register-confirmation",
                                            extra: mailController.text);
                                      }
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.signUp,
                                  style: TextStyle(
                                    color: Provider.of<ThemeService>(context)
                                            .isDark
                                        ? darkTheme.primaryColor
                                        : lightTheme.primaryColor,
                                    fontSize:
                                        screenFormat == ScreenFormat.desktop
                                            ? desktopFontSize
                                            : tabletFontSize,
                                  ),
                                ),
                              ),
                            ),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  context.go("/login");
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        AppLocalizations.of(context)!
                                            .allreadyGotAccount,
                                        style: TextStyle(
                                          color: Provider.of<ThemeService>(
                                                      context,
                                                      listen: false)
                                                  .isDark
                                              ? darkTheme.primaryColor
                                              : lightTheme.primaryColor,
                                          fontSize: screenFormat ==
                                                  ScreenFormat.desktop
                                              ? desktopFontSize
                                              : tabletFontSize,
                                        ),
                                      ),
                                      Text(
                                        AppLocalizations.of(context)!.logInAsk,
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: screenFormat ==
                                                  ScreenFormat.desktop
                                              ? desktopFontSize
                                              : tabletFontSize,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              AppLocalizations.of(context)!.registerWith,
                              style: TextStyle(
                                color: Provider.of<ThemeService>(context,
                                            listen: false)
                                        .isDark
                                    ? darkTheme.primaryColor
                                    : lightTheme.primaryColor,
                                fontSize: screenFormat == ScreenFormat.desktop
                                    ? desktopFontSize
                                    : tabletFontSize,
                              ),
                            ),
                            const SizedBox(height: 10),
                            GoogleLogo(
                              screenFormat: screenFormat,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
