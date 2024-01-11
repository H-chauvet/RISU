import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risu/components/alert_dialog.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/components/bottomnavbar.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/article/list_page.dart';
import 'package:risu/pages/login/login_page.dart';
import 'package:risu/pages/map/map_page.dart';
import 'package:risu/pages/profile/profile_page.dart';
import 'package:risu/pages/settings/settings_page.dart';
import 'package:risu/utils/check_signin.dart';
import 'package:risu/utils/theme.dart';

import '../../components/parameter.dart';
import '../opinion/opinion_page.dart';
import '../profile/informations/informations_page.dart';
import 'home_page.dart';

class HomePageState extends State<HomePage> {
  int _currentIndex = 1;
  final List<Widget> _pages = [
    ArticleListPage(),
    const MapPage(),
    const ProfilePage(),
  ];
  bool didAskForProfile = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!didAskForProfile) {
        configProfile();
      }
    });
  }

  void configProfile() async {
    try {
      String? firstName = userInformation?.firstName;
      String? lastName = userInformation?.lastName;
      if (userInformation?.email != null &&
          (firstName == null || lastName == null)) {
        await MyAlertDialog.showChoiceAlertDialog(
          context: context,
          title: 'Profil incomplet',
          message: 'Veuillez compléter votre profil avant de continuer.',
          onOkName: 'Compléter le profil',
          onCancelName: 'Annuler',
        ).then(
          (value) => {
            if (value)
              {
                setState(() {
                  _currentIndex = 2;
                }),
              }
          },
        );
      }
      setState(() {
        didAskForProfile = true;
      });
    } catch (e) {
      print('Error configProfile(): $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future<bool>.value(false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: MyAppBar(
          curveColor: context.select((ThemeProvider themeProvider) =>
              themeProvider.currentTheme.secondaryHeaderColor),
          showBackButton: false,
          showLogo: true,
          showBurgerMenu: false,
        ),
        endDrawer: SizedBox(
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
              MyRedirectDivider(
                goToPage: _pages[2],
                title: 'Profil',
                paramIcon: Icon(Icons.person),
              ),
              SizedBox(height: 8),
              MyRedirectDivider(
                goToPage: LoginPage(),
                title: 'Notifications',
                paramIcon: Icon(Icons.notifications_active),
                disconnect: true,
              ),
              SizedBox(height: 8),
              MyRedirectDivider(
                goToPage: OpinionPage(),
                title: 'Avis',
                paramIcon: Icon(Icons.star),
              ),
              SizedBox(height: 8),
              MyRedirectDivider(
                goToPage: SettingsPage(),
                title: 'Paramètres',
                paramIcon: Icon(Icons.settings),
              ),
              Spacer(),
              MyRedirectDivider(
                goToPage: LoginPage(),
                title: 'Déconnexion',
                paramIcon: Icon(Icons.logout),
                disconnect: true,
                chosenPlace: DIVIDERPLACE.top,
              ),
              SizedBox(height: 8),
            ]),
          ),
        ),
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavBar(
          theme: context.select(
              (ThemeProvider themeProvider) => themeProvider.currentTheme),
          currentIndex: _currentIndex,
          onTap: (index) async {
            if (index == 2) {
              bool signIn = await checkSignin(context);
              if (!signIn) {
                return;
              }
            }
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
