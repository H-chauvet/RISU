import 'package:flutter/material.dart';

class MyColors {
  static const Color textTitle = Color(0xFF0F3F62);
  static const Color textPrimary = Color(0xFF2996CE);
  static const Color textSecondary = Color(0xFF9898A5);
  static const Color textDanger = Color(0xFFF64E60);
  static const Color textSuccess = Color(0xFF198754);
  static const Color textInputLabel = Color(0xFF0F3F62);
  static const Color textInputBackgroundDefault = Color(0xFFF2F1F6);
  static const Color textInputBackgroundFocused = Color(0xFFFFFFFF);
  static const Color textInputBorderDefault = Color(0x00000000);
  static const Color textInputBorderFocused = Color(0xFFB5B5C3);
  static const Color textInputRightIcon = Color(0xFFA2A1A6);
  static const Color textInputHint = Color(0xFF808080);
  static const Color textInputText = Color(0xFF000000);
  static const Color iconButtonIcon = Color(0xFFB5B5C3);
  static const Color iconButtonBackground = Color(0xFFF2F1F6);
  static const Color iconButtonBackIcon = Color(0xFF0F3F62);
  static const Color appBarBackground = Color(0xFFFFFFFF);
  static const Color alertDialogErrorTitle = Color(0xFFF64E60);
  static const Color alertDialogInfoTitle = Color(0xFF0F3F62);
  static const Color circleAvatarBackground = Color(0xFFF2F1F6);
  static const Color white = Color(0xFFFFFFFF);
  static const Color iconButtonBackgroundUnavailable = Color(0xFFE5E5E5);
  static const Color containerBackgroundSettingsAppointment = Color(0xFFE5E5E5);
}

final lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xFF4682B4),
  secondaryHeaderColor: const Color(0xFF23415A),
  colorScheme: const ColorScheme.light(
    background: Color(0xFFE5E5E5),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: false,
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(
        Radius.circular(8.0),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xFFA1C1DB),
        width: 2.0,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(8.0),
      ),
    ),
    hintStyle: TextStyle(
      color: Color(0xFF808080),
    ),
    labelStyle: TextStyle(
      color: Color(0xFF000000),
    ),
    floatingLabelStyle: TextStyle(
      color: Color(0xFF0F3F62),
    ),
  ),
  buttonTheme: const ButtonThemeData(
    colorScheme: ColorScheme.light(
      secondary: Color(0xFFA1C1DB),
    ),
  ),
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color(0xFF23415A),
  secondaryHeaderColor: const Color(0xFF4682B4),
  colorScheme: const ColorScheme.dark(
    background: Color(0xFF1E1E1E),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: false,
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(
        Radius.circular(8.0),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xFFA1C1DB),
        width: 2.0,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(8.0),
      ),
    ),
    hintStyle: TextStyle(
      color: Color(0xFF808080),
    ),
    labelStyle: TextStyle(
      color: Color(0xFFFFFFFF),
    ),
    floatingLabelStyle: TextStyle(
      color: Color(0xFF4682B4),
    ),
  ),
  buttonTheme: const ButtonThemeData(
    colorScheme: ColorScheme.dark(
      secondary: Color(0xFFA1C1DB),
    ),
  ),
);
