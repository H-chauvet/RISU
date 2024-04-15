import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:front/components/custom_footer.dart';
import 'package:front/components/custom_header.dart';
import 'package:front/components/google.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/main.dart';
import 'package:front/network/informations.dart';
import 'package:front/screens/register-confirmation/register_confirmation.dart';
import 'package:front/services/http_service.dart';
import 'package:front/services/storage_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:convert';

import 'package:go_router/go_router.dart';

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
        body: FooterView(
            footer: Footer(
              child: CustomFooter(context: context),
            ),
            children: [
          LandingAppBar(context: context),
          const Text(
            'Inscrivez-vous sur le site RISU !',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 35,
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              color: Color(0xfff033F63),
              shadows: [
                Shadow(
                  color: Color(0xff28666e),
                  offset: Offset(0.75, 0.75),
                  blurRadius: 1.5,
                ),
              ],
            ),
          ),
          Center(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 150),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.height * 0.7,
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
                                context.go("/register-confirmation",
                                    extra: mail);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF162A49),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            child: const Text(
                              "S'inscrire",
                              style: TextStyle(fontSize: 18),
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
                      ])))
            ],
          ))
        ]));
  }
}
