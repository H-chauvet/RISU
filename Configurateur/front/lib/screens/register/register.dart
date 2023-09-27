import 'package:flutter/material.dart';
import 'package:front/components/google.dart';
import 'package:front/main.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/screens/login/login.dart';
import 'package:front/screens/register-confirmation/register_confirmation.dart';
import 'package:front/services/http_service.dart';
import 'package:front/services/storage_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
                heightFactor: 0.7,
                child: Form(
                    key: formKey,
                    child: Column(children: <Widget>[
                      const SizedBox(height: 10),
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
                              var body = <String, String>{
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
                                      'http://193.70.89.108:3000/api/auth/register',
                                      header,
                                      body)
                                  .then((value) => {
                                        if (value.statusCode == 200)
                                          {
                                            response = jsonDecode(value.body),
                                            StorageService().writeStorage(
                                                'token',
                                                response['accessToken']),
                                          }
                                      });
                              if (response != null) {
                                header.addEntries([
                                  MapEntry('Authorization',
                                      '${response['accessToken']}'),
                                ]);
                              }
                              await HttpService().request(
                                  'http://193.70.89.108:3000/api/auth/register',
                                  header,
                                  body);
                              // ignore: use_build_context_synchronously
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          RegisterConfirmation(params: mail)));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff4682B4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: const Text(
                            "S'inscrire",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                      InkWell(
                        key: const Key('login'),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const <Widget>[
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
