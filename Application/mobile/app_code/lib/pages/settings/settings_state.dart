import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risu/components/parameter.dart';
import 'package:risu/pages/contact/contact_page.dart';
import 'package:risu/pages/login/login_page.dart';
import 'package:risu/pages/profile/informations/informations_page.dart';
import 'package:risu/pages/settings/settings_pages/theme/theme_settings_page.dart';
import 'package:risu/utils/theme.dart';
import 'package:risu/pages/opinion/opinion_page.dart';

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
          child: Column(
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
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Mon compte',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16),
              MyParameter(
                goToPage: ProfileInformationsPage(),
                title: 'Voir les détails du profil',
                paramIcon: Icon(Icons.person),
              ),
              SizedBox(height: 8),
              MyParameter(
                goToPage: LoginPage(),
                title: 'Informations de paiement',
                paramIcon: Icon(Icons.payments_outlined),
                locked: true,
              ),
              SizedBox(height: 8),
              MyParameter(
                goToPage: LoginPage(),
                title: 'Notifications',
                paramIcon: Icon(Icons.notifications),
                locked: true,
              ),
              SizedBox(height: 8),
              MyParameter(
                goToPage: ThemeSettingsPage(),
                title: 'Thème',
                paramIcon: Icon(Icons.brush),
              ),
              SizedBox(height: 24),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Assistance',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16),
              MyParameter(
                goToPage: OpinionPage(),
                title: 'Avis',
                paramIcon: Icon(Icons.star),
              ),
              SizedBox(height: 8),
              MyParameter(
                goToPage: ContactPage(),
                title: 'Nous contacter',
                paramIcon: Icon(Icons.message_outlined),
              ),
              SizedBox(height: 8),
              MyParameter(
                goToPage: LoginPage(),
                title: 'A propos',
                paramIcon: Icon(Icons.question_mark),
                locked: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
