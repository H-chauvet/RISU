import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risu/components/parameter.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/profile/informations/informations_page.dart';
import 'package:risu/pages/profile/profile_page.dart';

import '../pages/login/login_page.dart';
import '../pages/opinion/opinion_page.dart';
import '../pages/settings/settings_page.dart';
import '../utils/theme.dart';

class BurgerDrawer extends StatelessWidget {
  const BurgerDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.6, // 60 % of the screen
        child: Drawer(
            child: Column(children: [
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
          const MyRedirectDivider(
            goToPage: ProfileInformationsPage(),
            title: 'Détails du profil',
            paramIcon: Icon(Icons.person),
          ),
          const SizedBox(height: 8),
          const MyRedirectDivider(
            goToPage: LoginPage(),
            title: 'Notifications',
            paramIcon: Icon(Icons.lock),
            disconnect: true, // Temporary before implementation
          ),
          const SizedBox(height: 8),
          const MyRedirectDivider(
            goToPage: OpinionPage(),
            title: 'Avis',
            paramIcon: Icon(Icons.star),
          ),
          const SizedBox(height: 8),
          const MyRedirectDivider(
            goToPage: SettingsPage(),
            title: 'Paramètres',
            paramIcon: Icon(Icons.settings),
          ),
          const Spacer(),
          const MyRedirectDivider(
            goToPage: LoginPage(),
            title: 'Déconnexion',
            paramIcon: Icon(Icons.logout),
            disconnect: true,
            chosenPlace: DIVIDERPLACE.top,
          ),
          const SizedBox(height: 8),
        ])));
  }
}