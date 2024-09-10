import 'package:flutter/material.dart';

import 'login_state.dart';

/// Login page.
/// this is tha page where the user can login to the application.
/// params:
/// [keepPath] if true, the user will be redirected to the page he was trying to access before login.
/// if false, the user will be redirected to the home page.
/// if null, the user will be redirected to the page he was trying to access before login.
/// [key] the key of the widget.
class LoginPage extends StatefulWidget {
  final bool? keepPath;

  const LoginPage({
    super.key,
    this.keepPath,
  });

  @override
  State<LoginPage> createState() => LoginPageState();
}
