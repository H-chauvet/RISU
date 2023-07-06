import 'dart:ui';

import 'package:flutter/material.dart';

class LearnMoreAboutPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
    appBar: AppBar(
        backgroundColor: Color.fromRGBO(70, 130, 180, 1),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'logo.png',
                width: 150, // Largeur de l'image
                height: 150,
              ),
              const SizedBox(width: 250),
              TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered))
                      return Color.fromARGB(255, 199, 199, 199);
                    return const Color.fromARGB(255, 255, 255, 255); // null throus error in flutter 2.2+.
                    }
                  ),
                ),
                onPressed: () {
                  // Actions à effectuer lors du clic sur le texte
                },
                child: const Text(
                  'Accueil',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                  // backgroundColor: 
                ),
              ),
              const SizedBox(width: 100),
              TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered))
                      return Color.fromARGB(255, 199, 199, 199);
                    return const Color.fromARGB(255, 255, 255, 255); // null throus error in flutter 2.2+.
                    }
                  ),
                ),
                onPressed: () {
                  // Actions à effectuer lors du clic sur le texte
                },
                child: const Text(
                  'En savoir plus...',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(width: 250),
              ElevatedButton(
                onPressed: () {
                  // Actions to perform when the button is pressed
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 190, 189, 189),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0), // Définit le rayon du bouton arrondi
                    ),
                  ),
                child: const Text('Connexion'),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  // Actions to perform when the button is pressed
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 190, 189, 189),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0), // Définit le rayon du bouton arrondi
                    ),
                  ),
                child: const Text('Inscription'),
              ),
            ],
          ),
        ),
        body:  Column(
          children: [
            Center( 
              child: Padding(
                padding: EdgeInsets.only(top: 60.0),
                child: Container(
                  color: Color.fromARGB(255, 255, 255, 255),
                  child: const Text(
                    'Qu’est ce que Risu ?',
                    style: TextStyle(
                      fontSize: 35,
                      color: Color.fromRGBO(70, 130, 180, 1),
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: const Color.fromARGB(76, 0, 0, 0),
                          offset: Offset(2, 2),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 80.0),
                child: Container(
                  width: 700,
                  height: 300,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 243, 243, 243),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(top: 30.0, left: 100.0, right: 100.0, bottom: 30.0),
                    child: Text(
                      "Risu est une appli qui permet la location de materiel de plage. L’entreprise a été créer en 2022 avec l’aide de 6 personnes. Le premier casier risu a vu le jour le XX/XX/XXXX",
                    ),
                  ),
                ),
              ),
            )
          ],
        )
    );
  }
}