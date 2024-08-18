// ignore_for_file: unrelated_type_equality_checks, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/themes.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// [StatefulWidget] : CustomFooter
///
/// Footer for the web pages
class CustomFooter extends StatefulWidget {
  const CustomFooter({super.key});

  @override
  State<CustomFooter> createState() => CustomFooterState();
}

/// CustomFooterState
///
class CustomFooterState extends State<CustomFooter> {
  String? token = '';
  String? userMail = '';
  bool isHoveringContact = false;
  bool isHoveringFeedback = false;
  bool isHoveringFaq = false;
  bool isHoveringCompany = false;
  bool isHoveringContactUs = false;
  bool isHoveringProfil = false;
  bool isHoveringContainers = false;
  bool isHoveringCreateContainers = false;

  /// [Function] : Check in storage service is the token is available
  void checkToken() async {
    token = await storageService.readStorage('token');
    storageService.getUserMail().then((value) => userMail = value);
    setState(() {});
  }

  /// [Function] : Check in storage service is the token is available
  /// Change the path of page if you are connected or not
  void goToCreation() async {
    if (await storageService.readStorage('token') == '') {
      context.go("/login");
    } else {
      context.go("/container-creation/");
    }
  }

  @override
  void initState() {
    super.initState();
    checkToken();
  }

  /// [Widget] : build Footer Component
  @override
  Widget build(BuildContext context) {
    return Footer(
      backgroundColor: const Color(0xffFEDC97),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Communauté",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          const SizedBox(height: 6),
                          MouseRegion(
                            onEnter: (_) {
                              setState(() {
                                isHoveringContact = true;
                              });
                            },
                            onExit: (_) {
                              setState(() {
                                isHoveringContact = false;
                              });
                            },
                            child: GestureDetector(
                              onTap: () {
                                context.go('/contact');
                              },
                              child: Text(
                                "Nous contacter",
                                style: TextStyle(
                                  decoration: isHoveringContact
                                      ? TextDecoration.underline
                                      : TextDecoration.none,
                                ),
                              ),
                            ),
                          ),
                          MouseRegion(
                            onEnter: (_) {
                              setState(() {
                                isHoveringFeedback = true;
                              });
                            },
                            onExit: (_) {
                              setState(() {
                                isHoveringFeedback = false;
                              });
                            },
                            child: GestureDetector(
                              onTap: () {
                                context.go('/feedbacks');
                              },
                              child: Text(
                                "Vos avis",
                                style: TextStyle(
                                  decoration: isHoveringFeedback
                                      ? TextDecoration.underline
                                      : TextDecoration.none,
                                ),
                              ),
                            ),
                          ),
                          MouseRegion(
                            onEnter: (_) {
                              setState(() {
                                isHoveringFaq = true;
                              });
                            },
                            onExit: (_) {
                              setState(() {
                                isHoveringFaq = false;
                              });
                            },
                            child: GestureDetector(
                              onTap: () {
                                context.go('/faq');
                              },
                              child: Text(
                                "Questions fréquentes",
                                style: TextStyle(
                                  decoration: isHoveringFaq
                                      ? TextDecoration.underline
                                      : TextDecoration.none,
                                ),
                              ),
                            ),
                          ),
                          MouseRegion(
                            onEnter: (_) {
                              setState(() {
                                isHoveringCompany = true;
                              });
                            },
                            onExit: (_) {
                              setState(() {
                                isHoveringCompany = false;
                              });
                            },
                            child: GestureDetector(
                              onTap: () {
                                context.go('/company');
                              },
                              child: Text(
                                "L'entreprise Risu",
                                style: TextStyle(
                                  decoration: isHoveringCompany
                                      ? TextDecoration.underline
                                      : TextDecoration.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 100),
                      Image.asset(
                        'assets/logo.png',
                        height: 100,
                      ),
                      const SizedBox(width: 100),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Mon Compte",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          const SizedBox(height: 6),
                          MouseRegion(
                            onEnter: (_) {
                              setState(() {
                                isHoveringProfil = true;
                              });
                            },
                            onExit: (_) {
                              setState(() {
                                isHoveringProfil = false;
                              });
                            },
                            child: GestureDetector(
                              onTap: () {
                                context.go('/profil');
                              },
                              child: Text(
                                "Mon Profil",
                                style: TextStyle(
                                  decoration: isHoveringProfil
                                      ? TextDecoration.underline
                                      : TextDecoration.none,
                                ),
                              ),
                            ),
                          ),
                          MouseRegion(
                            onEnter: (_) {
                              setState(() {
                                isHoveringContainers = true;
                              });
                            },
                            onExit: (_) {
                              setState(() {
                                isHoveringContainers = false;
                              });
                            },
                            child: GestureDetector(
                              onTap: () {
                                context.go('/company-profil');
                              },
                              child: Text(
                                "Mes conteneurs",
                                style: TextStyle(
                                  decoration: isHoveringContainers
                                      ? TextDecoration.underline
                                      : TextDecoration.none,
                                ),
                              ),
                            ),
                          ),
                          MouseRegion(
                            onEnter: (_) {
                              setState(() {
                                isHoveringCreateContainers = true;
                              });
                            },
                            onExit: (_) {
                              setState(() {
                                isHoveringCreateContainers = false;
                              });
                            },
                            child: GestureDetector(
                              onTap: () {
                                context.go('/container-creation/shape');
                              },
                              child: Text(
                                "Créer un conteneur",
                                style: TextStyle(
                                  decoration: isHoveringCreateContainers
                                      ? TextDecoration.underline
                                      : TextDecoration.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Text(
            'Copyright ©2024, Tous droits réservés.',
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 12.0,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Développé par RISU',
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }
}
