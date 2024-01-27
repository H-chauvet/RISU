import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:risu/components/alert_dialog.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/components/parameter.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/contact/contact_page.dart';
import 'package:risu/pages/login/login_page.dart';
import 'package:risu/pages/opinion/opinion_page.dart';
import 'package:risu/pages/profile/informations/informations_page.dart';
import 'package:risu/pages/settings/settings_pages/notifications/notifications_page.dart';
import 'package:risu/pages/settings/settings_pages/theme/theme_settings_page.dart';
import 'package:risu/utils/errors.dart';
import 'package:risu/utils/theme.dart';

import 'settings_page.dart';

class SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  Future<bool> apiDeleteAccount() async {
    try {
      final token = userInformation!.token;
      final userId = userInformation!.ID;
      final response = await http.delete(
        Uri.parse('http://$serverIp:8080/api/user/$userId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        if (context.mounted) {
          printServerResponse(context, response, 'apiDeleteAccount',
              message:
                  "Une erreur est survenue lors de la suppression du compte");
        }
      }
    } catch (err, stacktrace) {
      if (context.mounted) {
        printCatchError(context, err, stacktrace,
            message:
                "Une erreur est survenue lors de la suppression du compte.");
      }
      return false;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        curveColor: context.select(
          (ThemeProvider themeProvider) =>
              themeProvider.currentTheme.secondaryHeaderColor,
        ),
        showBackButton: true,
        showLogo: true,
        showBurgerMenu: false,
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: context.select((ThemeProvider themeProvider) =>
          themeProvider.currentTheme.colorScheme.background),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Text(
                'Paramètres',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: context.select((ThemeProvider themeProvider) =>
                      themeProvider.currentTheme.primaryColor),
                ),
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Mon compte',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const MyParameter(
                goToPage: ProfileInformationsPage(),
                title: 'Voir les détails du profil',
                paramIcon: Icon(Icons.person),
              ),
              const SizedBox(height: 8),
              const MyParameter(
                goToPage: LoginPage(),
                title: 'Informations de paiement',
                paramIcon: Icon(Icons.payments_outlined),
                locked: true,
              ),
              const SizedBox(height: 8),
              const MyParameter(
                goToPage: NotificationsPage(),
                title: 'Notifications',
                paramIcon: Icon(Icons.notifications),
                locked: false,
              ),
              const SizedBox(height: 8),
              const MyParameter(
                goToPage: ThemeSettingsPage(),
                title: 'Thème',
                paramIcon: Icon(Icons.brush),
              ),
              const SizedBox(height: 24),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Assistance',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const MyParameter(
                goToPage: OpinionPage(),
                title: 'Avis',
                paramIcon: Icon(Icons.star),
              ),
              const SizedBox(height: 8),
              const MyParameter(
                goToPage: ContactPage(),
                title: 'Nous contacter',
                paramIcon: Icon(Icons.message_outlined),
              ),
              const SizedBox(height: 8),
              const MyParameter(
                goToPage: LoginPage(),
                title: 'A propos',
                paramIcon: Icon(Icons.question_mark),
                locked: true,
              ),
              const SizedBox(height: 16, key: Key("settings-sized_box-bottom")),
              TextButton(
                key: const Key('settings-textbutton_delete-account'),
                onPressed: () {
                  MyAlertDialog.showChoiceAlertDialog(
                    context: context,
                    title: "Confirmation",
                    message: "Voulez-vous vraiment supprimer votre compte ?",
                    onOkName: "Supprimer",
                  ).then((value) {
                    if (value) {
                      apiDeleteAccount().then((response) => {
                            if (response)
                              {
                                MyAlertDialog.showInfoAlertDialog(
                                  context: context,
                                  title: "Compte supprimé",
                                  message: "Votre compte a bien été supprimé.",
                                ).then(
                                  (x) {
                                    userInformation = null;
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return const LoginPage();
                                        },
                                      ),
                                      (route) => false,
                                    );
                                  },
                                )
                              }
                          });
                    }
                  });
                },
                child: const Text(
                  'Supprimer mon compte',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
