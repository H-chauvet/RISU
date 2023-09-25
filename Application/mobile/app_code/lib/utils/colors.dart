import 'package:flutter/material.dart';

class MyColors {
  static const Color primary = Color(0xFF4682B4);
  static const Color secondary = Color(0xFF23415A);
}

final lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: MyColors.primary,
  secondaryHeaderColor: MyColors.secondary,
  colorScheme: const ColorScheme.light(
    background: Color(0xFFE5E5E5),
  ),
  dialogTheme: const DialogTheme(
    backgroundColor: Color(0xFFFFFFFF),
    titleTextStyle: TextStyle(
      color: MyColors.secondary,
      fontWeight: FontWeight.bold,
      fontSize: 20.0,
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: false,
    fillColor: Color(0xFFE5E5E5),
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
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: MyColors.secondary,
    selectedItemColor: MyColors.primary,
    unselectedItemColor: Colors.white,
  ),
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: MyColors.secondary,
  secondaryHeaderColor: MyColors.primary,
  colorScheme: const ColorScheme.dark(
    background: Color(0xFF1E1E1E),
  ),
  dialogTheme: const DialogTheme(
    backgroundColor: Color(0xFF4E4E4E),
    titleTextStyle: TextStyle(
      color: MyColors.secondary,
      fontWeight: FontWeight.bold,
      fontSize: 20.0,
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: false,
    fillColor: Color(0xFF1E1E1E),
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
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: MyColors.secondary,
    selectedItemColor: MyColors.primary,
    unselectedItemColor: Colors.white,
  ),
);
