import 'package:flutter/material.dart';
import 'package:front/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    String mail = '';
    String password = '';
    String validedPassword = '';

    return Scaffold(
        body: Form(
            key: formKey,
            child: Column(children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Entrez votre email',
                  labelText: 'Adresse e-mail',
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
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Entrez votre mot de passe',
                  labelText: 'Mot de passe',
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
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Validation du mot de passe',
                  labelText: 'Valider le mot de passe',
                ),
                onChanged: (String? value) {
                  validedPassword = value!;
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez remplir ce champ';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    debugPrint('$mail, $password, $validedPassword');
                    http.post(
                      Uri.parse('http://localhost:3000/api/auth/register'),
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                        'Access-Control-Allow-Origin': '*',
                      },
                      body: jsonEncode(<String, String>{
                        'email': mail,
                        'password': password,
                      }),
                    );
                  }
                },
                child: const Text("S'inscrire"),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const MyHomePage(title: 'tile')));
                },
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text("Déja un compte ? Connectez-vous."),
                ),
              )
            ])));
  }
}
