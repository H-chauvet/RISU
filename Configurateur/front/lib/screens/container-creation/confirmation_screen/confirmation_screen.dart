import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/components/custom_footer.dart';
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
      appBar: CustomAppBar(
        AppLocalizations.of(context)!.orderConfirmation,
        context: context,
      ),
      body: Center(
        child: FractionallySizedBox(
          widthFactor: screenFormat == ScreenFormat.desktop
              ? desktopWidthFactor
              : tabletWidthFactor,
          heightFactor: heightFactor,
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context)!.orderConfirmationReturnHome,
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
                        style:
                            const TextStyle(color: Colors.blue, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
