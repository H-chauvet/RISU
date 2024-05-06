import 'package:flutter/material.dart';

import 'reset_password_state.dart';

class ResetPasswordPage extends StatefulWidget {
  final String? email;

  const ResetPasswordPage({
    super.key,
    this.email,
  });

  @override
  State<ResetPasswordPage> createState() => ResetPasswordPageState();
}
