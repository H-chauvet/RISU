import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risu/utils/providers/theme.dart';

/// A custom divider that can be used to separate widgets.
/// It uses the current theme's divider color.
/// params:
///  [vertical] - The vertical padding of the divider.
///  [horizontal] - The horizontal padding of the divider.
///  [key] - The key to use for the divider.
class MyDivider extends StatelessWidget {
  final double vertical;
  final double horizontal;

  const MyDivider({
    super.key,
    this.vertical = 0.0,
    this.horizontal = 0.0,
  });

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
