import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:risu/components/parameter.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/login/login_page.dart';
import 'package:risu/pages/opinion/opinion_page.dart';
import 'package:risu/pages/profile/informations/informations_page.dart';
import 'package:risu/pages/settings/settings_page.dart';
import 'package:risu/pages/settings/settings_pages/notifications/notifications_page.dart';
import 'package:risu/utils/providers/theme.dart';

class BurgerDrawer extends StatelessWidget {
  const BurgerDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6, // 60 % of the screen
      child: Drawer(
        child: Column(
          children: [
            SizedBox(
              height: 128,
              width: double.infinity,
              child: DrawerHeader(
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: context.select((ThemeProvider themeProvider) =>
                      themeProvider.currentTheme.secondaryHeaderColor),
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    key: const Key('appbar-image_logo'),
                    'assets/logo_noir.png',
                    height: 64,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            MyRedirectDivider(
              goToPage: const ProfileInformationsPage(),
              title: AppLocalizations.of(context)!.profileDetails,
              paramIcon: const Icon(Icons.person),
            ),
            const SizedBox(height: 8),
            MyRedirectDivider(
              goToPage: const NotificationsPage(),
              title: AppLocalizations.of(context)!.notifications,
              paramIcon: const Icon(Icons.notifications),
            ),
            const SizedBox(height: 8),
            MyRedirectDivider(
              goToPage: const SettingsPage(),
              title: AppLocalizations.of(context)!.settings,
              paramIcon: const Icon(Icons.settings),
            ),
            const Spacer(),
            if (userInformation != null)
              MyRedirectDivider(
                key: const Key('burgerdrawer-logout'),
                goToPage: const LoginPage(),
                title: AppLocalizations.of(context)!.logOut,
                paramIcon: const Icon(Icons.logout),
                disconnect: true,
                chosenPlace: DIVIDERPLACE.top,
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
