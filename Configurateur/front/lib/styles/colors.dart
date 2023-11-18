import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xff4682B4),
  secondaryHeaderColor: const Color(0xff4682B4),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xff4682B4),
  ),
  bottomAppBarTheme: const BottomAppBarTheme(
    color: Color(0xff4682B4),
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Colors.black,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    labelStyle: TextStyle(
      color: Colors.grey,
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black,
      ),
    ),
  ),
  buttonTheme: const ButtonThemeData(
    colorScheme: ColorScheme.light(
      brightness: Brightness.light,
      primary: Color(0xFF4682B4),
    ),
    textTheme: ButtonTextTheme.normal,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(const Color(0xff4682B4)),
  )),
  colorScheme: const ColorScheme.light(
    background: Color.fromARGB(255, 255, 255, 255),
  ),
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color(0xFF4682B4),
  secondaryHeaderColor: const Color(0xFF4682B4),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 32, 75, 110),
  ),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: const TextStyle(
      color: Colors.grey,
    ),
    /*focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.white70,
      ),
    ),*/
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
      primary: Color.fromARGB(255, 190, 189, 189),
    ),
    textTheme: ButtonTextTheme.normal,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(
        const Color.fromARGB(255, 190, 189, 189)),
  )),
  bottomAppBarTheme: const BottomAppBarTheme(
    color: Color.fromARGB(255, 32, 75, 110),
  ),
  colorScheme: const ColorScheme.dark(
    background: Color(0xFF1E1E1E),
  ),
);
