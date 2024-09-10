import 'package:flutter/material.dart';

import 'reset_password_state.dart';

/// Reset password page.
/// this page is used to reset the password.
/// params:
/// [key] - key to identify the widget.
/// [token] - token to reset the password.
class ResetPasswordPage extends StatefulWidget {
  final String token;

  const ResetPasswordPage({
    super.key,
    required this.token,
  });

  @override
  State<ResetPasswordPage> createState() => ResetPasswordPageState();
}
