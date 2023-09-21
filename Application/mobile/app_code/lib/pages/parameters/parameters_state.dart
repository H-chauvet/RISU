import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'parameters_functional.dart';
import 'parameters_page.dart';

class ParametersPageState extends State<ParametersPage> {
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
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                    const SizedBox(
                      width: 20,
                    ), // Espacement entre le chevron et le logo

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
                const SizedBox(height: 30), // Espace ajouté
                const Text(
                  'Paramètres', // Texte "Paramètres"
                  style: TextStyle(
                    fontSize: 36, // Taille de la police
                    fontWeight: FontWeight.bold, // Gras
                    color: Color(0xFF4682B4),
                  ),
                ),
                const SizedBox(height: 30), // Espace ajouté

                buildButtonGroup([
                  buildButton('Compte', route: '/parameters/compte'),
                  buildButton('Confidentialité',
                      route: '/parameters/confidentialite'),
                  buildButton('Sécurité', route: '/parameters/securite'),
                ], 'Compte'),

                // Encadré pour les boutons Notifications et Avis
                buildButtonGroup([
                  buildButton('Notifications',
                      route: '/parameters/notifications'),
                  buildButton('Avis', route: '/parameters/avis'),
                ], 'Notifications'),

                // Encadré pour les boutons Accessibilité, Langue et À propos
                buildButtonGroup([
                  buildButton('Accessibilité',
                      route: '/parameters/accessibilite'),
                  buildButton('Langue', route: '/parameters/langue'),
                  buildButton('À propos', route: '/parameters/add_card'),
                ], 'Divers'),

                const SizedBox(height: 20),
                buildButton('Déconnexion',
                    isLogoutButton: true, route: '/logout'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Fonction pour créer un groupe de boutons avec un encadré
  Widget buildButtonGroup(List<Widget> buttons, String groupText) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4682B4).withOpacity(0.8),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            groupText,
            style: const TextStyle(
              fontSize: 12, // Taille de la police pour le texte du groupe
              fontWeight: FontWeight.bold, // Gras
              decoration: TextDecoration.underline,
              color: Color(0xFF4682B4),
            ),
          ),
          const SizedBox(height: 10),
          // Espace ajouté entre le texte et les boutons
          ...buttons,
        ],
      ),
    );
  }

  Widget buildButton(
    String text, {
    double fontSize = 18,
    double width = double.infinity,
    bool isLogoutButton = false,
    String route = '',
  }) {
    final specColor = isLogoutButton ? Colors.red : const Color(0xFF4682B4);
    return Container(
      width: width,
      child: ElevatedButton(
        onPressed: () {
          if (route.isNotEmpty) {
            context.go(route);
          }
        },
        style: ElevatedButton.styleFrom(
          shadowColor: Colors.black,
          primary: Colors.white,
          onPrimary: specColor,
          side: BorderSide(color: specColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(text, style: TextStyle(fontSize: fontSize)),
      ),
    );
  }
}
