import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risu/pages/history_location/history_page.dart';
import 'package:risu/pages/map/map_page.dart';

import '../../components/alert_dialog.dart';
import '../../components/appbar.dart';
import '../../components/bottomnavbar.dart';
import '../../network/informations.dart';
import '../../utils/theme.dart';
import '../login/login_page.dart';
import '../profile/profile_page.dart';
import 'home_page.dart';

class HomePageState extends State<HomePage> {
  int _currentIndex = 1;
  final List<Widget> _pages = [
    HistoryLocationPage(),
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
      print('firstName: $firstName');
      if (firstName == null || lastName == null) {
        await Future.delayed(Duration.zero, () {
          MyAlertDialog.showChoiceAlertDialog(
            context: context,
            title: 'Profil incomplet',
            message: 'Veuillez compléter votre profil avant de continuer.',
            onOkName: 'Compléter le profil',
            onOk: () {
              Navigator.pop(context, 'OK');
              setState(() {
                _currentIndex = 2;
              });
            },
            onCancelName: 'Annuler',
          );
        });
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
    print(didAskForProfile);
    if (userInformation != null) {
      return const LoginPage();
    } else {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: MyAppBar(
          curveColor: context.select((ThemeProvider themeProvider) =>
              themeProvider.currentTheme.secondaryHeaderColor),
          showBackButton: false,
          showLogo: true,
          showBurgerMenu: true,
        ),
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavBar(
          theme: context.select(
              (ThemeProvider themeProvider) => themeProvider.currentTheme),
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      );
    }
  }
}
