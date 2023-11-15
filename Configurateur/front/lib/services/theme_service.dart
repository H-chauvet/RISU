import 'package:flutter/material.dart';

class ThemeService extends ChangeNotifier {
  static final ThemeService _singleton = ThemeService._internal();

  factory ThemeService() {
    return _singleton;
  }

  ThemeService._internal();

  bool _isDark = false;

  bool get isDark => _isDark;

  void switchTheme() {
    _isDark = !_isDark;
    return notifyListeners();
  }
}
