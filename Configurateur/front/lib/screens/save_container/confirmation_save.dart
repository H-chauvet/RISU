import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/services/size_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/globalStyle.dart';
import 'package:front/styles/themes.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// ConfirmationSave
///
/// Page to confirm the container's save
class ConfirmationSave extends StatefulWidget {
  const ConfirmationSave({super.key});

  @override
  State<ConfirmationSave> createState() => ConfirmationSaveState();
}

/// ConfirmationSaveState
///
class ConfirmationSaveState extends State<ConfirmationSave> {
  /// [Widget] : Build the sauvegarde confirmation page
  @override
  Widget build(BuildContext context) {
    ScreenFormat screenFormat = SizeService().getScreenFormat(context);
    return Scaffold(
      appBar: CustomAppBar(
        AppLocalizations.of(context)!.saveConfirm,
        context: context,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.saveConfirmed,
              style: TextStyle(
                color: Provider.of<ThemeService>(context).isDark
                    ? darkTheme.primaryColor
                    : lightTheme.primaryColor,
                fontSize: screenFormat == ScreenFormat.desktop
                    ? desktopBigFontSize
                    : tabletBigFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              onPressed: () {
                context.go('/');
              },
              child: Text(
                AppLocalizations.of(context)!.backToHome,
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
      ),
    );
  }
}
