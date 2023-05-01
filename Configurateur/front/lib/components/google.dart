import 'package:flutter/material.dart';
import 'package:sign_button/sign_button.dart';

class GoogleLogo extends StatelessWidget {
  const GoogleLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SignInButton(
        buttonType: ButtonType.google,
        onPressed: () {
          debugPrint('click');
        });
  }
}
