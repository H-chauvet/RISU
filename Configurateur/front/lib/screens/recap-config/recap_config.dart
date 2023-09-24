import 'package:flutter/material.dart';

class RecapConfigPage extends StatelessWidget {
  const RecapConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(70, 130, 180, 1),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0), // Espacement à gauche du logo
              child: Image.asset(
                'logo.png',
                width: 150,
                height: 150,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceAround, // Espace entre les éléments texte
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.white, // Couleur du texte
                  ),
                  onPressed: () {
                    // Actions à effectuer lors du clic sur le texte
                  },
                  child: const Text('Accueil'),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.white, // Couleur du texte
                  ),
                  onPressed: () {
                    // Actions à effectuer lors du clic sur le texte
                  },
                  child: const Text('Créer un conteneur'),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.white, // Couleur du texte
                  ),
                  onPressed: () {
                    // Actions à effectuer lors du clic sur le texte
                  },
                  child: const Text('Nos offres'),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.white, // Couleur du texte
                  ),
                  onPressed: () {
                    // Actions à effectuer lors du clic sur le texte
                  },
                  child: const Text('Nous contacter'),
                ),
              ],
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Actions à effectuer lorsque le bouton "Mon profil" est pressé
                  },
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 190, 189, 189),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: const Text('Mon profil',
                      style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 16.0), // Espacement entre les boutons
                ElevatedButton(
                  onPressed: () {
                    // Actions à effectuer lorsque le bouton "Déconnexion" est pressé
                  },
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 190, 189, 189),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: const Text('Déconnexion',
                      style: TextStyle(color: Color.fromRGBO(143, 47, 47, 1))),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 800,
              height: 450,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromRGBO(70, 130, 180, 1),
                  width: 4.0,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Récapitulatif de commande',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(70, 130, 180, 1),
                      ),
                    ),
                    SizedBox(height: 50),
                    Text(
                      'Nom du produit:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(70, 130, 180, 1),
                      ),
                    ),
                    Text(
                      'Conteneur classique',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Options:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(70, 130, 180, 1),
                      ),
                    ),
                    Text(
                      'Flocage(Oui) - Logo(Oui) - Couleur personnalisée(Non)',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Taille:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(70, 130, 180, 1),
                      ),
                    ),
                    Text(
                      '8m x 4.50m x 2.50m',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Prix:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(70, 130, 180, 1),
                      ),
                    ),
                    Text(
                      '6500.00 €',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 10,
              left: 20,
              child: Image.asset(
                'container.png',
                width: 125,
                height: 125,
              ),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              child: ElevatedButton(
                onPressed: () {
                  // Actions à effectuer lorsque le bouton "Retour" est pressé
                },
                style: ElevatedButton.styleFrom(
                  primary: const Color.fromARGB(255, 190, 189, 189),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: const Text(
                  'Retour',
                  style: TextStyle(
                      color: Color.fromRGBO(70, 130, 180, 1), fontSize: 18),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: ElevatedButton(
                onPressed: () {
                  // Actions à effectuer lorsque le bouton "Payer" est pressé
                },
                style: ElevatedButton.styleFrom(
                  primary: const Color.fromARGB(255, 190, 189, 189),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: const Text(
                  'Payer',
                  style: TextStyle(
                      color: Color.fromRGBO(70, 130, 180, 1), fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromRGBO(70, 130, 180, 1),
        child: Container(
          height: 45.0, // Hauteur de la barre de navigation
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  // Action à effectuer lors de la sélection de Politique de confidentialité
                },
                child: const Text(
                  'Politique de confidentialité',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white, // Couleur de texte de votre choix
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Action à effectuer lors de la sélection de Conditions générales d'utilisation
                },
                child: const Text(
                  'Conditions générales d\'utilisation',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white, // Couleur de texte de votre choix
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Action à effectuer lors de la sélection de Contact
                },
                child: const Text(
                  'Contact',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white, // Couleur de texte de votre choix
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
