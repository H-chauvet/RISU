import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:front/components/alert_dialog.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/components/footer.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/themes.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  void initState() {
    super.initState();
    MyAlertTest.checkSignInStatusAdmin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        'Administration',
        context: context,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          key: const Key('btn-messages'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  20.0), // Définit le rayon du bouton arrondi
                            ),
                          ),
                          onPressed: () {
                            context.go("/admin/messages");
                          },
                          child: Text(
                            'Gestion des messages',
                            style: TextStyle(
                                color: Provider.of<ThemeService>(context).isDark ? darkTheme.primaryColor : lightTheme.primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          "Cet onglet permet d'accéder à la liste\ndes messages envoyés par les utilisateurs",
                          softWrap: true,
                          maxLines: 3,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Container(
                      height: 200,
                      child: const VerticalDivider(
                        thickness: 2,
                        width: 100,
                        color: Colors.black,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          key: const Key('btn-user'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  20.0), // Définit le rayon du bouton arrondi
                            ),
                          ),
                          onPressed: () {
                            context.go("/userList");
                          },
                          child: Text(
                            'Gestion des utilisateurs',
                            style: TextStyle(
                              color: Provider.of<ThemeService>(context).isDark ? darkTheme.primaryColor : lightTheme.primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          "Cet onglet permet d'accéder à la liste\ndes utilisateurs.",
                          softWrap: true,
                          maxLines: 3,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Container(
                      height: 200,
                      child: const VerticalDivider(
                        thickness: 2,
                        width: 100,
                        color: Colors.black,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          key: const Key('btn-article'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  20.0), // Définit le rayon du bouton arrondi
                            ),
                          ),
                          onPressed: () {
                            context.go("/containerList");
                          },
                          child: Text(
                            'Gestion des conteneurs',
                            style: TextStyle(
                                color: Provider.of<ThemeService>(context).isDark ? darkTheme.primaryColor : lightTheme.primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          "Cet onglet permet d'accéder à la liste\ndes articles en service.",
                          softWrap: true,
                          maxLines: 3,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
