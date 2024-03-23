// ignore_for_file: use_build_context_synchronously, use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:footer/footer_view.dart';
import 'package:footer/footer.dart';
import 'package:front/components/custom_footer.dart';
import 'package:front/components/custom_header.dart';
import 'package:front/services/storage_service.dart';
import 'package:go_router/go_router.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage> {
  Function() disconnectFunction = () {};
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
      body: FooterView(
          footer: Footer(
            child: CustomFooter(context: context),
          ),
          children: [
            Column(
              children: [
                LandingAppBar(context: context),
                
                const Text(
                  'Louer du matériel quand vous en avez envie\n en toute simplicité grâce à RISU !',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 35,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    color: Color(0xfff033F63),
                    shadows: [
                      Shadow(
                        color: Color(0xff28666e),
                        offset: Offset(0.75, 0.75),
                        blurRadius: 1.5,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 100),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                      child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Trouvez des locations selon vos \rbesoins, où vous les souhaitez',
                              style: TextStyle(
                                fontSize: 35,
                                color: Color(0xff033f63),
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Color(0xff28666e),
                                    offset: Offset(0.75, 0.75),
                                    blurRadius: 1.5,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 15), // Espacement inférieur pour le texte
                              child: Text(
                                'Des conteneurs disponibles partout en france !',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xfff033f63),
                                ),
                              ),
                            ),
                          ]),
                      const SizedBox(width: 100),
                      Image.asset(
                        'assets/iphonenew.png',
                      ),
                    ],
                  )),
                ),
                const SizedBox(height: 50),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                      child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/containerrisu.png',
                      ),
                      const SizedBox(width: 100),
                      const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Concevez des le conteneur de vos rêves,\nselon vos envies !',
                              style: TextStyle(
                                fontSize: 35,
                                color: Color(0xff033f63),
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Color(0xff28666e),
                                    offset: Offset(0.75, 0.75),
                                    blurRadius: 1.5,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 15), // Espacement inférieur pour le texte
                              child: Text(
                                'Grâce à notre configurateur innovant,\nvotre conteneur sera à la hauteur de vos attentes',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xfff033f63),
                                ),
                              ),
                            ),
                          ]
                      ),
                    ],
                  )),
                ),
              ],
            ),
          ]),
    );
  }
}
