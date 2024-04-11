import 'package:flutter/material.dart';
import 'package:front/components/google.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/network/informations.dart';
import 'package:front/services/http_service.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/themes.dart';
import 'dart:convert';

import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => RegisterScreenState();
}

///
/// Register screen
///
/// page d'inscription pour le configurateur
class RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    String firstName = '';
    String lastName = '';
    String company = '';
    String mail = '';
    String password = '';
    String validedPassword = '';
    dynamic response;

    return Scaffold(
        appBar: CustomAppBar(
          'Inscription',
          context: context,
        ),
        body: Center(
            child: FractionallySizedBox(
                widthFactor: 0.2,
                heightFactor: 0.85,
                child: Form(
                    key: formKey,
                    child: Column(children: <Widget>[
                      TextFormField(
                        key: const Key('firstname'),
                        decoration: InputDecoration(
                          hintText: 'Entrez votre prénom',
                          labelText: 'Prénom',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        onChanged: (String? value) {
                          firstName = value!;
                        },
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez remplir ce champ';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        key: const Key('lastname'),
                        decoration: InputDecoration(
                          hintText: 'Entrez votre nom',
                          labelText: 'Nom',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        onChanged: (String? value) {
                          lastName = value!;
                        },
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez remplir ce champ';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        key: const Key('company'),
                        decoration: InputDecoration(
                          hintText: 'Entrez le nom de votre entreprise',
                          labelText: 'Entreprise',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        onChanged: (String? value) {
                          company = value!;
                        },
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez remplir ce champ';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        key: const Key('email'),
                        decoration: InputDecoration(
                          hintText: 'Entrez votre email',
                          labelText: 'Adresse e-mail',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        onChanged: (String? value) {
                          mail = value!;
                        },
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez remplir ce champ';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        key: const Key('password'),
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Entrez votre mot de passe',
                          labelText: 'Mot de passe',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        onChanged: (String? value) {
                          password = value!;
                        },
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez remplir ce champ';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        key: const Key('confirm-password'),
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Validation du mot de passe',
                          labelText: 'Valider le mot de passe',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        onChanged: (String? value) {
                          validedPassword = value!;
                        },
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez remplir ce champ';
                          }
                          if (value != password) {
                            return 'Les mots de passe ne correspondent pas';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 40,
                        width: 200,
                        child: ElevatedButton(
                          key: const Key(
                            'register',
                          ),
                          onPressed: () async {
                            if (formKey.currentState!.validate() &&
                                password == validedPassword) {
                              var body = {
                                'firstName': firstName,
                                'lastName': lastName,
                                'company': company,
                                'email': mail,
                                'password': password,
                              };
                              var header = <String, String>{
                                'Content-Type':
                                    'application/json; charset=UTF-8',
                                'Access-Control-Allow-Origin': '*',
                              };
                              await HttpService()
                                  .request(
                                      'http://$serverIp:3000/api/auth/register',
                                      header,
                                      body)
                                  .then((value) => {
                                        if (value.statusCode == 200)
                                          {
                                            response = jsonDecode(value.body),
                                            storageService.writeStorage(
                                              'token',
                                              response['accessToken'],
                                            ),
                                          }
                                      });
                              if (response != null) {
                                header.addEntries([
                                  MapEntry('Authorization',
                                      '${response['accessToken']}'),
                                ]);
                              }
                              await HttpService().request(
                                  'http://$serverIp:3000/api/auth/register-confirmation',
                                  header,
                                  body);
                              // ignore: use_build_context_synchronously
                              context.go("/register-confirmation", extra: mail);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: Text(
                            "S'inscrire",
                            style: TextStyle(
                              color: Provider.of<ThemeService>(context).isDark
                                  ? darkTheme.primaryColor
                                  : lightTheme.primaryColor,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        key: const Key('login'),
                        onTap: () {
                          context.go("/login");
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Déja un compte ? "),
                                Text(
                                  'Connectez-vous.',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ]),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text("S'inscrire avec :"),
                      const SizedBox(height: 10),
                      GoogleLogo(),
                    ])))));
  }
}
