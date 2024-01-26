import 'package:flutter/material.dart';
import 'package:risu/utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeChangeModalContent extends StatelessWidget {
  const ThemeChangeModalContent();

  Future<String> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> items = ['Clair', 'Sombre'];
    return items[prefs.getBool('isDarkTheme') == true ? 1 : 0];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(
          onPressed: () async {
            final String currentTheme = await getTheme();
            if (currentTheme != 'Clair') {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            }
            Navigator.of(context).pop();
          },
          child: Text('Clair'),
        ),
        TextButton(
          onPressed: () async {
            final String currentTheme = await getTheme();
            if (currentTheme != 'Sombre') {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            }
            Navigator.of(context).pop();
          },
          child: Text('Sombre'),
        ),
        // Add more options as needed
      ],
    );
  }
}