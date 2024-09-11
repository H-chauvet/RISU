import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:front/components/custom_toast.dart';
import 'package:front/network/informations.dart';
import 'package:front/services/size_service.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/themes.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'google_style.dart';

///
/// Google button
///
class GoogleLogo extends StatelessWidget {
  GoogleLogo({super.key, required this.screenFormat});

  final GoogleSignIn _googleSignIn = GoogleSignIn(
      clientId:
          "750790002860-f4p6kt271o3fsp30ii3eqjj8hm7ehqve.apps.googleusercontent.com");

  final ScreenFormat screenFormat;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        startSignIn(context);
      },
      child: Container(
        height: screenFormat == ScreenFormat.desktop
            ? desktopButtonHeight
            : tabletButtonHeight,
        width: screenFormat == ScreenFormat.desktop
            ? desktopButtonWidth
            : tabletButtonWidth,
        decoration: BoxDecoration(
            color: Provider.of<ThemeService>(context).isDark
                ? boxDecorationDarkTheme.color
                : boxDecorationLightTheme.color,
            borderRadius: const BorderRadius.all(Radius.circular(30.0))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
                color: Theme.of(context).buttonTheme.colorScheme!.primary,
                child: Image.asset(
                  'assets/google-logo.png',
                  height: 20,
                )),
            const SizedBox(
              width: 5.0,
            ),
            Text(
              AppLocalizations.of(context)!.google,
              style: TextStyle(
                  fontSize: screenFormat == ScreenFormat.desktop
                      ? desktopFontSize
                      : tabletFontSize,
                  color: Provider.of<ThemeService>(context).isDark
                      ? darkTheme.primaryColor
                      : lightTheme.primaryColor),
            )
          ],
        ),
      ),
    );
  }

  void startSignIn(BuildContext context) async {
    await _googleSignIn.signOut();
    GoogleSignInAccount? user = await _googleSignIn.signInSilently();

    if (user == null) {
      user = await _googleSignIn.signIn();
      if (user == null) {
        print('error');
      } else {
        // ignore: use_build_context_synchronously
        registerGoogleConnection(user, context);
      }
    } else {
      // ignore: use_build_context_synchronously
      registerGoogleConnection(user, context);
    }
  }

  void registerGoogleConnection(
      GoogleSignInAccount user, BuildContext context) async {
    dynamic response;
    await http
        .post(
          Uri.parse('http://$serverIp:3000/api/auth/google-login'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Access-Control-Allow-Origin': '*',
          },
          body: jsonEncode(<String, String>{'email': user.email}),
        )
        .then((value) => {
              if (value.statusCode == 200)
                {
                  showCustomToast(
                    context,
                    AppLocalizations.of(context)!.loggedIn,
                    true,
                  ),
                  response = jsonDecode(value.body),
                  StorageService()
                      .writeStorage('token', response['accessToken']),
                  context.go('/')
                }
              else
                {
                  showCustomToast(context, response.body, false),
                }
            });
  }
}
