import 'package:flutter/material.dart';

import 'login_state.dart';

class LoginPage extends StatefulWidget {
  final bool? keepPath;

  const LoginPage({
    super.key,
    this.keepPath,
  });

  @override
  State<LoginPage> createState() => LoginPageState();
}
