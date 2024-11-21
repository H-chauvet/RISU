import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/components/custom_footer.dart';
import 'package:front/components/custom_header.dart';
import 'package:front/components/custom_toast.dart';
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

import 'register_confirmation_style.dart';

/// RegisterConfirmation
///
/// Page to confirm the account creation
class RegisterConfirmation extends StatefulWidget {
  const RegisterConfirmation({super.key, required this.params});

  final String params;

  @override
  State<RegisterConfirmation> createState() => RegisterConfirmationState();
}

/// RegisterConfirmationState
///
class RegisterConfirmationState extends State<RegisterConfirmation> {
  String jwtToken = '';

  /// [Function] : Check in storage service is the token is available
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

  /// [Widget] : Build the confirmation of the account creation
  @override
  Widget build(BuildContext context) {
    ScreenFormat screenFormat = SizeService().getScreenFormat(context);
    DateTime lastClicked = DateTime.parse("1969-07-20 20:18:04Z");
    DateTime now = DateTime.now();
    return Scaffold(
      body: FooterView(
        flex: 6,
        footer: Footer(
          padding: EdgeInsets.zero,
          child: CustomFooter(),
        ),
        children: [
          LandingAppBar(context: context),
          Text(
            AppLocalizations.of(context)!.registerComfirmed,
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
          const SizedBox(height: 50),
          Column(
            children: [
              Text(
                AppLocalizations.of(context)!.registerMessage,
                style: TextStyle(
                    fontSize: screenFormat == ScreenFormat.desktop
                        ? desktopFontSize
                        : tabletFontSize),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 80.0,
              ),
              Text(
                AppLocalizations.of(context)!.registerAskEmail,
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
                    showCustomToast(context,
                        AppLocalizations.of(context)!.registerEmail, true);
                    now = DateTime.now();
                    final difference = now.difference(lastClicked).inMinutes;
                    if (difference >= 1) {
                      lastClicked = DateTime.now();
                      await http.post(
                        Uri.parse(
                            'http://$serverIp:3000/api/auth/register-confirmation'),
                        headers: <String, String>{
                          'Authorization': jwtToken,
                          'Content-Type': 'application/json; charset=UTF-8',
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
                    AppLocalizations.of(context)!.registerResendEmail,
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
                        AppLocalizations.of(context)!.backToHome,
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: screenFormat == ScreenFormat.desktop
                              ? desktopFontSize
                              : tabletFontSize,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
