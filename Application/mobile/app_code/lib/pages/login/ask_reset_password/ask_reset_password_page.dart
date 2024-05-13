import 'package:flutter/material.dart';

import 'ask_reset_password_state.dart';

class AskResetPasswordPage extends StatefulWidget {
  final String? email;

  const AskResetPasswordPage({
    super.key,
    this.email,
  });

  @override
  State<AskResetPasswordPage> createState() => AskResetPasswordPageState();
}
