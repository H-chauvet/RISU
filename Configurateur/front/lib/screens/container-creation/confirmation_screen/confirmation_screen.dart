import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:front/components/custom_footer.dart';
import 'package:front/components/custom_header.dart';
import 'package:front/services/size_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/globalStyle.dart';
import 'package:front/styles/themes.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'confirmation_screen_style.dart';

/// ConfirmationScreen
///
/// Redirect page for the confirmation of the order
class ConfirmationScreen extends StatefulWidget {
  const ConfirmationScreen({super.key});

  @override
  State<ConfirmationScreen> createState() => ConfirmationScreenState();
}

/// ConfirmationScreenState
///
class ConfirmationScreenState extends State<ConfirmationScreen> {
  /// [Widget] : Build the confirmation page
  @override
  Widget build(BuildContext context) {
    ScreenFormat screenFormat = SizeService().getScreenFormat(context);
    return Scaffold(
      body: FooterView(
        flex: 8,
        footer: Footer(
          child: CustomFooter(),
        ),
        children: [
          LandingAppBar(context: context),
          Text(
            AppLocalizations.of(context)!.orderConfirmation,
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
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 600),
              child: FractionallySizedBox(
                widthFactor: screenFormat == ScreenFormat.desktop
                    ? desktopWidthFactor
                    : tabletWidthFactor,
                heightFactor: heightFactor,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        AppLocalizations.of(context)!
                            .orderConfirmationReturnHome,
                        style: TextStyle(
                          color: Provider.of<ThemeService>(context).isDark
                              ? darkTheme.primaryColor
                              : lightTheme.primaryColor,
                          fontSize: screenFormat == ScreenFormat.desktop
                              ? desktopBigFontSize
                              : tabletBigFontSize,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 80.0,
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
                                style: const TextStyle(
                                    color: Colors.blue, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
