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
  const CustomFooter({super.key, required BuildContext context});

  @override
  State<CustomFooter> createState() => CustomFooterState();
}

/// CustomFooterState
///
class CustomFooterState extends State<CustomFooter> {
  String? token = '';
  String? userMail = '';

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
                        color: Provider.of<ThemeService>(context).isDark
                            ? darkTheme.primaryColor
                            : lightTheme.primaryColor,
                        onPressed: () {
                          context.go("/contact");
                        },
                      ),
                    ),
                  ),
                ),
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
                        color: Provider.of<ThemeService>(context).isDark
                            ? darkTheme.primaryColor
                            : lightTheme.primaryColor,
                        onPressed: () {},
                      ),
                    ),
                  ),
                ),
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
                        color: Provider.of<ThemeService>(context).isDark
                            ? darkTheme.primaryColor
                            : lightTheme.primaryColor,
                        onPressed: () {
                          context.go("/feedbacks");
                        },
                      ),
                    ),
                  ),
                ),
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
                color: Color(0xff033f63)),
          ),
        ],
      ),
    );
  }
}
