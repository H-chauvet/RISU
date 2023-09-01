import 'package:flutter/material.dart';

import '../utils/colors.dart';

class MyButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double sizeCoefficient;

  const MyButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.sizeCoefficient = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        foregroundColor: MyColors.buttonText,
        backgroundColor: MyColors.buttonBackground,
        padding: EdgeInsets.symmetric(
          horizontal: 32.0 * sizeCoefficient,
          vertical: 16.0 * sizeCoefficient,
        ),
        elevation: 0,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: MyColors.buttonText,
          fontWeight: FontWeight.bold,
          fontSize: 16.0 * sizeCoefficient,
        ),
      ),
    );
  }
}
