import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:risu/network/informations.dart';
import 'package:risu/pages/home/home_functional.dart';

void goToLoginPage(BuildContext context) {
  logout = true;
  userInformation = null;
  context.go('/login');
}
