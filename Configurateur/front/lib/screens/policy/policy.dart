import 'dart:ui';

import 'package:flutter/material.dart';

class PolicyPage extends StatelessWidget {

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
        body: 
        Container(
          padding: const EdgeInsets.all(20.0),
          child: const Center(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 50.0),
                  child: Text(
                    'Confidentialités',
                    style: TextStyle(
                      fontSize: 30,
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
                Padding(
                  padding: EdgeInsets.only(top: 100.0, left: 180.0, right: 180.0),
                  child: Text(
                    'Eminuit autem inter humilia supergressa iam impotentia fines mediocrium delictorum nefanda Clematii cuiusdam Alexandrini nobilis mors repentina; cuius socrus cum misceri sibi generum, flagrans eius amore, non impetraret, ut ferebatur, per palatii pseudothyrum introducta, oblato pretioso reginae monili id adsecuta est, ut ad Honoratum tum comitem orientis formula missa letali omnino scelere nullo contactus idem Clematius nec hiscere nec loqui permissus occideretur. Quam ob rem cave Catoni anteponas ne istum quidem ipsum, quem Apollo, ut ais, sapientissimum iudicavit; huius enim facta, illius dicta laudantur. De me autem, ut iam cum utroque vestrum loquar, sic habetote. Eminuit autem inter humilia supergressa iam impotentia fines mediocrium delictorum nefanda Clematii cuiusdam Alexandrini nobilis mors repentina; cuius socrus cum misceri sibi generum, flagrans eius amore, non impetraret, ut ferebatur, per palatii pseudothyrum introducta, oblato pretioso reginae monili id adsecuta est, ut ad Honoratum tum comitem orientis formula missa letali omnino scelere nullo contactus idem Clematius nec hiscere nec loqui permissus occideretur.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(255, 0, 0, 0),
                      backgroundColor: Color.fromARGB(255, 181, 181, 181),
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            )
          ),
        ),
    );
  }
}