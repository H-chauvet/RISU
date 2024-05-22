// ignore_for_file: unrelated_type_equality_checks, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/themes.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// [StatefulWidget] : LandingAppBar
///
/// Header for the web pages
class LandingAppBar extends StatefulWidget {
  const LandingAppBar({super.key, required BuildContext context});

  @override
  State<LandingAppBar> createState() => LandingAppBarState();
}

/// LandingAppBarState
///
class LandingAppBarState extends State<LandingAppBar> {
  String? token = '';
  String? userRole = '';

  /// [Function] : Check in storage service is the token is available
  void checkToken() async {
    token = await storageService.readStorage('token');
    storageService.getUserRole().then((value) => userRole = value);
    setState(() {});
  }

  /// [Function] : Check in storage service is the token is available
  /// Change the path of page if you are connected or not
  void goToCreation() async {
    if (await storageService.readStorage('token') == '') {
      context.go("/login");
    } else {
      context.go("/container-creation/shape");
    }
  }

  @override
  void initState() {
    super.initState();
    checkToken();
  }

  /// [Widget] : Build Header Component
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 100, right: 100),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/logonew.png',
                width: 100,
                height: 100,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        context.go("/");
                      },
                      style: TextButton.styleFrom(
                        foregroundColor:
                            Provider.of<ThemeService>(context).isDark
                                ? darkTheme.secondaryHeaderColor
                                : lightTheme.secondaryHeaderColor,
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text(
                        'Accueil',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const SizedBox(
                      height: 24,
                      child: VerticalDivider(
                        thickness: 2,
                        color: Color.fromARGB(255, 172, 167, 167),
                      ),
                    ),
                    const SizedBox(width: 10),
                    TextButton(
                      onPressed: () {
                        context.go("/company");
                      },
                      style: TextButton.styleFrom(
                        foregroundColor:
                            Provider.of<ThemeService>(context).isDark
                                ? darkTheme.secondaryHeaderColor
                                : lightTheme.secondaryHeaderColor,
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text(
                        'Notre équipe',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const SizedBox(
                      height: 24,
                      child: VerticalDivider(
                        thickness: 2,
                        color: Color.fromARGB(255, 172, 167, 167),
                      ),
                    ),
                    const SizedBox(width: 10),
                    TextButton(
                      onPressed: () => goToCreation(),
                      style: TextButton.styleFrom(
                        foregroundColor:
                            Provider.of<ThemeService>(context).isDark
                                ? darkTheme.secondaryHeaderColor
                                : lightTheme.secondaryHeaderColor,
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text(
                        'Créer un conteneur',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const SizedBox(
                      height: 24,
                      child: VerticalDivider(
                        thickness: 2,
                        color: Color.fromARGB(255, 172, 167, 167),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Mode sombre",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 20,
                        color: Provider.of<ThemeService>(context).isDark
                            ? darkTheme.secondaryHeaderColor
                            : lightTheme.secondaryHeaderColor,
                      ),
                    ),
                    Switch(
                      value: Provider.of<ThemeService>(context).isDark,
                      onChanged: (bool value) {
                        Provider.of<ThemeService>(context, listen: false)
                            .switchTheme();
                        setState(() {});
                      },
                      activeColor: darkTheme.primaryColor,
                      inactiveTrackColor: lightTheme.primaryColor,
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                tooltip: "Authentification",
                icon: Icon(
                  size: 35,
                  Icons.account_circle,
                  color: Provider.of<ThemeService>(context).isDark
                      ? darkTheme.primaryColor
                      : lightTheme.primaryColor,
                ),
                itemBuilder: (BuildContext context) {
                  List<PopupMenuEntry<String>> items = [];
                  if (token == '') {
                    items.addAll(
                      [
                        const PopupMenuItem<String>(
                          value: 'connexion',
                          child: Text(
                            'Connexion',
                            style: TextStyle(
                              color: Color(0xff033F63),
                            ),
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'inscription',
                          child: Text(
                            'Inscription',
                            style: TextStyle(
                              color: Color(0xff033F63),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    items.add(
                      const PopupMenuItem<String>(
                        value: 'profil',
                        child: Text(
                          'Profil',
                          style: TextStyle(
                            color: Color(0xff033F63),
                          ),
                        ),
                      ),
                    );
                    items.add(
                      const PopupMenuItem<String>(
                        value: 'company-profil',
                        child: Text(
                          'Mon Entreprise',
                          style: TextStyle(
                            color: Color(0xff033F63),
                          ),
                        ),
                      ),
                    );
                    if (userRole == "admin") {
                      items.add(
                        const PopupMenuItem<String>(
                          value: 'admin',
                          child: Text(
                            'Administration',
                            style: TextStyle(
                              color: Color(0xff033F63),
                            ),
                          ),
                        ),
                      );
                    }
                    items.add(
                      const PopupMenuItem<String>(
                        value: 'disconnect',
                        child: Text(
                          'Déconnexion',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    );
                  }
                  return items;
                },
                onSelected: (String value) {
                  if (value == 'connexion') {
                    context.go("/login");
                  } else if (value == 'inscription') {
                    context.go("/register");
                  } else if (value == 'admin') {
                    context.go("/admin");
                  } else if (value == 'profil') {
                    context.go("/profil");
                  } else if (value == 'company-profil') {
                    context.go("/company-profil");
                  } else if (value == "disconnect") {
                    storageService.removeStorage('token');
                    storageService.removeStorage('tokenExpiration');
                    token = '';
                    Fluttertoast.showToast(
                      msg: "Vous êtes bien déconnecté !",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                    );
                    context.go("/");
                  }
                },
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 100, right: 100),
          height: 1,
          color: Provider.of<ThemeService>(context).isDark
              ? darkTheme.primaryColor
              : lightTheme.primaryColor,
        ),
        const SizedBox(height: 50),
      ],
    );
  }
}
