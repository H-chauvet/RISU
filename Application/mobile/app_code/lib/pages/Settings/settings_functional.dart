import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Function pointer needed to update the Home Page
Function? updatePage;

/// local variable telling if we wanted to logout
bool logout = false;

/// Navigation function -> Go to Home page
void goToSettingsPage(BuildContext context) {
  if (updatePage != null) {
    updatePage!();
  }
  context.go('/settings');
}
