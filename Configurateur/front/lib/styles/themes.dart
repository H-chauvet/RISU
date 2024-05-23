import 'package:flutter/material.dart';

/// Themes file
///
/// File to define all the colors for the light and dark themes.

const lightElevatedButtonBackground = Color(0xFF28666E);

final lightTheme = ThemeData(
  useMaterial3: false,
  brightness: Brightness.light,
  primaryColor: const Color(0xFF162A49),
  secondaryHeaderColor: const Color(0xFF162A49),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xffFEDC97),
    titleTextStyle: TextStyle(
      color: Color(0xff033F63),
      fontSize: 40,
    ),
  ),
  bottomAppBarTheme: const BottomAppBarTheme(
    color: Color(0xffFEDC97),
  ),
  checkboxTheme: CheckboxThemeData(
    checkColor: MaterialStateProperty.all<Color>(const Color(0xff4682B4)),
    fillColor: MaterialStateProperty.all<Color>(Colors.white),
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Colors.black,
  ),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: const TextStyle(
      color: Colors.grey,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: const BorderSide(
        color: Color.fromRGBO(126, 132, 138, 1),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: const BorderSide(
        color: Color.fromRGBO(126, 132, 138, 1),
      ),
    ),
  ),
  buttonTheme: const ButtonThemeData(
    colorScheme: ColorScheme.light(
      brightness: Brightness.light,
      primary: Color(0xffFEDC97),
    ),
    textTheme: ButtonTextTheme.normal,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      textStyle: MaterialStateProperty.all<TextStyle>(
        const TextStyle(
          color: Color(0xffFEDC97),
        ),
      ),
      backgroundColor:
          MaterialStateProperty.all<Color>(const Color(0xffFEDC97)),
    ),
  ),
  colorScheme: const ColorScheme.light(background: Color(0xFF162A49)),
  dividerColor: const Color(0xff033F63),
);

final darkTheme = ThemeData(
  useMaterial3: false,
  brightness: Brightness.dark,
  primaryColor: const Color(0xffFEDC97),
  secondaryHeaderColor: const Color(0xffFEDC97),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF162A49),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 40,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: const TextStyle(
      color: Colors.grey,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: const BorderSide(
        color: Color.fromRGBO(126, 132, 138, 1),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: const BorderSide(
        color: Color.fromRGBO(126, 132, 138, 1),
      ),
    ),
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Colors.white,
  ),
  buttonTheme: const ButtonThemeData(
    colorScheme: ColorScheme.dark(
      brightness: Brightness.dark,
      primary: Color(0xFF162A49),
    ),
    textTheme: ButtonTextTheme.normal,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
        textStyle: MaterialStateProperty.all<TextStyle>(
          const TextStyle(
            color: Color(0xFF162A49),
          ),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
          const Color(0xFF162A49),
        )),
  ),
  bottomAppBarTheme: const BottomAppBarTheme(
    color: Color(0xFF162A49),
  ),
  colorScheme: const ColorScheme.dark(
    background: Color(0xFF303030),
  ),
  dividerColor: const Color(0xffFEDC97),
);

final boxDecorationLightTheme = BoxDecoration(
  color: const Color(0xffFEDC97),
  borderRadius: BorderRadius.circular(10),
);

final boxDecorationDarkTheme = BoxDecoration(
  color: const Color(0xFF162A49),
  borderRadius: BorderRadius.circular(10),
);

const progressBarCheckedLightTheme = Color(0xFF28666E);
const progressBarCheckedDarkTheme = Color(0xFF033F63);

final progressBarUncheckedLightTheme = Colors.grey[300];
final progressBarUncheckedDarkTheme = Colors.grey[600];

const checkBoxMenuButtonColorLightTheme = Color(0xff7C9885);
const checkBoxMenuButtonColorDarkTheme = Color(0xFFFEDC97);

const containerDialogTextColorDarkTheme = Color(0xFF033F63);
