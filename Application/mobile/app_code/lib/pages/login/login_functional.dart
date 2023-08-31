import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../network/informations.dart';
import '../home/home_functional.dart';

void goToLoginPage(BuildContext context) {
  logout = true;
  userInformation = null;
  context.go('/login');
}
