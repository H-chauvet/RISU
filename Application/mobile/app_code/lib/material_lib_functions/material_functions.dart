import 'package:flutter/material.dart';

/// This function display our logo
Widget displayLogo(double size) {
  return Column(
    children: [Image.asset('assets/logo_noir.png')],
  );
}

Color getOurPrimaryColor(double opacity) {
  return Color.fromRGBO(6, 161, 228, opacity);
}

Color getOurSecondaryColor(double opacity) {
  return Color.fromRGBO(22, 252, 188, opacity);
}
