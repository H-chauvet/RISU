import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risu/pages/history_location/history_page.dart';
import 'package:risu/pages/map/map_page.dart';

import '../../components/appbar.dart';
import '../../components/bottomnavbar.dart';
import '../../network/informations.dart';
import '../../utils/theme.dart';
import '../history_location/history_functional.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (logout || userInformation == null) {
      userInformation = null;
      return const LoginPage();
    } else {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: MyAppBar(
          curveColor: context.select((ThemeProvider themeProvider) =>
              themeProvider.currentTheme.primaryColor),
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
