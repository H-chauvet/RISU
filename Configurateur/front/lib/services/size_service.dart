import 'package:flutter/material.dart';

enum ScreenFormat { desktop, tablet }

class SizeService {
  ScreenFormat getScreenFormat(context) {
    var width = MediaQuery.of(context).size.width;

    if (width >= 1025) {
      return ScreenFormat.desktop;
    } else {
      return ScreenFormat.tablet;
    }
  }
}
