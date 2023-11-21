import 'package:flutter/material.dart';
import 'package:front/components/google.dart';
import 'package:front/network/informations.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/services/storage_service.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

///
/// Login screen
///
/// page de connexion pour le configurateur
///
class LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    String mail = '';
    String password = '';
    dynamic response;
    Map<String, dynamic> decodedToken;

    return Scaffold(
        appBar: CustomAppBar(
          'Connexion',
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
                      InkWell(
                        onTap: () {
                          context.go("/password-recuperation");
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  'Mot de passe oublié ?',
                                  style: TextStyle(color: Colors.blue),
                                  textAlign: TextAlign.right,
                                ),
                              ]),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 40,
                        width: 200,
                        child: ElevatedButton(
                          key: const Key('login'),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              http
                                  .post(
                                    Uri.parse(
                                        'http://$serverIp:3000/api/auth/login'),
                                    headers: <String, String>{
                                      'Content-Type':
                                          'application/json; charset=UTF-8',
                                      'Access-Control-Allow-Origin': '*',
                                    },
                                    body: jsonEncode(<String, String>{
                                      'email': mail,
                                      'password': password,
                                    }),
                                  )
                                  .then((value) => {
                                        if (value.statusCode == 200)
                                          {
                                            response = jsonDecode(value.body),
                                            token = response['accessToken'],
                                            decodedToken = JwtDecoder.decode(token),
                                            userMail = decodedToken['userMail'],
                                            /*StorageService().writeStorage(
                                                'token',
                                                response['accessToken']),*/
                                            context.go("/")
                                          }
                                      });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: const Text(
                            "Se connecter",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      InkWell(
                        key: const Key('register'),
                        onTap: () {
                          context.go("/register");
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Nouveau sur la plateforme ? "),
                                Text(
                                  'Créer un compte.',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ]),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text("Se connecter avec :"),
                      const SizedBox(height: 10),
                      GoogleLogo(),
                    ])))));
  }
}
