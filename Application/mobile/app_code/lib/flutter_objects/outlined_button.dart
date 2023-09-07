import 'package:flutter/material.dart';

import '../utils/colors.dart';

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
        side: const BorderSide(
          color: MyColors.buttonBackground,
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
          color: MyColors.buttonText,
          fontWeight: FontWeight.bold,
          fontSize: 16.0 * sizeCoefficient,
        ),
      ),
    );
  }
}
