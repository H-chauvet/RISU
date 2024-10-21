import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:front/components/custom_footer.dart';
import 'package:front/components/custom_header.dart';
import 'package:front/components/google/google.dart';
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
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    String firstName = '';
    String lastName = '';
    String mail = '';
    String password = '';
    String validedPassword = '';
    dynamic response;

    ScreenFormat screenFormat = SizeService().getScreenFormat(context);

    return Scaffold(
        body: FooterView(
            flex: 8,
            footer: Footer(
              padding: EdgeInsets.zero,
              child: CustomFooter(),
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
                    const SizedBox(height: 75),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
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
                              onChanged: (String? value) {
                                firstName = value!;
                              },
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
                              onChanged: (String? value) {
                                lastName = value!;
                              },
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
                              onChanged: (String? value) {
                                mail = value!;
                              },
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
                              key: const Key('password'),
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText:
                                    AppLocalizations.of(context)!.passwordFill,
                                labelText:
                                    AppLocalizations.of(context)!.password,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              onChanged: (String? value) {
                                password = value!;
                              },
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
                              key: const Key('confirm-password'),
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)!
                                    .passwordConfirmation,
                                labelText: AppLocalizations.of(context)!
                                    .passwordConfirm,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              onChanged: (String? value) {
                                validedPassword = value!;
                              },
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .askCompleteField;
                                }
                                if (value != password) {
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
                                      password == validedPassword) {
                                    var body = {
                                      'firstName': firstName,
                                      'lastName': lastName,
                                      'email': mail,
                                      'password': password,
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
                                            extra: mail);
                                      } else {
                                        body = {
                                          'companyId': widget.orgId!,
                                        };
                                        await HttpService().request(
                                            'http://$serverIp:3000/api/organization/add-member',
                                            header,
                                            body);
                                        context.go("/register-confirmation",
                                            extra: mail);
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
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of(context)!
                                        .allreadyGotAccount,
                                    style: TextStyle(
                                      color: Provider.of<ThemeService>(context,
                                                  listen: false)
                                              .isDark
                                          ? darkTheme.primaryColor
                                          : lightTheme.primaryColor,
                                      fontSize:
                                          screenFormat == ScreenFormat.desktop
                                              ? desktopFontSize
                                              : tabletFontSize,
                                    ),
                                  ),
                                  MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: () {
                                        context.go("/login");
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)!.logInAsk,
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: screenFormat ==
                                                  ScreenFormat.desktop
                                              ? desktopFontSize
                                              : tabletFontSize,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
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
              )
            ],
          ),
        ]));
  }
}
