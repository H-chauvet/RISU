// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:front/services/storage_service.dart';
import 'package:go_router/go_router.dart';


class LandingAppBar extends StatefulWidget{
  const LandingAppBar({Key? key, required BuildContext context});

  @override
  State<LandingAppBar> createState() => LandingAppBarState();
}

  class LandingAppBarState extends State<LandingAppBar> {
    String? token = '';
    String? userMail = '';

    void checkToken() async {
      token = await storageService.readStorage('token');
      storageService.getUserMail().then((value) => userMail = value);
      setState(() {});
    }

    @override
    void initState() {
      super.initState();
      checkToken();
    }
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
                      'assets/logo.png',
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
                              foregroundColor: Colors.black,
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
                              foregroundColor: Colors.black,
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
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      tooltip: "Authentification",
                      icon: const Icon(
                        size: 35,
                        Icons.account_circle,
                        color: Colors.black,
                      ),
                      itemBuilder: (BuildContext context) {
                        List<PopupMenuEntry<String>> items = [];
                        if (token == '') {
                          items.addAll([
                            const PopupMenuItem<String>(
                              value: 'connexion',
                              child: Text('Connexion'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'inscription',
                              child: Text('Inscription'),
                            ),
                          ]);
                        } else {
                          items.add(
                            const PopupMenuItem<String>(
                              value: 'profil',
                              child: Text('Profil'),
                            ),
                          );
                          if (userMail == "risu.admin@gmail.com") {
                            items.add(
                              const PopupMenuItem<String>(
                                value: 'admin',
                                child: Text('Administration'),
                              ),
                            );
                          }
                          items.add(
                            const PopupMenuItem<String>(
                              value: 'disconnect',
                              child: Text(
                                'Déconnexion',
                                style:TextStyle(
                                  color: Colors.red,
                                )
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
                        } else if (value == "disconnect") {
                          storageService.removeStorage('token');
                          storageService.removeStorage('tokenExpiration');
                          token = '';
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
                color: const Color.fromARGB(255, 172, 167, 167),
              ),
              const SizedBox(height: 50),
            ],
          );
    }
}
