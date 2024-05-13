import 'package:flutter/material.dart';
import 'package:front/components/footer.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/themes.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Page d'accueil de l'application.
class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => LandingPageState();
}

/// État de la page d'accueil.
class LandingPageState extends State<LandingPage> {
  String connectedButton = '';
  Function() connectedFunction = () {};
  String inscriptionButton = '';
  Function() inscriptionFunction = () {};
  String adminButton = '';
  Function() adminFunction = () {};
  String profileButton = '';
  Function() profileFunction = () {};
  String? token = '';
  String? userMail = '';

  /// Vérifie le token lors de l'initialisation de la page.
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
    profileFunction = () => context.go("/profile");
    adminButton = "Administration";
    adminFunction = () => context.go("/admin");
    profileButton = 'Mon profil';
    checkToken();
  }

  /// Construit la liste de boutons en fonction de si l'utilisateur est connecté ou pas.
  List<Widget> buttons() {
    List<Widget> list = [];

    if (token != '') {
      list.add(
        ElevatedButton(
          onPressed: profileFunction,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          child: Text(
            profileButton,
            style: TextStyle(
              color: Provider.of<ThemeService>(context).isDark
                  ? darkTheme.primaryColor
                  : lightTheme.primaryColor,
            ),
          ),
        ),
      );

      list.add(const SizedBox(width: 20));

      if (userMail == "risu.admin@gmail.com") {
        list.add(
          ElevatedButton(
            onPressed: adminFunction,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            child: Text(
              adminButton,
              style: TextStyle(
                color: Provider.of<ThemeService>(context).isDark
                    ? darkTheme.primaryColor
                    : lightTheme.primaryColor,
              ),
            ),
          ),
        );
      }
    } else if (token != '' && userMail != "risu.admin@gmail.com") {
      list.add(
        ElevatedButton(
          onPressed: () => context.go("/my-container"),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          child: Text(
            'Mes conteneurs',
            style: TextStyle(
              color: Provider.of<ThemeService>(context).isDark
                  ? darkTheme.primaryColor
                  : lightTheme.primaryColor,
            ),
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  20.0), // Définit le rayon du bouton arrondi
            ),
          ),
          child: Text(
            connectedButton,
            style: TextStyle(
              color: Provider.of<ThemeService>(context).isDark
                  ? darkTheme.primaryColor
                  : lightTheme.primaryColor,
            ),
          ),
        ),
      );
      list.add(const SizedBox(width: 20));
    }

    list.add(
      ElevatedButton(
        onPressed: inscriptionFunction,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                20.0), // Définit le rayon du bouton arrondi
          ),
        ),
        child: Text(
          inscriptionButton,
          style: TextStyle(
            color: Provider.of<ThemeService>(context).isDark
                ? darkTheme.primaryColor
                : lightTheme.primaryColor,
          ),
        ),
      ),
    );

    return list;
  }

  /// Navigue vers la création d'un conteneur ou d'inscription.
  void goToCreation() async {
    if (await storageService.readStorage('token') == '') {
      context.go("/login");
    } else {
      context.go("/container-creation/shape");
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
              width: 128,
              height: 128,
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
              child: Text(
                'Accueil',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Provider.of<ThemeService>(context).isDark
                      ? darkTheme.secondaryHeaderColor
                      : lightTheme.secondaryHeaderColor,
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
              child: Text(
                'En savoir plus...',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Provider.of<ThemeService>(context).isDark
                      ? darkTheme.secondaryHeaderColor
                      : lightTheme.secondaryHeaderColor,
                ),
              ),
            ),
            const SizedBox(width: 250),
            Row(
              children: [
                Text(
                  "Mode sombre",
                  style: TextStyle(
                    fontSize: 14,
                    color: Provider.of<ThemeService>(context).isDark
                        ? darkTheme.secondaryHeaderColor
                        : lightTheme.secondaryHeaderColor,
                  ),
                ),
                const SizedBox(width: 5),
                Switch(
                    value: Provider.of<ThemeService>(context).isDark,
                    activeColor: lightElevatedButtonBackground,
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
                  Text(
                    'Trouvez des locations selon vos \rbesoins, où vous les souhaitez',
                    style: TextStyle(
                      fontSize: 40,
                      color: Provider.of<ThemeService>(context).isDark
                          ? darkTheme.secondaryHeaderColor
                          : const Color(0xFF28666E),
                      fontWeight: FontWeight.bold,
                      shadows: const [
                        Shadow(
                          color: Color.fromARGB(76, 0, 0, 0),
                          offset: Offset(2, 2),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 15), // Espacement inférieur pour le texte
                    child: Text(
                      'Des conteneurs disponibles partout en france !',
                      style: TextStyle(
                        fontSize: 20,
                        color: Provider.of<ThemeService>(context).isDark
                            ? darkTheme.secondaryHeaderColor
                            : const Color(0xFF28666E),
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
                            textStyle: TextStyle(
                                // fontSize: 13.0
                                )),
                        child: Text(
                          'En savoir plus',
                          style: TextStyle(
                            color: Provider.of<ThemeService>(context).isDark
                                ? darkTheme.primaryColor
                                : lightTheme.primaryColor,
                          ),
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
                        child: Text(
                          'Créer mon conteneur',
                          style: TextStyle(
                            color: Provider.of<ThemeService>(context).isDark
                                ? darkTheme.primaryColor
                                : lightTheme.primaryColor,
                          ),
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
