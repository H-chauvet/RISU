import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:risu/components/alert_dialog.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/components/filled_button.dart';
import 'package:risu/components/loader.dart';
import 'package:risu/components/toast.dart';
import 'package:risu/globals.dart';
import 'package:risu/utils/errors.dart';
import 'package:risu/utils/theme.dart';
import 'package:risu/utils/user_data.dart';
import 'package:risu/utils/validators.dart';

import 'informations_page.dart';

class ProfileInformationsPageState extends State<ProfileInformationsPage> {
  String newFirstName = '';
  String newLastName = '';
  String newEmail = '';
  final TextEditingController currentPasswordController =
      TextEditingController(text: "");
  final TextEditingController newPasswordController =
      TextEditingController(text: "");
  final TextEditingController newPasswordConfirmationController =
      TextEditingController(text: "");
  final LoaderManager _loaderManager = LoaderManager();

  @override
  void initState() {
    super.initState();
    fetchUserData(context);
  }

  @override
  void dispose() {
    super.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    newPasswordConfirmationController.dispose();
  }

  Future<void> fetchUserData(BuildContext context) async {
    try {
      setState(() {
        _loaderManager.setIsLoading(true);
      });
      final token = userInformation!.token;
      final response = await ioClient.get(
          Uri.parse('$serverIp/api/user/${userInformation!.ID}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          });
      setState(() {
        _loaderManager.setIsLoading(false);
      });
      if (response.statusCode == 200) {
        final userData = json.decode(response.body)['user'];
        final String? userToken = userInformation!.token;
        userInformation = UserData.fromJson(userData, userToken!);
        newFirstName = '';
        newLastName = '';
        newEmail = '';
      } else {
        if (context.mounted) {
          printServerResponse(context, response, 'fetchUserData');
        }
      }
    } catch (err, stacktrace) {
      if (context.mounted) {
        setState(() {
          _loaderManager.setIsLoading(false);
        });
        printCatchError(context, err, stacktrace);
        return;
      }
    }
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
        if (Validators().email(context, newEmail) != null) {
          if (context.mounted) {
            await MyAlertDialog.showErrorAlertDialog(
              context: context,
              title: 'Mise à jour impossible',
              message: 'Veuillez entrer un email valide.',
            );
          }
          return;
        }
        body['email'] = newEmail;
      }
      setState(() {
        _loaderManager.setIsLoading(true);
      });
      final response = await http.put(
        Uri.parse('$serverIp/api/user'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );
      setState(() {
        _loaderManager.setIsLoading(false);
      });
      if (response.statusCode == 200) {
        json.decode(response.body);
        if (context.mounted) {
          await fetchUserData(context);
        }
        if (context.mounted) {
          MyToastMessage.show(
            context: context,
            message: "Informations mises à jour.",
          );
        }
      } else {
        if (context.mounted) {
          printServerResponse(context, response, 'updateUser',
              message:
                  "Impossible de mettre à jour les informations de l'utilisateur.");
        }
      }
    } catch (err, stacktrace) {
      if (context.mounted) {
        setState(() {
          _loaderManager.setIsLoading(false);
        });
        printCatchError(context, err, stacktrace,
            message:
                "Une erreur est survenue lors de la mise à jour des informations de l'utilisateur.");
        return;
      }
    }
  }

  Future<void> updatePassword(
      String currentPassword, String newPassword) async {
    try {
      final newPasswordConfirmation = newPasswordConfirmationController.text;
      if (currentPassword == '' ||
          newPassword == '' ||
          newPasswordConfirmation == '') {
        if (context.mounted) {
          await MyAlertDialog.showErrorAlertDialog(
            context: context,
            title: "Mise à jour impossible",
            message: "Veuillez remplir tous les champs.",
          );
        }
        return;
      }
      if (newPassword != newPasswordConfirmation) {
        if (context.mounted) {
          await MyAlertDialog.showErrorAlertDialog(
            context: context,
            title: "Mise à jour impossible",
            message: "Les mots de passe ne correspondent pas.",
          );
        }
        return;
      }

      final token = userInformation!.token;
      setState(() {
        _loaderManager.setIsLoading(true);
      });
      final response = await http.put(
        Uri.parse('$serverIp/api/user/password'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }),
      );
      setState(() {
        _loaderManager.setIsLoading(false);
      });
      if (response.statusCode == 200) {
        json.decode(response.body);
        currentPasswordController.clear();
        newPasswordController.clear();
        newPasswordConfirmationController.clear();
        if (context.mounted) {
          MyToastMessage.show(
            context: context,
            message: "Le mot de passe a été mis à jour.",
          );
        }
      } else {
        if (response.statusCode == 401) {
          if (context.mounted) {
            printServerResponse(context, response, 'updatePassword',
                message: "Le mot de passe actuel est incorrect.");
          }
        } else {
          if (context.mounted) {
            printServerResponse(context, response, 'updatePassword',
                message: 'Impossible de mettre à jour le mot de passe.');
          }
        }
      }
    } catch (err, stacktrace) {
      if (context.mounted) {
        setState(() {
          _loaderManager.setIsLoading(false);
        });
        printCatchError(context, err, stacktrace,
            message:
                "Une erreur est survenue lors de la mise à jour du mot de passe.");
        return;
      }
    }
  }

  Widget buildField(String label,
      {Key? key,
      String? initialValue,
      Function(String)? onChanged,
      TextEditingController? controller,
      bool isPassword = false}) {
    return TextFormField(
      key: key,
      initialValue: initialValue,
      onChanged: onChanged,
      obscureText: isPassword,
      controller: controller,
      style: TextStyle(
        color: context.select((ThemeProvider themeProvider) =>
            themeProvider.currentTheme.inputDecorationTheme.labelStyle!.color),
        fontWeight: FontWeight.normal,
        fontSize: 16.0,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: context.select((ThemeProvider themeProvider) => themeProvider
              .currentTheme.inputDecorationTheme.labelStyle!.color),
          fontSize: 16.0,
        ),
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black)),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: context.select((ThemeProvider themeProvider) =>
                    themeProvider.currentTheme.primaryColor))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        curveColor: context.select((ThemeProvider themeProvider) =>
            themeProvider.currentTheme.secondaryHeaderColor),
        showBackButton: true,
        showLogo: true,
        showBurgerMenu: false,
        onBackButtonPressed: () {
          Navigator.pop(context, true);
        },
      ),
      backgroundColor: context.select((ThemeProvider themeProvider) =>
          themeProvider.currentTheme.colorScheme.background),
      body: (_loaderManager.getIsLoading())
          ? Center(child: _loaderManager.getLoader())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 32, bottom: 16),
                child: Center(
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Mes informations',
                          key: Key('profile_info-text_informations'),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      buildField(
                        "Prénom",
                        key: const Key('profile_info-text_field_firstname'),
                        initialValue: userInformation!.firstName ?? '',
                        onChanged: (value) {
                          setState(() => newFirstName = value);
                        },
                      ),
                      buildField(
                        "Nom",
                        key: const Key('profile_info-text_field_lastname'),
                        initialValue: userInformation!.lastName ?? '',
                        onChanged: (value) {
                          setState(() => newLastName = value);
                        },
                      ),
                      buildField(
                        "Email",
                        key: const Key('profile_info-text_field_email'),
                        initialValue: userInformation!.email,
                        onChanged: (value) {
                          setState(() => newEmail = value);
                        },
                      ),
                      const SizedBox(height: 16),
                      MyButton(
                        key: const Key('profile_info-button_update'),
                        text: "Enregistrer les modifications",
                        onPressed: () async {
                          await updateUser();
                        },
                      ),
                      const SizedBox(height: 16),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Mot de passe',
                          key: Key('profile_info-text_password'),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      buildField(
                        "Actuel",
                        key: const Key(
                            'profile_info-text_field_current_password'),
                        isPassword: true,
                        controller: currentPasswordController,
                      ),
                      buildField(
                        "Nouveau",
                        key: const Key('profile_info-text_field_new_password'),
                        isPassword: true,
                        controller: newPasswordController,
                      ),
                      buildField(
                        "Confirmation du nouveau",
                        key: const Key(
                            'profile_info-text_field_new_password_confirmation'),
                        isPassword: true,
                        controller: newPasswordConfirmationController,
                      ),
                      const SizedBox(height: 16),
                      MyButton(
                        key: const Key('profile_info-button_update_password'),
                        text: "Enregistrer le nouveau mot de passe",
                        onPressed: () async {
                          await updatePassword(currentPasswordController.text,
                              newPasswordController.text);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
