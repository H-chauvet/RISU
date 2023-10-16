import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Navigation function -> Go to Home page
void goToProfilePage(BuildContext context) {
  context.go('/profile');
}
