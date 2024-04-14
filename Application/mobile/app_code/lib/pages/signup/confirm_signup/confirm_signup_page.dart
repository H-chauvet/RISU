import 'package:flutter/material.dart';

import 'confirm_signup_state.dart';

class ConfirmSignupPage extends StatefulWidget {
  const ConfirmSignupPage({
    super.key,
  });

  static const String routeName = '/signup/confirm';

  @override
  State<ConfirmSignupPage> createState() => ConfirmSignupState();
}
