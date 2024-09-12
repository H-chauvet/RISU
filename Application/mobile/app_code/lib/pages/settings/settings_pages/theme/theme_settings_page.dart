import 'package:flutter/material.dart';
import 'package:risu/utils/providers/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Theme settings page.
/// This page is used to display the theme settings.
class ThemeChangeModalContent extends StatefulWidget {
  const ThemeChangeModalContent({
    super.key,
  });

  @override
  ThemeChangeModalContentState createState() => ThemeChangeModalContentState();
}

/// The state of the theme change modal content.
/// This class is used to manage the state of the theme change modal content.
class ThemeChangeModalContentState extends State<ThemeChangeModalContent> {
  String selectedTheme = '';

  /// The list of themes available in the application.
  /// This list contains the themes available in the application.
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

  /// Check if the system is in dark mode.
  /// This function is used to check if the system is in dark mode.
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
          title: Text(AppLocalizations.of(context)!.light),
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
          title: Text(AppLocalizations.of(context)!.dark),
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
          title: Text(AppLocalizations.of(context)!.system),
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
