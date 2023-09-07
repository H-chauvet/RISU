import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(70, 130, 180, 1),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'logo.png',
              width: 150,
              height: 150,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.hovered)) {
                          return const Color.fromARGB(255, 199, 199, 199);
                        }
                        return const Color.fromARGB(255, 255, 255, 255);
                      },
                    ),
                  ),
                  onPressed: () {
                    // Actions à effectuer lors du clic sur le texte
                  },
                  child: const Text('Accueil'),
                ),
                TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.hovered)) {
                          return const Color.fromARGB(255, 199, 199, 199);
                        }
                        return const Color.fromARGB(255, 255, 255, 255);
                      },
                    ),
                  ),
                  onPressed: () {
                    // Actions à effectuer lors du clic sur le texte
                  },
                  child: const Text('Créer un conteneur'),
                ),
                TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.hovered)) {
                          return const Color.fromARGB(255, 199, 199, 199);
                        }
                        return const Color.fromARGB(255, 255, 255, 255);
                      },
                    ),
                  ),
                  onPressed: () {
                    // Actions à effectuer lors du clic sur le texte
                  },
                  child: const Text('Nos offres'),
                ),
                TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.hovered)) {
                          return const Color.fromARGB(255, 199, 199, 199);
                        }
                        return const Color.fromARGB(255, 255, 255, 255);
                      },
                    ),
                  ),
                  onPressed: () {
                    // Actions à effectuer lors du clic sur le texte
                  },
                  child: const Text('Nous contacter'),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                // Actions to perform when the button is pressed
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 190, 189, 189),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: const Text('Déconnexion',
                  style: TextStyle(color: Color.fromRGBO(143, 47, 47, 1))),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Row(
            children: [
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom:
                          660.0), // Ajuster la valeur top pour déplacer les textes vers le haut
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .center, // Centrer l'icône et le texte
                        children: [
                          Text(
                            'Informations personnelles',
                            style: TextStyle(
                              fontSize: 20,
                              color: Color.fromRGBO(70, 130, 180, 1),
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.edit,
                              color: Color.fromARGB(
                                  255, 65, 69, 71)), // Icône de crayon
                        ],
                      ),
                      SizedBox(height: 50), // Ajouter un espace de 10 pixels
                      Text(
                        'Nom : Chauvet',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color.fromRGBO(70, 130, 180, 1),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Prénom : Henri',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color.fromRGBO(70, 130, 180, 1),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'E-Mail : henri.chauvet@epitech.eu',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color.fromRGBO(70, 130, 180, 1),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Mot de passe : ************',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color.fromRGBO(70, 130, 180, 1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 800.0,
                width: 2.0,
                color: Colors.grey,
              ),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom:
                          710.0), // Ajuster la valeur top pour déplacer les textes vers le haut
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .center, // Centrer l'icône et le texte
                        children: [
                          Text(
                            'Informations bancaires',
                            style: TextStyle(
                              fontSize: 20,
                              color: Color.fromRGBO(70, 130, 180, 1),
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.edit,
                              color: Color.fromARGB(
                                  255, 65, 69, 71)), // Icône de crayon
                        ],
                      ),
                      SizedBox(height: 50), // Ajouter un espace de 10 pixels
                      Text(
                        'Type de paiement : Carte Bancaire',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color.fromRGBO(70, 130, 180, 1),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'N° Carte : 5132 **** **** **78',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color.fromRGBO(70, 130, 180, 1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
