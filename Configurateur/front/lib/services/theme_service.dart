import 'package:flutter/material.dart';

class ThemeService extends ChangeNotifier {
  bool _isDark = false;

  bool get isDark => _isDark;

  void switchTheme() {
    _isDark = !_isDark;
    return notifyListeners();
  }
}
