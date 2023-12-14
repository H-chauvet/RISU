import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/theme.dart';

class MyDivider extends StatelessWidget {
  final double vertical;
  final double horizontal;

  const MyDivider({
    Key? key,
    this.vertical = 0.0,
    this.horizontal = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal),
      child: Divider(
          color: context.select((ThemeProvider themeProvider) =>
              themeProvider.currentTheme.dividerColor)),
    );
  }
}
