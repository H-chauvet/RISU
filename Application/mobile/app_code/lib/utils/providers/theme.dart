import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../colors.dart';

class ThemeProvider extends ChangeNotifier {
  late ThemeData _currentTheme;

  ThemeProvider(bool isDarkTheme) {
    _currentTheme = isDarkTheme ? darkTheme : lightTheme;
  }

  ThemeData get currentTheme => _currentTheme;

  void toggleTheme() async {
    _currentTheme = _currentTheme == lightTheme ? darkTheme : lightTheme;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkTheme', _currentTheme == darkTheme);
  }
}
