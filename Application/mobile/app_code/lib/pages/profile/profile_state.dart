import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:risu/network/informations.dart';
import 'package:risu/pages/login/login_page.dart';
import 'package:risu/utils/theme.dart';

import 'profile_functional.dart';
import 'profile_page.dart';

class ProfilePageState extends State<ProfilePage> {
  /// Update state function
  void update() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    updatePage = update;
  }

  /// Re sync all flutter object
  void homeSync() async {
    update();
  }

  @override
  Widget build(BuildContext context) {
    if (logout || userInformation == null) {
      userInformation = null;
      return const LoginPage();
    } else {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: context.select((ThemeProvider themeProvider) =>
            themeProvider.currentTheme.colorScheme.background),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Chevron bleu pour la navigation vers /home
                      GestureDetector(
                        onTap: () {
                          // Naviguer vers la route "/home"
                          context.go('/home');
                        },
                        child: const Icon(
                          Icons.chevron_left,
                          color: Colors.blue, // Couleur du chevron
                          size: 30.0, // Taille du chevron
                        ),
                      ),
                      const SizedBox(width: 20),
                      // Espacement entre le chevron et le logo

                      // Logo RISU
                      Expanded(
                        child: Center(
                          child: Image.asset(
                            'assets/logo_noir.png',
                            width: 200,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  buildButton('Informations', route: '/profile/informations'),
                  buildButton('Paramètres', route: '/profile/settings'),
                  buildButton('Ajouter une carte', route: '/profile/add_card'),
                  buildButton('Ajouter un RIB / IBAN', route: '/profile/add_rib'),
                  const SizedBox(height: 10),
                  buildButton('Déconnexion',
                      isLogoutButton: true, route: '/logout'),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget buildButton(
    String text, {
    double fontSize = 18,
    double width = double.infinity,
    bool isLogoutButton = false,
    String route = '',
  }) {
    final textColor = isLogoutButton ? Colors.black : const Color(0xFF4682B4);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: width,
      child: ElevatedButton(
        onPressed: () {
          if (route.isNotEmpty) {
            context.go(route);
          }
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          onPrimary: textColor,
          side: const BorderSide(color: Color(0xFF4682B4)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(text, style: TextStyle(fontSize: fontSize)),
      ),
    );
  }
}
