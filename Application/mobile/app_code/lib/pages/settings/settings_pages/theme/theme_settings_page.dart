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

  Future<bool> isSystemInDarkMode() async {
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark;
  }

  void switchToDarkMode(BuildContext context) async {
    bool isDarkMode = await getTheme() == 'Sombre';
    if (!isDarkMode) {
      Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
    }
  }

  void switchToLightMode(BuildContext context) async {
    bool isDarkMode = await getTheme() == 'Sombre';
    if (isDarkMode) {
      Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FutureBuilder<String>(
          future: getTheme(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return RadioListTile<String>(
                key: const Key('button-light'),
                title: const Text('Clair'),
                value: 'Clair',
                groupValue: snapshot.data,
                onChanged: (value) async {
                  if (value != snapshot.data) {
                    Provider.of<ThemeProvider>(context, listen: false)
                        .toggleTheme();
                  }
                  Navigator.of(context).pop();
                },
              );
            } else {
              return Container();
            }
          },
        ),
        FutureBuilder<String>(
          future: getTheme(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return RadioListTile<String>(
                key: const Key('button-dark'),
                title: const Text('Sombre'),
                value: 'Sombre',
                groupValue: snapshot.data,
                onChanged: (value) async {
                  if (value != snapshot.data) {
                    Provider.of<ThemeProvider>(context, listen: false)
                        .toggleTheme();
                  }
                  Navigator.of(context).pop();
                },
              );
            } else {
              return Container();
            }
          },
        ),
        FutureBuilder<bool>(
          future: isSystemInDarkMode(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return RadioListTile<String>(
                key: const Key('button-system'),
                title: const Text('Système'),
                value: 'Système',
                groupValue: (snapshot.data ?? false) ? 'Sombre' : 'Clair',
                onChanged: (value) async {
                  if (snapshot.data == true) {
                    switchToDarkMode(context);
                  } else {
                    switchToLightMode(context);
                  }
                  Navigator.of(context).pop();
                },
              );
            } else {
              return Container();
            }
          },
        ),
      ],
    );
  }
}
