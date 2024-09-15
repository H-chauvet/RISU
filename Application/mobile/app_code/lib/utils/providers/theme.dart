import 'package:flutter/material.dart';
import 'package:risu/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

dynamic appTheme = {
  'clair': 'Clair',
  'sombre': 'Sombre',
  'systeme': 'Système',
};

/// This class is used to manage the theme of the application.
/// It allows to change the theme of the application.
/// It also allows to know if the application is in dark mode.
class ThemeProvider extends ChangeNotifier {
  late ThemeData _currentTheme;

  ThemeProvider(String currentTheme) {
    if (currentTheme == appTheme['sombre']) {
      _currentTheme = darkTheme;
    } else if (currentTheme == appTheme['clair']) {
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

  /// Check if the app is in dark mode.
  bool isAppInDarkMode() {
    return _currentTheme == darkTheme;
  }

  /// Start the system theme listener.
  void startSystemThemeListener() {
    SharedPreferences.getInstance().then((prefs) {
      final theme = prefs.getString('appTheme') ?? 'Clair';
      if (theme == 'Système') {
        WidgetsBinding.instance.window.onPlatformBrightnessChanged = () {
          setTheme(appTheme['systeme']);
        };
      }
    });
  }

  /// Get the system theme
  Future<bool> getIsSystemInDarkMode() async {
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark;
  }

  /// Set the theme.
  /// This function is used to set the theme of the application.
  /// params:
  /// [theme] - theme to set.
  void setTheme(String theme) async {
    if (theme != appTheme['clair'] &&
        theme != appTheme['sombre'] &&
        theme != appTheme['systeme']) {
      return;
    }
    if (theme == appTheme['systeme']) {
      bool isSystemInDarkMode = await getIsSystemInDarkMode();
      if (isSystemInDarkMode) {
        _currentTheme = darkTheme;
      } else {
        _currentTheme = lightTheme;
      }
    } else {
      if (theme == appTheme['clair']) {
        _currentTheme = lightTheme;
      } else {
        _currentTheme = darkTheme;
      }
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();

    if (theme == appTheme['systeme']) {
      prefs.setString('appTheme', appTheme['systeme']);
    } else if (theme == appTheme['clair']) {
      prefs.setString('appTheme', appTheme['clair']);
    } else if (theme == appTheme['sombre']) {
      prefs.setString('appTheme', appTheme['sombre']);
    } else {
      throw Exception('Theme not found');
    }
  }
}
