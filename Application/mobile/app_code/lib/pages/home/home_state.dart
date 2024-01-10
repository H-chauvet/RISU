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
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: [
                SizedBox(
                  height: 128,
                  child: DrawerHeader(
                    padding: const EdgeInsets.only(left: 32, top: 8),
                    decoration: BoxDecoration(
                      color: context.select((ThemeProvider themeProvider) =>
                          themeProvider.currentTheme.secondaryHeaderColor),
                    ),
                    child: const Text(
                      'Menu',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    child: Column(
                      children: [
                        SizedBox(height: 16),
                        MyParameter(
                          goToPage: _pages[2],
                          title: 'Profil',
                          paramIcon: Icon(Icons.person),
                        ),
                        SizedBox(height: 8),
                        MyParameter(
                          goToPage: ProfileInformationsPage(),
                          title: 'Notifications',
                          paramIcon: Icon(Icons.notifications_active),
                          locked: true,
                        ),
                        SizedBox(height: 8),
                        MyParameter(
                          goToPage: OpinionPage(),
                          title: 'Avis',
                          paramIcon: Icon(Icons.star),
                        ),
                        SizedBox(height: 8),
                        MyParameter(
                          goToPage: SettingsPage(),
                          title: 'Paramètres',
                          paramIcon: Icon(Icons.settings),
                        ),
                      ],
                    )),
              ],
            ),
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
