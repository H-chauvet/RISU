import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/theme.dart';

class MyOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double sizeCoefficient;

  const MyOutlinedButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.sizeCoefficient = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        side: BorderSide(
          color: context.select((ThemeProvider themeProvider) =>
              themeProvider.currentTheme.buttonTheme.colorScheme!.secondary),
          width: 2.0,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 32.0 * sizeCoefficient,
          vertical: 16.0 * sizeCoefficient,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: context.select((ThemeProvider themeProvider) =>
              themeProvider.currentTheme.secondaryHeaderColor),
          fontWeight: FontWeight.bold,
          fontSize: 16.0 * sizeCoefficient,
        ),
      ),
    );
  }
}
