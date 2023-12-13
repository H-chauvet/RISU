import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:risu/components/outlined_button.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/contact/contact_page.dart';
import 'package:risu/pages/profile/informations/informations_page.dart';
import 'package:risu/pages/settings/settings_page.dart';
import 'package:risu/utils/theme.dart';
import '../../globals.dart';
import 'package:risu/pages/contact/contact_page.dart';
import 'package:risu/pages/article/rent_page.dart';

import '../../components/alert_dialog.dart';
import '../login/login_page.dart';
import 'profile_page.dart';

class ProfilePageState extends State<ProfilePage> {
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
          await MyAlertDialog.showInfoAlertDialog(
              context: context,
              title: 'Suppression de compte',
              message: 'Erreur lors de la suppression du compte.');
        }
      }
    } catch (err) {
      if (context.mounted) {
        await MyAlertDialog.showInfoAlertDialog(
            context: context,
            title: 'Suppression de compte',
            message: 'Erreur lors de la suppresion du compte.');
      }
      return false;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: context.select((ThemeProvider themeProvider) =>
          themeProvider.currentTheme.colorScheme.background),
      body: SingleChildScrollView(
        child: Row(children: [
          Container(
            margin: const EdgeInsets.only(top: 30, left: 20, right: 20),
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: AssetImage('assets/avatar-rond.png'),
                  fit: BoxFit.fill),
            ),
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 40),
                child: Text(
                  'Nom d\'utilisateur',
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
              ),
              Text(
                'E-mail',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }

  @override
  Widget AAA(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: context.select((ThemeProvider themeProvider) =>
          themeProvider.currentTheme.colorScheme.background),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: MyOutlinedButton(
                    text: 'Informations',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const ProfileInformationsPage();
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: MyOutlinedButton(
                    text: 'Paramètres',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const SettingsPage();
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: MyOutlinedButton(
                    text: 'Nous contacter',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const ContactPage();
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: MyOutlinedButton(
                    text: 'Déconnexion',
                    onPressed: () {
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
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  key: const Key('profile-textbutton_delete-account'),
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
                                    message:
                                        "Votre compte a bien été supprimé.",
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
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
