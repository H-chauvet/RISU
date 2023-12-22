import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risu/components/parameter.dart';
import 'package:risu/pages/login/login_page.dart';
import 'package:risu/pages/profile/informations/informations_page.dart';
import 'package:risu/utils/theme.dart';

import '../../components/divider.dart';
import 'settings_page.dart';

class SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: context.select((ThemeProvider themeProvider) =>
          themeProvider.currentTheme.colorScheme.background),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: const Column(
            children: [
              SizedBox(height: 8),
              Text(
                'Paramètres',
                style: TextStyle(
                  fontSize: 36, // Taille de la police
                  fontWeight: FontWeight.bold, // Gras
                  color: Color(0xFF4682B4),
                ),
              ),
              SizedBox(height: 20),
              MyParameter(
                goToPage: LoginPage(),
                iconPath: 'assets/user.png',
                title: 'Voir les détails du profil',
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
