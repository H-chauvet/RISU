import 'package:flutter/material.dart';

import 'login_state.dart';

class LoginPage extends StatefulWidget {
  final bool? keepPath;

  const LoginPage({
    super.key,
    this.keepPath,
  });

  static const String routeName = '/login';

  @override
  State<LoginPage> createState() => LoginPageState();
}
