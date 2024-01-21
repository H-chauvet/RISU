import 'package:flutter/material.dart';
import 'package:front/components/footer.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage> {
  String connectedButton = '';
  Function() connectedFunction = () {};
  String inscriptionButton = '';
  Function() inscriptionFunction = () {};
  String adminButton = '';
  Function() adminFunction = () {};
  String? token = '';
  String? userMail = '';

  void checkToken() async {
    token = await storageService.readStorage('token');

    if (token != '') {
      inscriptionButton = 'Déconnexion';
      inscriptionFunction = () {
        storageService.removeStorage('token');
        storageService.removeStorage('tokenExpiration');
        token = '';
        inscriptionButton = 'Inscription';
        inscriptionFunction = () => context.go("/register");
        connectedButton = 'Connexion';
        connectedFunction = () => context.go("/login");
        setState(() {});
      };
    } else {
      inscriptionButton = 'Inscription';
      inscriptionFunction = () => context.go("/register");
      connectedButton = 'Connexion';
      connectedFunction = () => context.go("/login");
    }

    storageService.getUserMail().then((value) => userMail = value);

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    adminButton = "Administration";
    adminFunction = () => context.go("/admin");
    checkToken();
  }

  List<Widget> buttons() {
    List<Widget> list = [];

    if (token != '' && userMail == "risu.admin@gmail.com") {
      list.add(
        ElevatedButton(
          onPressed: adminFunction,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 190, 189, 189),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          child: Text(
            adminButton,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      );
    }

    list.add(const SizedBox(width: 20));

    if (token == '') {
      list.add(
        ElevatedButton(
          onPressed: connectedFunction,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 190, 189, 189),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  20.0), // Définit le rayon du bouton arrondi
            ),
          ),
          child: Text(
            connectedButton,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      );
      list.add(const SizedBox(width: 20));
    }

    list.add(
      ElevatedButton(
        onPressed: inscriptionFunction,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 190, 189, 189),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                20.0), // Définit le rayon du bouton arrondi
          ),
        ),
        child: Text(
          inscriptionButton,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );

    return list;
  }

  void goToCreation() async {
    if (await storageService.readStorage('token') == '') {
      context.go("/login");
    } else {
      context.go("/container-creation");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                context.go("/company");
              },
              child: const Text(
                'En savoir plus...',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(width: 250),
            Row(
              children: [
                const Text(
                  "Mode sombre",
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(width: 5),
                Switch(
                    value: Provider.of<ThemeService>(context).isDark,
                    activeColor: Colors.blue,
                    onChanged: (bool value) {
                      Provider.of<ThemeService>(context, listen: false)
                          .switchTheme();
                      setState(() {});
                    }),
              ],
            ),
            const SizedBox(width: 20),
            Row(
              children: buttons(),
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Center(
            child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Trouvez des locations selon vos \rbesoins, où vous les souhaitez',
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
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Padding(
                      padding: const EdgeInsets.only(top: 35),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                20.0), // Définit le rayon du bouton arrondi
                          ),
                        ),
                        onPressed: () => goToCreation(),
                        child: const Text(
                          'Créer mon conteneur',
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
