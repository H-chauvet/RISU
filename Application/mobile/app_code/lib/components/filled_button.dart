import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risu/utils/providers/theme.dart';

class MyButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double sizeCoefficient;

  const MyButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.sizeCoefficient = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        backgroundColor: context.select((ThemeProvider themeProvider) =>
            themeProvider.currentTheme.primaryColor),
        padding: EdgeInsets.symmetric(
          horizontal: 32.0 * sizeCoefficient,
          vertical: 16.0 * sizeCoefficient,
        ),
        elevation: 0,
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
