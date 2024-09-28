// ignore_for_file: use_build_context_synchronously, use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:footer/footer_view.dart';
import 'package:footer/footer.dart';
import 'package:front/components/custom_footer.dart';
import 'package:front/components/custom_header.dart';
import 'package:front/services/size_service.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/globalStyle.dart';
import 'package:front/styles/themes.dart';
import 'package:provider/provider.dart';

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
      body: FooterView(
        footer: Footer(
          padding: EdgeInsets.zero,
          child: CustomFooter(),
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
                            AppLocalizations.of(context)!.landingPitch2Title,
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
                                  color:
                                      Provider.of<ThemeService>(context).isDark
                                          ? darkTheme.secondaryHeaderColor
                                          : lightTheme.secondaryHeaderColor,
                                  offset: const Offset(0.75, 0.75),
                                  blurRadius: 1.5,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 15), // Espacement inférieur pour le texte
                            child: Text(
                              AppLocalizations.of(context)!.landingPitch2Text,
                              style: TextStyle(
                                fontSize: screenFormat == ScreenFormat.desktop
                                    ? desktopFontSize
                                    : tabletFontSize,
                                color: Provider.of<ThemeService>(context).isDark
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
                            AppLocalizations.of(context)!.landingPitch3Title,
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
                                  color:
                                      Provider.of<ThemeService>(context).isDark
                                          ? darkTheme.secondaryHeaderColor
                                          : lightTheme.secondaryHeaderColor,
                                  offset: const Offset(0.75, 0.75),
                                  blurRadius: 1.5,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 15), // Espacement inférieur pour le texte
                            child: Text(
                              AppLocalizations.of(context)!.landingPitch3Text,
                              style: TextStyle(
                                fontSize: screenFormat == ScreenFormat.desktop
                                    ? desktopFontSize
                                    : tabletFontSize,
                                color: Provider.of<ThemeService>(context).isDark
                                    ? darkTheme.secondaryHeaderColor
                                    : lightTheme.secondaryHeaderColor,
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
}
