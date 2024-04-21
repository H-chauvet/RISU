import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xFF162A49),
  secondaryHeaderColor: const Color(0xFF033F63),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xff4682B4),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 40,
    ),
  ),
  bottomAppBarTheme: const BottomAppBarTheme(
    color: Color(0xff4682B4),
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
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color(0xffFEDC97),
  secondaryHeaderColor: const Color(0xffFEDC97),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 32, 75, 110),
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
    color: Color.fromARGB(255, 32, 75, 110),
  ),
  colorScheme: const ColorScheme.dark(
    background: Color(0xFF1E1E1E),
  ),
);

final boxDecorationLightTheme = BoxDecoration(
  color: const Color(0xffFEDC97),
  borderRadius: BorderRadius.circular(10),
);

final boxDecorationDarkTheme = BoxDecoration(
  color: const Color(0xFF162A49),
  borderRadius: BorderRadius.circular(10),
);

const progressBarCheckedLightTheme = Color(0xFF4682B4);
const progressBarCheckedDarkTheme = Color.fromARGB(255, 33, 91, 138);

final progressBarUncheckedLightTheme = Colors.grey[300];
final progressBarUncheckedDarkTheme = Colors.grey[600];
