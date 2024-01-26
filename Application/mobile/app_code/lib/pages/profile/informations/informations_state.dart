import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:risu/components/alert_dialog.dart';
import 'package:risu/globals.dart';
import 'package:risu/utils/errors.dart';
import 'package:risu/utils/theme.dart';
import 'package:risu/utils/user_data.dart';

import 'informations_page.dart';

String firstName = '';
String lastName = '';
String email = '';
String newFirstName = '';
String newLastName = '';
String newEmail = '';

Future<void> fetchUserData(BuildContext context) async {
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
      newFirstName = '';
      newLastName = '';
      newEmail = '';
    } else {
      print('Error fetchUserData() : ${response.statusCode}');
    }
  } catch (err, stacktrace) {
    printCatchError(context, err, stacktrace);
  }
}

class ProfileInformationsPageState extends State<ProfileInformationsPage> {
  @override
  void initState() {
    super.initState();
    fetchUserData(context);
  }

  Future<void> updateUser() async {
    try {
      final token = userInformation!.token;
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
        await fetchUserData(context);
        if (context.mounted) {
          await MyAlertDialog.showInfoAlertDialog(
            context: context,
            title: 'Mise à jour réussie',
            message: 'Informations mises à jour.',
          );
        }
      } else {
        print('Error updateUser() : ${response.statusCode}');
      }
    } catch (err, stacktrace) {
      printCatchError(context, err, stacktrace,
          message:
              "An error occured when trying to update user's informations.");
    }
  }

  Future<void> updatePassword(
      String currentPassword, String newPassword) async {
    try {
      final token = userInformation!.token;

      final response = await http.put(
        Uri.parse('http://$serverIp:8080/api/user/password'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        final updatedData = json.decode(response.body);
        if (context.mounted) {
          await MyAlertDialog.showInfoAlertDialog(
            context: context,
            title: 'Mise à jour réussie',
            message: 'Le mot de passe a été mis à jour',
          );
        }
      } else {
        if (response.statusCode == 401) {
          printServerResponse(context, response, 'updatePassword',
              message: "Le mot de passe actuel est incorrect.");
        } else {
          printServerResponse(context, response, 'updatePassword',
              message: 'Impossible de mettre à jour le mot de passe.');
        }
      }
    } catch (err, stacktrace) {
      printCatchError(context, err, stacktrace,
          message: "An error occured when trying to update user's password.");
    }
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
                // Prénom
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextFormField(
                              enabled: false,
                              initialValue: firstName,
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
                          Expanded(
                            child: TextFormField(
                              enabled: false,
                              initialValue: lastName,
                              decoration: const InputDecoration(
                                labelText: 'Nom actuel',
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              key: const Key(
                                'profile_info-text_field-last_name',
                              ),
                              decoration: const InputDecoration(
                                labelText: 'Nouveau nom',
                              ),
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
                          Expanded(
                            child: TextFormField(
                              enabled: false,
                              initialValue: email,
                              decoration: const InputDecoration(
                                labelText: 'Email actuel',
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              key: const Key('profile_info-text_field-email'),
                              decoration: const InputDecoration(
                                labelText: 'Nouveau email',
                              ),
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
                                  'informations-alert_dialog_error_no_info'),
                              context: context,
                              title: 'Erreur',
                              message: 'Veuillez renseigner au moins un champ.',
                            );
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
                      const SizedBox(height: 10),
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
                      const SizedBox(height: 10),
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
                            await MyAlertDialog.showErrorAlertDialog(
                              key: const Key(
                                  'profile_info-alert_dialog-no_password'),
                              context: context,
                              title:
                                  'Impossible de mettre à jour le mot de passe',
                              message: 'Veuillez remplir tous les champs',
                            );
                            return;
                          }
                          if (newPassword == newPasswordConfirmation) {
                            updatePassword(currentPassword, newPassword);
                          } else {
                            await MyAlertDialog.showErrorAlertDialog(
                              key: const Key(
                                  'profile_info-alert_dialog-diff_password'),
                              context: context,
                              title: 'Les mots de passe ne correspondent pas',
                              message:
                                  'Veuillez choisir le même mot de passe pour le mot de passe et la confirmation du mot de passe',
                            );
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
}
