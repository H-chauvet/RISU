import 'package:flutter/material.dart';

import 'reset_password_state.dart';

class ResetPasswordPage extends StatefulWidget {
  final String token;

  const ResetPasswordPage({
    super.key,
    required this.token,
  });

  @override
  State<ResetPasswordPage> createState() => ResetPasswordPageState();
}
