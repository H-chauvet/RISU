import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:risu/components/alert_dialog.dart';
import 'package:risu/globals.dart';
import 'package:risu/utils/theme.dart';
import 'package:risu/utils/user_data.dart';

import 'informations_page.dart';

String firstName = '';
String lastName = '';
String email = '';
String newFirstName = '';
String newLastName = '';
String newEmail = '';

Future<void> fetchUserData() async {
  try {
    final token = userInformation!.token;
    final response = await http.get(
        Uri.parse('http://$serverIp:8080/api/user/${userInformation!.ID}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        });
    if (response.statusCode == 200) {
      final userData = json.decode(response.body);
      firstName = userData['firstName'];
      lastName = userData['lastName'];
      email = userData['email'];
      UserData.fromJson(userData['user'], userData['token']);
    } else {
      print('Error: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetchUserData() : $e');
  }
}

class ProfileInformationsPageState extends State<ProfileInformationsPage> {
  Future<void> updateUser() async {
    try {
      final token = userInformation!.token;

      print('token : $token');
      // Add newFirstName, newLastName, newEmail if not null
      Map<String, dynamic> body = {};
      if (newFirstName != '') {
        body['firstName'] = newFirstName;
      }
      if (newLastName != '') {
        body['lastName'] = newLastName;
      }
      if (newEmail != '') {
        body['email'] = newEmail;
      }

      final response = await http.put(
        Uri.parse('http://$serverIp:8080/api/user'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final updatedData = json.decode(response.body);
        print('Mise à jour réussie: $updatedData');
        await fetchUserData();
        if (context.mounted) {
          await MyAlertDialog.showInfoAlertDialog(
              context: context,
              title: 'Mise à jour réussie',
              message: 'Informations mises à jour.');
        }
      } else {
        print('Erreur: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Erreur updateUser() : $e');
    }
  }

  Future<void> updatePassword(
      String currentPassword, String newPassword) async {
    try {
      final token = userInformation!.token;
      print('currentPassword : $currentPassword');
      print('newPassword : $newPassword');

      final response = await http.put(
        Uri.parse('http://$serverIp:8080/api/user/password'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': '$token',
        },
        body: jsonEncode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        final updatedData = json.decode(response.body);
        print('Mise à jour réussie: $updatedData');
        if (context.mounted) {
          await MyAlertDialog.showInfoAlertDialog(
              context: context,
              title: 'Mise à jour réussie',
              message: 'Le mot de passe a été mis à jour');
        }
      } else {
        if (response.statusCode == 401) {
          if (context.mounted) {
            await MyAlertDialog.showInfoAlertDialog(
                context: context,
                title: 'Mise à jour refusée',
                message: 'Le mot de passe actuel est incorrect');
          }
        } else {
          if (context.mounted) {
            await MyAlertDialog.showErrorAlertDialog(
                context: context,
                title: 'Impossible de mettre à jour le mot de passe',
                message: 'Erreur inconnue');
          }
        }
        print('Erreur: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur updatePassword() : $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    String currentPassword = '';
    String newPassword = '';
    String newPasswordConfirmation = '';

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: context.select((ThemeProvider themeProvider) =>
          themeProvider.currentTheme.colorScheme.background),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Chevron bleu pour la navigation vers /home
                    GestureDetector(
                      child: const Icon(
                        Icons.chevron_left,
                        color: Colors.blue, // Couleur du chevron
                        size: 30.0, // Taille du chevron
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Logo RISU
                    Expanded(
                      child: Center(
                        child: Image.asset(
                          'assets/logo_noir.png',
                          width: 200,
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
                // Prénom
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Champ texte désactivé pour le prénom actuel
                          Expanded(
                            child: TextFormField(
                              enabled: false,
                              // Désactivez le champ texte
                              initialValue: firstName,
                              // Utilisez la valeur actuelle comme valeur initiale
                              decoration: const InputDecoration(
                                  labelText: 'Prénom actuel'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              key:
                                  const Key('profile_info-text_field-new_name'),
                              decoration: const InputDecoration(
                                  labelText: 'Nouveau prénom'),
                              onChanged: (value) {
                                newFirstName = value;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),

                // Nom
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Champ texte désactivé pour le nom actuel
                          Expanded(
                            child: TextFormField(
                              enabled: false,
                              // Désactivez le champ texte
                              initialValue: lastName,
                              // Utilisez la valeur actuelle comme valeur initiale
                              decoration: const InputDecoration(
                                  labelText: 'Nom actuel'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              key: const Key(
                                  'profile_info-text_field-last_name'),
                              decoration: const InputDecoration(
                                  labelText: 'Nouveau nom'),
                              onChanged: (value) {
                                newLastName = value;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),

                // Email
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Champ texte désactivé pour l'email actuel
                          Expanded(
                            child: TextFormField(
                              enabled: false,
                              // Désactivez le champ texte
                              initialValue: email,
                              // Utilisez la valeur actuelle comme valeur initiale
                              decoration: const InputDecoration(
                                  labelText: 'Email actuel'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              key: const Key('profile_info-text_field-email'),
                              decoration: const InputDecoration(
                                  labelText: 'Nouvel email'),
                              onChanged: (value) {
                                newEmail = value;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      OutlinedButton(
                        key: const Key('informations-button_update_user'),
                        onPressed: () {
                          if (newFirstName == '' &&
                              newLastName == '' &&
                              newEmail == '') {
                            MyAlertDialog.showErrorAlertDialog(
                                key: const Key(
                                    'informations-alert_dialog_error'),
                                context: context,
                                title: 'Erreur',
                                message:
                                    'Veuillez renseigner au moins un champ.');
                            return;
                          }
                          updateUser();
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                          side: BorderSide(
                            color: context.select(
                                (ThemeProvider themeProvider) => themeProvider
                                    .currentTheme.secondaryHeaderColor),
                            width: 3.0,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 48.0,
                            vertical: 16.0,
                          ),
                        ),
                        child: Text(
                          'Appliquer les changements',
                          style: TextStyle(
                            color: context.select(
                                (ThemeProvider themeProvider) => themeProvider
                                    .currentTheme.secondaryHeaderColor),
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Mot de passe
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  child: Column(
                    children: [
                      // Mot de passe actuel
                      TextFormField(
                        key: const Key('profile_info-text_field-curr_password'),
                        decoration: const InputDecoration(
                            labelText: 'Mot de passe actuel'),
                        onChanged: (value) {
                          currentPassword = value;
                        },
                        obscureText: true,
                      ),
                      const SizedBox(height: 10), // Ajout d'un espace vertical
                      // Nouveau mot de passe
                      TextField(
                        key: const Key('profile_info-text_field-new_password'),
                        decoration: const InputDecoration(
                            labelText: 'Nouveau mot de passe'),
                        onChanged: (value) {
                          newPassword = value;
                        },
                        obscureText: true,
                      ),
                      const SizedBox(height: 10), // Ajout d'un espace vertical
                      // Confirmation du nouveau mot de passe
                      TextField(
                        key: const Key(
                            'profile_info-text_field-new_password_conf'),
                        decoration: const InputDecoration(
                            labelText: 'Confirmation du nouveau mot de passe'),
                        onChanged: (value) {
                          newPasswordConfirmation = value;
                        },
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      OutlinedButton(
                        key: const Key('profile_info-button-update_password'),
                        onPressed: () async {
                          if (currentPassword.isEmpty ||
                              newPassword.isEmpty ||
                              newPasswordConfirmation.isEmpty) {
                            await MyAlertDialog.showInfoAlertDialog(
                                key: const Key(
                                    'profile_info-alert_dialog-no_password'),
                                context: context,
                                title:
                                    'Impossible de mettre à jour le mot de passe',
                                message: 'Veuillez remplir tous les champs');
                            return;
                          }
                          if (newPassword == newPasswordConfirmation) {
                            updatePassword(currentPassword, newPassword);
                          } else {
                            await MyAlertDialog.showInfoAlertDialog(
                                key: const Key(
                                    'profile_info-alert_dialog-diff_password'),
                                context: context,
                                title: 'Les mots de passe ne correspondent pas',
                                message:
                                    'Veuillez choisir le même mot de passe pour le mot de passe et la confirmation du mot de passe');
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                          side: BorderSide(
                            color: context.select(
                                (ThemeProvider themeProvider) => themeProvider
                                    .currentTheme.secondaryHeaderColor),
                            width: 3.0,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 48.0,
                            vertical: 16.0,
                          ),
                        ),
                        child: Text(
                          'Mettre à jour le mot de passe',
                          style: TextStyle(
                            color: context.select(
                                (ThemeProvider themeProvider) => themeProvider
                                    .currentTheme.secondaryHeaderColor),
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

/**Widget buildButton(
    String text, {
    double fontSize = 18,
    double width = double.infinity,
    bool isLogoutButton = false,
    String route = '',
    }) {
    final textColor = isLogoutButton ? Colors.black : const Color(0xFF4682B4);

    return Container(
    margin: const EdgeInsets.symmetric(vertical: 10),
    width: width,
    child: ElevatedButton(
    onPressed: () {
    if (route.isNotEmpty) {
    context.go(route);
    }
    },
    style: ElevatedButton.styleFrom(
    primary: Colors.white,
    onPrimary: textColor,
    side: const BorderSide(color: Color(0xFF4682B4)),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(30),
    ),
    ),
    child: Text(text, style: TextStyle(fontSize: fontSize)),
    ),
    );
    }**/
}
