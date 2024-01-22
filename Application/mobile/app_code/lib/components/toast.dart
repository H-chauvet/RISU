import 'package:flutter/material.dart';

class MyToastMessage {
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show(
      {required String message, required BuildContext context}) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
