// ignore_for_file: use_build_context_synchronously, use_full_hex_values_for_flutter_colors

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:footer/footer_view.dart';
import 'package:footer/footer.dart';
import 'package:front/components/custom_footer.dart';
import 'package:front/components/custom_header.dart';
import 'package:front/services/size_service.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/globalStyle.dart';
import 'package:front/styles/themes.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// NotFoundPage
///
/// Home page for the web application
class NotFoundPage extends StatefulWidget {
  const NotFoundPage({super.key});

  @override
  State<NotFoundPage> createState() => NotFoundPageState();
}

/// NotFoundPageState
///
class NotFoundPageState extends State<NotFoundPage> {
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

  /// [Function] : Build the NotFound page
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
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  LandingAppBar(context: context),
                  const SizedBox(height: 200),
                  Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Cette page n'existe pas !",
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
                          ),
                        ),
                        const SizedBox(height: 20),
                        RichText(
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          text: TextSpan(
                            text:
                                "Nous ne parvenons pas à trouver la page que vous recherchez.\nEssayez de retourner à la page précédente ou veuillez ",
                            style: TextStyle(
                              fontSize: screenFormat == ScreenFormat.desktop
                                  ? desktopFontSize
                                  : tabletFontSize,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              color: Provider.of<ThemeService>(context).isDark
                                  ? darkTheme.secondaryHeaderColor
                                  : lightTheme.secondaryHeaderColor,
                            ),
                            children: [
                              TextSpan(
                                text: 'Contacter le support',
                                style: TextStyle(
                                  color:
                                      Provider.of<ThemeService>(context).isDark
                                          ? Colors.blue[300]
                                          : Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    context.go('/contact');
                                  },
                              ),
                              const TextSpan(
                                text: '.',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 50),
                        ElevatedButton(
                          key: const Key('back-home'),
                          onPressed: () {
                            context.go("/");
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: Text(
                            "Retour à l'accueil",
                            style: TextStyle(
                              color: Provider.of<ThemeService>(context).isDark
                                  ? darkTheme.primaryColor
                                  : lightTheme.primaryColor,
                              fontSize: screenFormat == ScreenFormat.desktop
                                  ? desktopFontSize
                                  : tabletFontSize,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ]),
    );
  }
}