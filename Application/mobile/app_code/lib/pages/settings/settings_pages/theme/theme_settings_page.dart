import 'package:flutter/material.dart';
import 'package:risu/utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeChangeModalContent extends StatefulWidget {
  const ThemeChangeModalContent({super.key});

  @override
  ThemeChangeModalContentState createState() => ThemeChangeModalContentState();
}

class ThemeChangeModalContentState extends State<ThemeChangeModalContent> {
  String selectedTheme = '';
  Future<String> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> items = [
      appTheme['clair'],
      appTheme['sombre'],
      appTheme['systeme']
    ];

    return prefs.getString('appTheme') ?? items[0];
  }

  @override
  void initState() {
    super.initState();
    getTheme().then((value) {
      setState(() {
        selectedTheme = value;
      });
    });
  }

  Future<bool> isSystemInDarkMode() async {
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RadioListTile<String>(
          key: const Key('button-light'),
          title: const Text('Clair'),
          value: 'Clair',
          groupValue: selectedTheme,
          onChanged: (value) {
            Provider.of<ThemeProvider>(context, listen: false)
                .setTheme(appTheme['clair']);
            setState(() {
              selectedTheme = appTheme['clair'];
            });
          },
        ),
        RadioListTile<String>(
          key: const Key('button-dark'),
          title: const Text('Sombre'),
          value: 'Sombre',
          groupValue: selectedTheme,
          onChanged: (value) {
            Provider.of<ThemeProvider>(context, listen: false)
                .setTheme(appTheme['sombre']);
            setState(() {
              selectedTheme = appTheme['sombre'];
            });
          },
        ),
        RadioListTile<String>(
          key: const Key('button-system'),
          title: const Text('Système'),
          value: 'Système',
          groupValue: selectedTheme,
          onChanged: (value) {
            Provider.of<ThemeProvider>(context, listen: false)
                .setTheme(appTheme['systeme']);
            setState(() {
              selectedTheme = appTheme['systeme'];
            });
          },
        ),
      ],
    );
  }
}
