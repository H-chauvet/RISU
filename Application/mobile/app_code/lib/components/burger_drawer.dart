import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:risu/components/parameter.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/home/home_page.dart';
import 'package:risu/pages/profile/informations/informations_page.dart';
import 'package:risu/pages/settings/settings_page.dart';
import 'package:risu/pages/settings/settings_pages/notifications/notifications_page.dart';
import 'package:risu/utils/providers/theme.dart';

/// The burger drawer that appears when the user clicks on the burger icon.
/// It contains the user's profile, notifications, settings and a log out button.
class BurgerDrawer extends StatelessWidget {
  const BurgerDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6, // 60 % of the screen
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
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
                  child: Image.asset(
                    fit: BoxFit.cover,
                    key: const Key('appbar-image_logo'),
                    'assets/logo.png',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              MyRedirectDivider(
                goToPage: const ProfileInformationsPage(),
                title: AppLocalizations.of(context)!.profileDetails,
                paramIcon: Icons.person,
              ),
              const SizedBox(height: 8),
              MyRedirectDivider(
                goToPage: const NotificationsPage(),
                title: AppLocalizations.of(context)!.notifications,
                paramIcon: Icons.notifications,
              ),
              const SizedBox(height: 8),
              MyRedirectDivider(
                goToPage: const SettingsPage(),
                title: AppLocalizations.of(context)!.settings,
                paramIcon: Icons.settings,
              ),
              const Spacer(),
              if (userInformation != null)
                MyRedirectDivider(
                  key: const Key('burgerdrawer-logout'),
                  goToPage: const HomePage(),
                  title: AppLocalizations.of(context)!.logOut,
                  paramIcon: Icons.logout,
                  disconnect: true,
                  chosenPlace: DIVIDERPLACE.top,
                ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
