// ignore_for_file: unrelated_type_equality_checks, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import 'package:front/services/storage_service.dart';
import 'package:go_router/go_router.dart';

class CustomFooter extends StatefulWidget {
  const CustomFooter({super.key, required BuildContext context});

  @override
  State<CustomFooter> createState() => CustomFooterState();
}

class CustomFooterState extends State<CustomFooter> {
  String? token = '';
  String? userMail = '';

  void checkToken() async {
    token = await storageService.readStorage('token');
    storageService.getUserMail().then((value) => userMail = value);
    setState(() {});
  }

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

  @override
  Widget build(BuildContext context) {
    return Footer(
      backgroundColor: const Color(0xffFEDC97),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                    height: 45.0,
                    width: 45.0,
                    child: Center(
                      child: Card(
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              25.0), // half of height and width of Image
                        ),
                        child: IconButton(
                          tooltip: "Page de contact",
                          icon: const Icon(
                            Icons.contact_page,
                            size: 20.0,
                          ),
                          color: const Color(0xFF162A49),
                          onPressed: () {
                            context.go("/contact");
                          },
                        ),
                      ),
                    )),
                SizedBox(
                    height: 45.0,
                    width: 45.0,
                    child: Center(
                      child: Card(
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              25.0), // half of height and width of Image
                        ),
                        child: IconButton(
                          tooltip: "Développé par RISU",
                          icon: const Icon(
                            Icons.fingerprint,
                            size: 20.0,
                          ),
                          color: const Color(0xFF162A49),
                          onPressed: () {},
                        ),
                      ),
                    )),
                SizedBox(
                    height: 45.0,
                    width: 45.0,
                    child: Center(
                      child: Card(
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              25.0), // half of height and width of Image
                        ),
                        child: IconButton(
                          tooltip: "Page des avis",
                          icon: const Icon(
                            Icons.stars,
                            size: 20.0,
                          ),
                          color: const Color(0xff033f63),
                          onPressed: () {
                            context.go("/feedbacks");
                          },
                        ),
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Copyright ©2024, Tous droits réservés.',
            style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 12.0,
                color: Color(0xff033f63)),
          ),
          const SizedBox(height: 10),
          const Text(
            'Développé par RISU',
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 12.0,
              color: Color(0xff033f63)
            ),
          ),
        ]
      ),
    );
  }
}
