import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'colors.dart';

enum AppTheme { clair, sombre, systeme }

class ThemeProvider extends ChangeNotifier {
  late ThemeData _currentTheme;

  ThemeProvider(String appTheme) {
    if (appTheme == 'Systeme') {
      _currentTheme = darkTheme;
    } else if (appTheme == 'Clair') {
      _currentTheme = lightTheme;
    } else {
      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      if (brightness == Brightness.dark) {
        _currentTheme = darkTheme;
      } else {
        _currentTheme = lightTheme;
      }
    }
  }

  ThemeData get currentTheme => _currentTheme;

  void toggleTheme() async {
    _currentTheme = _currentTheme == lightTheme ? darkTheme : lightTheme;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkTheme', _currentTheme == darkTheme);
  }

  Future<bool> getIsSystemInDarkMode() async {
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark;
  }

  void setTheme(AppTheme theme) async {
    if (theme != AppTheme.clair &&
        theme != AppTheme.sombre &&
        theme != AppTheme.systeme) {
      return;
    }
    if (theme == AppTheme.systeme) {
      bool isSystemInDarkMode = await getIsSystemInDarkMode();
      if (isSystemInDarkMode) {
        _currentTheme = darkTheme;
      } else {
        _currentTheme = lightTheme;
      }
    } else {
      if (theme == AppTheme.clair) {
        _currentTheme = lightTheme;
      } else {
        _currentTheme = darkTheme;
      }
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();

    if (theme == AppTheme.systeme) {
      prefs.setString('appTheme', 'Système');
    } else if (theme == AppTheme.clair) {
      prefs.setString('appTheme', 'Clair');
    } else {
      prefs.setString('appTheme', 'Sombre');
    }
  }
}
