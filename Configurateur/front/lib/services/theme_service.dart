import 'package:flutter/material.dart';

/// ContainerPageState
///
/// Service to switch between dark and light theme
/// [_isDark] : if isDark is true : dark theme is activated, if isDark is false : light theme is activated
class ThemeService extends ChangeNotifier {
  bool _isDark = false;

  bool get isDark => _isDark;

  /// [Function] : Switch between light and dark theme
  void switchTheme() {
    _isDark = !_isDark;
    return notifyListeners();
  }
}
