import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/components/drop_down_menu.dart';
import 'package:risu/components/outlined_button.dart';
import 'package:risu/utils/theme.dart';

import 'theme_settings_page.dart';

class ThemeSettingsPageState extends State<ThemeSettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        curveColor: context.select((ThemeProvider themeProvider) =>
            themeProvider.currentTheme.secondaryHeaderColor),
        showBackButton: true,
        showLogo: true,
        showBurgerMenu: false,
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: context.select((ThemeProvider themeProvider) =>
          themeProvider.currentTheme.colorScheme.background),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 51),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 30), // Espace ajouté
                const Text(
                  'Thème', // Texte "Paramètres"
                  style: TextStyle(
                    fontSize: 36, // Taille de la police
                    fontWeight: FontWeight.bold, // Gras
                    color: Color(0xFF4682B4),
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 20),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MyDropdownButton(
                            key: Key('drop_down'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                MyOutlinedButton(
                  key: const Key('settings-button_change_information'),
                  onPressed: () {
                    print(context);
                  },
                  text: "Modification d'information",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
