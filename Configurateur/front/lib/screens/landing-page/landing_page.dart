import 'package:flutter/material.dart';
import 'package:front/components/footer.dart';
import 'package:go_router/go_router.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(70, 130, 180, 1),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              width: 150, // Largeur de l'image
              height: 150,
            ),
            const SizedBox(width: 250),
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.hovered)) {
                    return const Color.fromARGB(255, 199, 199, 199);
                  }
                  return const Color.fromARGB(
                      255, 255, 255, 255); // null throus error in flutter 2.2+.
                }),
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
                  if (states.contains(MaterialState.hovered)) {
                    return const Color.fromARGB(255, 199, 199, 199);
                  }
                  return const Color.fromARGB(
                      255, 255, 255, 255); // null throus error in flutter 2.2+.
                }),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      20.0), // Définit le rayon du bouton arrondi
                ),
              ),
              child: const Text(
                'Connexion',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                // Actions to perform when the button is pressed
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 190, 189, 189),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      20.0), // Définit le rayon du bouton arrondi
                ),
              ),
              child: const Text(
                'Inscription',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        // color: Color.fromRGBO(r, g, b, 1), // Espacement des bords de l'écran
        child: Center(
            child: Row(
          mainAxisSize: MainAxisSize.min,
          // mainAxisAlignment: MainAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Trouvez des locations selon vos \rbesoins, où vous les souhaitez',
                    // textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 40,
                      color: Color.fromRGBO(70, 130, 180, 1),
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Color.fromARGB(76, 0, 0, 0),
                          offset: Offset(2, 2),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                        top: 15), // Espacement inférieur pour le texte
                    child: Text(
                      'Des conteneurs disponibles partout en france !',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromRGBO(70, 130, 180, 1),
                      ),
                    ),
                  ),
                  Row(children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 35), // Espacement inférieur pour le texte
                      child: ElevatedButton(
                        onPressed: () {
                          // Actions to perform when the button is pressed
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 190, 189, 189),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  20.0), // Définit le rayon du bouton arrondi
                            ),
                            textStyle: const TextStyle(
                                // fontSize: 13.0,
                                )),
                        child: const Text(
                          'En savoir plus',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Padding(
                      padding: const EdgeInsets.only(top: 35),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 190, 189, 189),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                20.0), // Définit le rayon du bouton arrondi
                          ),
                        ),
                        onPressed: () => context.go("/creation"),
                        child: const Text(
                          'Créer mon conteneur',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    )
                  ]),
                ]),
            Image.asset(
              'assets/iphone.png',
            ),
          ],
        )),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
