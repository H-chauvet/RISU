import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:profile_photo/profile_photo.dart';
import 'package:provider/provider.dart';
import 'package:risu/components/divider.dart';
import 'package:risu/components/outlined_button.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/contact/contact_page.dart';
import 'package:risu/pages/profile/informations/informations_page.dart';
import 'package:risu/pages/settings/settings_page.dart';
import 'package:risu/utils/theme.dart';
import 'package:risu/pages/article/rent_page.dart';

import '../../components/alert_dialog.dart';
import '../login/login_page.dart';
import 'profile_page.dart';

class ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  Widget toComplete() {
    if (userInformation!.lastName == null ||
        userInformation!.firstName == null) {
      return Padding(
        padding: const EdgeInsets.only(left: 20, top: 20),
        child: MyOutlinedButton(
          key: const Key('profile-button-complete_button'),
          text: 'A compléter',
          sizeCoefficient: 0.8,
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
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    String email = userInformation!.email;
    var splitEmail = email.split("@");
    var hiddenEmail = email.replaceRange(
        2, splitEmail[0].length, "*" * (splitEmail[0].length - 2));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: context.select((ThemeProvider themeProvider) =>
          themeProvider.currentTheme.colorScheme.background),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(children: [
                Padding(
                    padding: const EdgeInsets.only(right: 30, top: 20),
                    child: ProfilePhoto(
                      key: const Key('profile-profile_photo-user_photo'),
                      totalWidth: 56,
                      cornerRadius: 80,
                      color: Colors.blue,
                      image: const AssetImage('assets/avatar-rond.png'),
                    )),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        "${userInformation!.firstName ?? "Prénom"} ${userInformation!.lastName ?? "Nom"}",
                        style: const TextStyle(
                          fontSize: 22,
                        ),
                      ),
                    ),
                    Text(
                      hiddenEmail,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                toComplete()
              ]),
              const MyDivider(vertical: 16.0, horizontal: 16.0),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Historique de location (10 plus récents)",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                child: SizedBox(
                  height: 100.0,
                  child: ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    itemBuilder: (BuildContext context, int index) =>
                        const Card(
                      child: Center(child: Text('Historique')),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                child: SizedBox(
                  width: double.infinity,
                  child: MyOutlinedButton(
                    key: const Key('profile-button-settings_button'),
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
              ),
              const MyDivider(vertical: 16.0, horizontal: 16.0),
              SizedBox(
                width: double.infinity,
                child: MyOutlinedButton(
                  key: const Key('profile-button-log_out_button'),
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
            ],
          ),
        ),
      ),
    );
  }
}

/**Future<bool> apiDeleteAccount() async {
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
    Widget ToDelete(BuildContext context) {
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
    }**/
