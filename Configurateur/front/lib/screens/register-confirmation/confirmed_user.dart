import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:front/components/custom_footer.dart';
import 'package:front/components/custom_header.dart';
import 'package:front/network/informations.dart';
import 'package:front/services/size_service.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/globalStyle.dart';
import 'package:front/styles/themes.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'dart:convert';

/// ConfirmedUser
///
/// Page to inform the user of the account creation confirmation email
class ConfirmedUser extends StatefulWidget {
  const ConfirmedUser({super.key, required this.params});

  final String params;

  @override
  State<ConfirmedUser> createState() => ConfirmedUserState();
}

/// ConfirmedState
///
class ConfirmedUserState extends State<ConfirmedUser> {
  String jwtToken = '';
  dynamic response;

  @override
  void initState() {
    http
        .post(
          Uri.parse('http://$serverIp:3000/api/auth/confirmed-register'),
          headers: <String, String>{
            'Authorization': jwtToken,
            'Content-Type': 'application/json; charset=UTF-8',
            'Access-Control-Allow-Origin': '*',
          },
          body: jsonEncode(<String, String>{
            'uuid': widget.params,
          }),
        )
        .then((value) => {
              if (value.statusCode == 200)
                {
                  response = jsonDecode(value.body),
                  storageService.writeStorage(
                    'token',
                    response['accessToken'],
                  ),
                }
            });
    super.initState();
  }

  /// [Widget] : Build the confirmation page
  @override
  Widget build(BuildContext context) {
    ScreenFormat screenFormat = SizeService().getScreenFormat(context);

    return Scaffold(
      body: FooterView(
        flex: 8,
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
          Column(
            children: [
              Center(
                child: SizedBox(
                  width: 60.0.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.registerComfirmedMessage,
                        style: TextStyle(
                          fontSize: screenFormat == ScreenFormat.desktop
                              ? desktopBigFontSize
                              : tabletBigFontSize,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 20.0.h,
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
                                    fontSize:
                                        screenFormat == ScreenFormat.desktop
                                            ? desktopFontSize
                                            : tabletFontSize,
                                  ),
                                ),
                              ]),
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
