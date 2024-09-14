import 'package:flutter/material.dart';

import 'ask_reset_password_state.dart';

/// Page to ask the user to reset the password.
/// The user will receive an email with a link to reset the password.
/// params:
/// [email] - email of the user
class AskResetPasswordPage extends StatefulWidget {
  final String? email;

  const AskResetPasswordPage({
    super.key,
    this.email,
  });

  @override
  State<AskResetPasswordPage> createState() => AskResetPasswordPageState();
}
