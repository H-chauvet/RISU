// ignore_for_file: use_build_context_synchronously, use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:footer/footer_view.dart';
import 'package:footer/footer.dart';
import 'package:front/components/custom_footer.dart';
import 'package:front/components/custom_header.dart';
import 'package:front/components/custom_toast.dart';
import 'package:front/network/informations.dart';
import 'package:front/services/size_service.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/globalStyle.dart';
import 'package:front/styles/themes.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

/// LandingPage
///
/// Home page for the web application
class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => LandingPageState();
}

/// LandingPageState
///
class LandingPageState extends State<LandingPage> {
  Function() disconnectFunction = () {};
  String? token = '';
  String? userMail = '';

  /// [Function] : Download the mobile application from the website
  void downloadApk() async {
    try {
      final response =
          await http.get(Uri.parse('http://$serverIp:3000/api/apk/download'));

      if (response.statusCode == 200) {
        final Uri url = Uri.parse('http://$serverIp:3000/api/apk/download');
        if (!await launchUrl(url)) {
          throw Exception('Could not launch $url');
        }
      } else {
        throw Exception('Failed to load apk');
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

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

  /// [Function] : Build the landing page
  @override
  Widget build(BuildContext context) {
    ScreenFormat screenFormat = SizeService().getScreenFormat(context);

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isPhone = constraints.maxWidth <= 600;

          if (isPhone) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Image.asset(
                      key: const Key('logo-risu'),
                      'assets/logonew.png',
                      width: 200,
                      height: 200,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    AppLocalizations.of(context)!.landingPitch1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenFormat == ScreenFormat.desktop
                          ? desktopBigFontSize
                          : tabletBigFontSize + 3,
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
                  const SizedBox(height: 70),
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!
                                    .landingPitch2Title,
                                style: TextStyle(
                                  fontSize: screenFormat == ScreenFormat.desktop
                                      ? desktopBigFontSize
                                      : tabletBigFontSize,
                                  color:
                                      Provider.of<ThemeService>(context).isDark
                                          ? darkTheme.secondaryHeaderColor
                                          : lightTheme.secondaryHeaderColor,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      color: Provider.of<ThemeService>(context)
                                              .isDark
                                          ? darkTheme.secondaryHeaderColor
                                          : lightTheme.secondaryHeaderColor,
                                      offset: const Offset(0.75, 0.75),
                                      blurRadius: 1.5,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .landingPitch2Text,
                                  style: TextStyle(
                                    fontSize:
                                        screenFormat == ScreenFormat.desktop
                                            ? desktopFontSize
                                            : tabletFontSize,
                                    color: Provider.of<ThemeService>(context)
                                            .isDark
                                        ? darkTheme.secondaryHeaderColor
                                        : lightTheme.secondaryHeaderColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 100),
                          Image.asset(
                            'assets/iphonenew.png',
                            scale: 1.5,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.downloadApp,
                          style: TextStyle(
                            fontSize: screenFormat == ScreenFormat.desktop
                                ? desktopBigFontSize
                                : tabletBigFontSize,
                            color: Provider.of<ThemeService>(context).isDark
                                ? darkTheme.secondaryHeaderColor
                                : lightTheme.secondaryHeaderColor,
                            fontWeight: FontWeight.bold,
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
                        const SizedBox(height: 5),
                        Text(
                          AppLocalizations.of(context)!.androidAvailable,
                          style: TextStyle(
                            fontSize: screenFormat == ScreenFormat.desktop
                                ? desktopFontSize
                                : tabletFontSize,
                            color: Provider.of<ThemeService>(context).isDark
                                ? darkTheme.secondaryHeaderColor
                                : lightTheme.secondaryHeaderColor,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => downloadApk(),
                          key: const Key('btn-download'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.downloadApplication,
                            style: TextStyle(
                              fontSize: screenFormat == ScreenFormat.desktop
                                  ? desktopFontSize
                                  : tabletFontSize,
                              color: Provider.of<ThemeService>(context).isDark
                                  ? darkTheme.secondaryHeaderColor
                                  : lightTheme.secondaryHeaderColor,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Scaffold(
              body: FooterView(
                flex: 10,
                footer: Footer(
                  padding: EdgeInsets.zero,
                  child: const CustomFooter(),
                ),
                children: [
                  LandingAppBar(context: context),
                  Column(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.landingPitch1,
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
                      const SizedBox(height: 100),
                      Container(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!
                                        .landingPitch2Title,
                                    style: TextStyle(
                                      fontSize:
                                          screenFormat == ScreenFormat.desktop
                                              ? desktopBigFontSize
                                              : tabletBigFontSize,
                                      color: Provider.of<ThemeService>(context)
                                              .isDark
                                          ? darkTheme.secondaryHeaderColor
                                          : lightTheme.secondaryHeaderColor,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          color: Provider.of<ThemeService>(
                                                      context)
                                                  .isDark
                                              ? darkTheme.secondaryHeaderColor
                                              : lightTheme.secondaryHeaderColor,
                                          offset: const Offset(0.75, 0.75),
                                          blurRadius: 1.5,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .landingPitch2Text,
                                      style: TextStyle(
                                        fontSize:
                                            screenFormat == ScreenFormat.desktop
                                                ? desktopFontSize
                                                : tabletFontSize,
                                        color:
                                            Provider.of<ThemeService>(context)
                                                    .isDark
                                                ? darkTheme.secondaryHeaderColor
                                                : lightTheme
                                                    .secondaryHeaderColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 100),
                              Image.asset(
                                'assets/iphonenew.png',
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      Container(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/containerrisu.png',
                              ),
                              const SizedBox(width: 100),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!
                                        .landingPitch3Title,
                                    style: TextStyle(
                                      fontSize:
                                          screenFormat == ScreenFormat.desktop
                                              ? desktopBigFontSize
                                              : tabletBigFontSize,
                                      color: Provider.of<ThemeService>(context)
                                              .isDark
                                          ? darkTheme.secondaryHeaderColor
                                          : lightTheme.secondaryHeaderColor,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          color: Provider.of<ThemeService>(
                                                      context)
                                                  .isDark
                                              ? darkTheme.secondaryHeaderColor
                                              : lightTheme.secondaryHeaderColor,
                                          offset: const Offset(0.75, 0.75),
                                          blurRadius: 1.5,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .landingPitch3Text,
                                      style: TextStyle(
                                        fontSize:
                                            screenFormat == ScreenFormat.desktop
                                                ? desktopFontSize
                                                : tabletFontSize,
                                        color:
                                            Provider.of<ThemeService>(context)
                                                    .isDark
                                                ? darkTheme.secondaryHeaderColor
                                                : lightTheme
                                                    .secondaryHeaderColor,
                                      ),
                                    ),
                                  ),
                                ],
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
        },
      ),
    );
  }
}
