import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:front/components/custom_footer.dart';
import 'package:front/components/custom_header.dart';
import 'package:front/components/custom_toast.dart';
import 'package:front/components/google/google.dart';
import 'package:front/network/informations.dart';
import 'package:front/services/size_service.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/globalStyle.dart';
import 'package:front/styles/themes.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import './login_style.dart';

/// LoginScreen
///
/// Page to be connected to the web application
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

/// LoginScreenState
///
class LoginScreenState extends State<LoginScreen> {
  String? token = '';
  String? userMail = '';

  /// [Function] : Check the token in the storage service
  void checkToken() async {
    token = await storageService.readStorage('token');
    storageService.getUserMail().then((value) => userMail = value);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    checkToken();
  }

  /// [Widget] : Build the login page
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    String mail = '';
    String password = '';
    dynamic response;

    ScreenFormat screenFormat = SizeService().getScreenFormat(context);

    return Scaffold(
      body: FooterView(
          flex: 10,
          footer: Footer(
            padding: EdgeInsets.zero,
            child: CustomFooter(),
          ),
          children: [
            Column(
              children: [
                LandingAppBar(context: context),
                Text(
                  AppLocalizations.of(context)!.logInRisu,
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
                            key: const Key('email'),
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(context)!.emailFill,
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
                              labelText: AppLocalizations.of(context)!.password,
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
                          MouseRegion(
                            cursor: SystemMouseCursors
                                .click, // Changez l'icône de la souris ici
                            child: GestureDetector(
                              onTap: () {
                                context.go("/password-recuperation");
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      AppLocalizations.of(context)!
                                          .passwordForgot,
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize:
                                            screenFormat == ScreenFormat.desktop
                                                ? desktopFontSize
                                                : tabletFontSize,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
                              key: const Key('login'),
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  http
                                      .post(
                                        Uri.parse(
                                            'http://$serverIp:3000/api/auth/login'),
                                        headers: <String, String>{
                                          'Content-Type':
                                              'application/json; charset=UTF-8',
                                          'Access-Control-Allow-Origin': '*',
                                        },
                                        body: jsonEncode(<String, String>{
                                          'email': mail,
                                          'password': password,
                                        }),
                                      )
                                      .then((value) => {
                                            if (value.statusCode == 200)
                                              {
                                                showCustomToast(
                                                    context,
                                                    "Vous êtes désormais connecté !",
                                                    true),
                                                response =
                                                    jsonDecode(value.body),
                                                response['accessToken'],
                                                storageService.writeStorage(
                                                  'token',
                                                  response['accessToken'],
                                                ),
                                                context.go("/")
                                              }
                                            else
                                              {
                                                showCustomToast(
                                                    context,
                                                    AppLocalizations.of(
                                                            context)!
                                                        .logInFailed,
                                                    false),
                                              }
                                          });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.logInAction,
                                style: TextStyle(
                                  color:
                                      Provider.of<ThemeService>(context).isDark
                                          ? darkTheme.primaryColor
                                          : lightTheme.primaryColor,
                                  fontSize: screenFormat == ScreenFormat.desktop
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
                                  AppLocalizations.of(context)!.newRisu,
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
                                      context.go("/register");
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!.register,
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize:
                                            screenFormat == ScreenFormat.desktop
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
                            AppLocalizations.of(context)!.logInWith,
                            style: TextStyle(
                                color: Provider.of<ThemeService>(context,
                                            listen: false)
                                        .isDark
                                    ? darkTheme.primaryColor
                                    : lightTheme.primaryColor,
                                fontSize: screenFormat == ScreenFormat.desktop
                                    ? desktopFontSize
                                    : tabletFontSize),
                          ),
                          const SizedBox(height: 10),
                          GoogleLogo(
                            screenFormat: screenFormat,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ]),
    );
  }
}
