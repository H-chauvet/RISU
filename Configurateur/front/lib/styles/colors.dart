import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xFF4682B4),
  secondaryHeaderColor: const Color(0xFF4682B4),
  colorScheme: const ColorScheme.light(
    background: Color.fromARGB(255, 255, 255, 255),
  ),
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color(0xFF4682B4),
  secondaryHeaderColor: const Color(0xFF4682B4),
  colorScheme: const ColorScheme.dark(
    background: Color(0xFF1E1E1E),
  ),
);
