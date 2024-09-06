import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:front/components/alert_dialog.dart';
import 'package:front/components/custom_footer.dart';
import 'package:front/components/custom_header.dart';
import 'package:front/services/size_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/globalStyle.dart';
import 'package:front/styles/themes.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// [StatefulWidget] : AdminPage
///
/// Page only for the admin to manage the database easier
class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

/// AdminPageState
///
class _AdminPageState extends State<AdminPage> {
  @override
  void initState() {
    super.initState();

    /// Regarde si l'utilisateur est administrateur
    MyAlertTest.checkSignInStatusAdmin(context);
  }

  /// [Widget] : Build the admin page
  @override
  Widget build(BuildContext context) {
    ScreenFormat screenFormat = SizeService().getScreenFormat(context);
    return Scaffold(
      body: FooterView(
        footer: Footer(
          child: CustomFooter(context: context),
        ),
        children: [
          LandingAppBar(context: context),
          Text(
            AppLocalizations.of(context)!.adminRisu,
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
          const SizedBox(height: 150),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            key: const Key('btn-messages'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20.0), // Définit le rayon du bouton arrondi
                              ),
                            ),
                            onPressed: () {
                              context.go("/admin/messages");
                            },
                            child: Text(
                              AppLocalizations.of(context)!.messageHandling,
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
                          const SizedBox(height: 30),
                          Text(
                            AppLocalizations.of(context)!.messageListAccess,
                            style: TextStyle(
                              color: Provider.of<ThemeService>(context).isDark
                                  ? darkTheme.secondaryHeaderColor
                                  : lightTheme.secondaryHeaderColor,
                            ),
                            softWrap: true,
                            maxLines: 3,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 200,
                        child: VerticalDivider(
                          thickness: 2,
                          width: 100,
                          color: Colors.black,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            key: const Key('btn-user'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20.0), // Définit le rayon du bouton arrondi
                              ),
                            ),
                            onPressed: () {
                              context.go("/userList");
                            },
                            child: Text(
                              AppLocalizations.of(context)!.userHandling,
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
                          const SizedBox(height: 30),
                          Text(
                            AppLocalizations.of(context)!.userListAccess,
                            style: TextStyle(
                              color: Provider.of<ThemeService>(context).isDark
                                  ? darkTheme.secondaryHeaderColor
                                  : lightTheme.secondaryHeaderColor,
                            ),
                            softWrap: true,
                            maxLines: 3,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 200,
                        child: VerticalDivider(
                          thickness: 2,
                          width: 100,
                          color: Colors.black,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            key: const Key('btn-article'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20.0), // Définit le rayon du bouton arrondi
                              ),
                            ),
                            onPressed: () {
                              context.go("/containerList");
                            },
                            child: Text(
                              AppLocalizations.of(context)!.containerHandling,
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
                          const SizedBox(height: 30),
                          Text(
                            AppLocalizations.of(context)!.itemListAccess,
                            style: TextStyle(
                              color: Provider.of<ThemeService>(context).isDark
                                  ? darkTheme.secondaryHeaderColor
                                  : lightTheme.secondaryHeaderColor,
                            ),
                            softWrap: true,
                            maxLines: 3,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
