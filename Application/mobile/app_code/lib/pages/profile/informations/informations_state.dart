import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:risu/network/informations.dart';
import 'package:risu/pages/login/login_page.dart';
import 'package:risu/utils/theme.dart';
import 'package:risu/components/text_input.dart';
import 'informations_functional.dart';
import 'informations_page.dart';
import 'package:http/http.dart' as http;
import 'package:risu/utils/user_data.dart';
import 'dart:convert';
import 'package:risu/components/alert_dialog.dart';

String firstName = '';
String lastName = '';
String email = '';

Future<void> fetchUserData() async {
  try {
    final token = userInformation!.token;
    final response = await http.get(Uri.parse('http://$serverIp:8080/api/user'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': '$token',
        }
    );
    if (response.statusCode == 200) {
      final userData = json.decode(response.body);
      print('userData : $userData');
      firstName = userData['firstName'];
      lastName = userData['lastName'];
      email = userData['email'];
      print('firstName : $firstName');
      print('lastName : $lastName');
      print('email : $email');
      UserData.fromJson(userData);
    } else {
      print('Error: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetchUserData() : $e');
  }
}

class ProfileInformationsPageState extends State<ProfileInformationsPage> {

  Future<void> updateFirstName(String newFirstName) async {
    try {
      final token = userInformation!.token;

      final response = await http.post(
        Uri.parse('http://$serverIp:8080/api/user/firstName'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': '$token',
        },
        body: jsonEncode({'firstName': newFirstName}),
      );

      if (response.statusCode == 200) {
        final updatedData = json.decode(response.body);
        print('Mise à jour réussie: $updatedData');
        await fetchUserData();
        await MyAlertDialog.showInfoAlertDialog(
            context: context,
            title: 'Mise à jour réussie',
            message: 'Le prénom a été mis à jour');
      } else {
        print('Erreur: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur updateFirstName() : $e');
    }
  }

  Future<void> updateLastName(String newLastName) async {
    try {
      final token = userInformation!.token;

      final response = await http.post(
        Uri.parse('http://$serverIp:8080/api/user/lastName'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': '$token',
        },
        body: jsonEncode({'lastName': newLastName}),
      );

      if (response.statusCode == 200) {
        final updatedData = json.decode(response.body);
        print('Mise à jour réussie: $updatedData');
        await fetchUserData();
        await MyAlertDialog.showInfoAlertDialog(
            context: context,
            title: 'Mise à jour réussie',
            message: 'Le nom a été mis à jour');
      } else {
        print('Erreur: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur updateLastName() : $e');
    }
  }

  Future<void> updateEmail(String newEmail) async {
    try {
      final token = userInformation!.token;
      print('newEmail : $newEmail');

      final response = await http.post(
        Uri.parse('http://$serverIp:8080/api/user/email'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': '$token',
        },
        body: jsonEncode({'email': newEmail}),
      );

      if (response.statusCode == 200) {
        final updatedData = json.decode(response.body);
        print('Mise à jour réussie: $updatedData');
        await fetchUserData();
        await MyAlertDialog.showInfoAlertDialog(
            context: context,
            title: 'Mise à jour réussie',
            message: 'L\'email a été mis à jour');
      } else {
        print('Erreur: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur updateEmail() : $e');
    }
  }

  Future<void> updatePassword(String currentPassword, String newPassword) async {
    try {
      final token = userInformation!.token;
      print('currentPassword : $currentPassword');
      print('newPassword : $newPassword');

      final response = await http.post(
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
        await MyAlertDialog.showInfoAlertDialog(
            context: context,
            title: 'Mise à jour réussie',
            message: 'Le mot de passe a été mis à jour');
      } else {
        if (response.statusCode == 401) {
          await MyAlertDialog.showInfoAlertDialog(
              context: context,
              title: 'Mise à jour refusée',
              message: 'Le mot de passe actuel est incorrect');
        } else {
          await MyAlertDialog.showInfoAlertDialog(
              context: context,
              title: 'Impossible de mettre à jour le mot de passe',
              message: 'Erreur inconnue');
        }
        print('Erreur: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur updatePassword() : $e');
    }
  }

  /// Update state function
  void update() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    updatePage = update;
    fetchUserData();
  }

  /// Re sync all flutter object
  void homeSync() async {
    update();
  }

  @override
  Widget build(BuildContext context) {
    String newFirstName = '';
    String newLastName = '';
    String newEmail = '';

    String currentPassword = '';
    String newPassword = '';
    String newPasswordConfirmation = '';


    if (logout || userInformation == null) {
      userInformation = null;
      return const LoginPage();
    } else {
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
                        onTap: () {
                          // Naviguer vers la route "/home"
                          context.go('/profile');
                        },
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
                                enabled: false, // Désactivez le champ texte
                                initialValue: firstName, // Utilisez la valeur actuelle comme valeur initiale
                                decoration: InputDecoration(labelText: 'Prénom actuel'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(labelText: 'Nouveau prénom'),
                                onChanged: (value) {
                                  newFirstName = value;
                                },
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 20),
                        OutlinedButton(
                          key: const Key('update_firstName-button'),
                          onPressed: () {
                            if (newFirstName.isEmpty) {
                              MyAlertDialog.showInfoAlertDialog(
                                  context: context,
                                  title: 'Impossible de mettre à jour le prénom',
                                  message: 'Veuillez remplir le champ');
                              return;
                            }
                            updateFirstName(newFirstName);
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                            side: BorderSide(
                              color: context.select((ThemeProvider themeProvider) =>
                              themeProvider.currentTheme.secondaryHeaderColor),
                              width: 3.0,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 48.0,
                              vertical: 16.0,
                            ),
                          ),
                          child: Text(
                            'Mettre à jour le prénom',
                            style: TextStyle(
                              color: context.select((ThemeProvider themeProvider) =>
                              themeProvider.currentTheme.secondaryHeaderColor),
                              fontSize: 16.0,
                            ),
                          ),
                        ),
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
                                enabled: false, // Désactivez le champ texte
                                initialValue: lastName, // Utilisez la valeur actuelle comme valeur initiale
                                decoration: InputDecoration(labelText: 'Nom actuel'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(labelText: 'Nouveau nom'),
                                onChanged: (value) {
                                  newLastName = value;
                                },
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 20),
                        OutlinedButton(
                          key: const Key('update_lastName-button'),
                          onPressed: () {
                            if (newLastName.isEmpty) {
                              MyAlertDialog.showInfoAlertDialog(
                                  context: context,
                                  title: 'Impossible de mettre à jour le nom',
                                  message: 'Veuillez remplir le champ');
                              return;
                            }
                            print('newLastName : $newLastName');
                            updateLastName(newLastName);
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                            side: BorderSide(
                              color: context.select((ThemeProvider themeProvider) =>
                              themeProvider.currentTheme.secondaryHeaderColor),
                              width: 3.0,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 48.0,
                              vertical: 16.0,
                            ),
                          ),
                          child: Text(
                            'Mettre à jour le nom',
                            style: TextStyle(
                              color: context.select((ThemeProvider themeProvider) =>
                              themeProvider.currentTheme.secondaryHeaderColor),
                              fontSize: 16.0,
                            ),
                          ),
                        ),
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
                                enabled: false, // Désactivez le champ texte
                                initialValue: email, // Utilisez la valeur actuelle comme valeur initiale
                                decoration: InputDecoration(labelText: 'Email actuel'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(labelText: 'Nouvel email'),
                                onChanged: (value) {
                                  newEmail = value;
                                },
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 20),
                        OutlinedButton(
                          key: const Key('reset-email-button'),
                          onPressed: () {
                            if (newEmail.isEmpty) {
                              MyAlertDialog.showInfoAlertDialog(
                                  context: context,
                                  title: 'Impossible de mettre à jour l\'email',
                                  message: 'Veuillez remplir le champ');
                              return;
                            }
                            print('newEmail : $newEmail');
                            updateEmail(newEmail);
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                            side: BorderSide(
                              color: context.select((ThemeProvider themeProvider) =>
                              themeProvider.currentTheme.secondaryHeaderColor),
                              width: 3.0,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 48.0,
                              vertical: 16.0,
                            ),
                          ),
                          child: Text(
                            'Mettre à jour l\'email',
                            style: TextStyle(
                              color: context.select((ThemeProvider themeProvider) =>
                              themeProvider.currentTheme.secondaryHeaderColor),
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
                          decoration: InputDecoration(labelText: 'Mot de passe actuel'),
                          onChanged: (value) {
                            currentPassword = value;
                          },
                          obscureText: true,
                        ),
                        SizedBox(height: 10), // Ajout d'un espace vertical
                        // Nouveau mot de passe
                        TextField(
                          decoration: InputDecoration(labelText: 'Nouveau mot de passe'),
                          onChanged: (value) {
                            newPassword = value;
                          },
                          obscureText: true,
                        ),
                        SizedBox(height: 10), // Ajout d'un espace vertical
                        // Confirmation du nouveau mot de passe
                        TextField(
                          decoration: InputDecoration(labelText: 'Confirmation du nouveau mot de passe'),
                          onChanged: (value) {
                            newPasswordConfirmation = value;
                          },
                          obscureText: true,
                        ),

                        SizedBox(height: 20),
                        OutlinedButton(
                          key: const Key('update_password-button'),
                          onPressed: () async {
                            print('currentPassword : $currentPassword');
                            print('newPassword : $newPassword');
                            print('newPasswordConfirmation : $newPasswordConfirmation');
                            if (currentPassword.isEmpty || newPassword.isEmpty || newPasswordConfirmation.isEmpty) {
                              await MyAlertDialog.showInfoAlertDialog(
                                  context: context,
                                  title: 'Impossible de mettre à jour le mot de passe',
                                  message: 'Veuillez remplir tous les champs');
                              return;
                            }
                            if (newPassword == newPasswordConfirmation) {
                              print('Les mots de passe correspondent');
                              updatePassword(currentPassword, newPassword);
                            } else {
                              await MyAlertDialog.showInfoAlertDialog(
                                  context: context,
                                  title: 'Les mots de passe ne correspondent pas',
                                  message: 'Veuillez choisir le même mot de passe pour le mot de passe et la confirmation du mot de passe');
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                            side: BorderSide(
                              color: context.select((ThemeProvider themeProvider) =>
                              themeProvider.currentTheme.secondaryHeaderColor),
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
                              color: context.select((ThemeProvider themeProvider) =>
                              themeProvider.currentTheme.secondaryHeaderColor),
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

  Widget buildButton(
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
  }
}
