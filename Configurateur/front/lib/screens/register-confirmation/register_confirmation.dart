import 'package:flutter/material.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/main.dart';
import 'package:front/network/informations.dart';
import 'package:front/services/size_service.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/themes.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

import 'register_confirmation_style.dart';

class RegisterConfirmation extends StatefulWidget {
  const RegisterConfirmation({super.key, required this.params});

  final String params;

  @override
  State<RegisterConfirmation> createState() => RegisterConfirmationState();
}

///
/// Register confirmation screen
///
/// page de confirmation d'inscription pour le configurateur
class RegisterConfirmationState extends State<RegisterConfirmation> {
  String jwtToken = '';

  void checkToken() async {
    String? tokenStorage = await storageService.readStorage('token');
    if (tokenStorage != "") {
      jwtToken = tokenStorage!;
    } else {
      context.go("/login");
    }
  }

  @override
  void initState() {
    checkToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenFormat screenFormat = SizeService().getScreenFormat(context);
    DateTime lastClicked = DateTime.parse("1969-07-20 20:18:04Z");
    DateTime now = DateTime.now();
    return Scaffold(
        appBar: CustomAppBar(
          "Confirmation d'inscription",
          context: context,
        ),
        body: Center(
            child: FractionallySizedBox(
                widthFactor: screenFormat == ScreenFormat.desktop
                    ? desktopWidthFactor
                    : tabletWidthFactor,
                heightFactor: 0.7,
                child: Column(
                  children: [
                    Text(
                      "Afin de finaliser l'inscription de votre compte, merci de confirmer cette dernière grâce au lien que vous avez reçu par mail.",
                      style: TextStyle(
                          fontSize: screenFormat == ScreenFormat.desktop
                              ? desktopBigFontSize
                              : tabletBigFontSize),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 80.0,
                    ),
                    Text(
                      "Vous n'avez pas reçu le mail de confirmation ?",
                      style: TextStyle(
                        fontSize: screenFormat == ScreenFormat.desktop
                            ? desktopFontSize
                            : tabletFontSize,
                      ),
                    ),
                    const SizedBox(
                      height: 35.0,
                    ),
                    SizedBox(
                      height: 40,
                      width: screenFormat == ScreenFormat.desktop
                          ? desktopSendButtonWidth
                          : tabletSendButtonWidth,
                      child: ElevatedButton(
                        key: const Key('send-mail'),
                        onPressed: () async {
                          now = DateTime.now();
                          final difference =
                              now.difference(lastClicked).inMinutes;
                          if (difference >= 1) {
                            lastClicked = DateTime.now();
                            await http.post(
                              Uri.parse(
                                  'http://$serverIp:3000/api/auth/register-confirmation'),
                              headers: <String, String>{
                                'Authorization': jwtToken,
                                'Content-Type':
                                    'application/json; charset=UTF-8',
                                'Access-Control-Allow-Origin': '*',
                              },
                              body: jsonEncode(<String, String>{
                                'email': widget.params,
                              }),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: Text(
                          "Renvoyer le mail de confirmation",
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
                    const SizedBox(
                      height: 20.0,
                    ),
                    InkWell(
                      key: const Key('go-home'),
                      onTap: () {
                        context.go("/");
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Retour à l'accueil",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize:
                                        screenFormat == ScreenFormat.desktop
                                            ? desktopFontSize
                                            : tabletFontSize),
                              ),
                            ]),
                      ),
                    ),
                  ],
                ))));
  }
}
