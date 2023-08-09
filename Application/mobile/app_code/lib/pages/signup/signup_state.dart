import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:risu/flutter_objects/alert_dialog.dart';

import '../../material_lib_functions/material_functions.dart';
import '../../network/informations.dart';
import '../login/login_functional.dart';
import 'signup_page.dart';

class SignupPageState extends State<SignupPage> {
  String? _email;
  String? _password;
  String? _confirmationPassword;
  late Future<String> _futureSignup;

  Future<String> apiSignup() async {
    if (_email == null || _password == null || _confirmationPassword == null) {
      return 'Please fill all the field !';
    }
    final response = await http.post(
      Uri.parse('http://$serverIp:8080/api/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{'email': _email!, 'password': _password!}),
    );

    if (response.statusCode == 201) {
      await MyAlertDialog.showInfoAlertDialog(
          context: context,
          title: 'Email',
          message: 'A confirmation e-mail has been sent to you.');
      return 'A confirmation e-mail has been sent to you !';
    } else {
      return 'Invalid e-mail address !';
    }
  }

  @override
  void initState() {
    super.initState();
    _futureSignup = Future<String>.value('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
            child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 32),
                child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: const <Widget>[
                              Text('Risu',
                                  key: Key('title-text'),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 42))
                            ]),
                        const Text(
                          'Création d\'un compte',
                          key: Key('subtitle-text'),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        TextFormField(
                          key: const Key('email-text_input'),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'E-mail...',
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (String? value) {
                            if (value != null &&
                                !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value)) {
                              return 'Doit être une adresse e-mail valide.';
                            }
                            _email = value;
                            return null;
                          },
                        ),
                        TextFormField(
                          key: const Key('password-text_input'),
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Mot de passe...',
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (String? value) {
                            if (value != null && value.length <= 7) {
                              return 'Le mot de passe doit contenir au moins 8 caractères.';
                            }
                            _password = value;
                            return null;
                          },
                        ),
                        TextFormField(
                          key: const Key('password_confirmation-text_input'),
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Confirmer mot de passe...',
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (String? value) {
                            if (value != null && value.length <= 7) {
                              return 'Le mot de passe doit contenir au moins 8 caractères.';
                            }
                            if (value != _password) {
                              return 'Les mots de passe ne correspondent pas.';
                            }
                            _confirmationPassword = value;
                            return null;
                          },
                        ),
                        FutureBuilder<String>(
                          future: _futureSignup,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(snapshot.data!);
                            } else if (snapshot.hasError) {
                              return Text('${snapshot.error}');
                            }
                            return const CircularProgressIndicator();
                          },
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            materialElevatedButton(
                              ElevatedButton(
                                key: const Key('send_signup-button'),
                                onPressed: () {
                                  setState(() {
                                    apiSignup();
                                  });
                                },
                                child: const Text(
                                  'Inscription',
                                  key: Key('title-text'),
                                ),
                              ),
                              context,
                              primaryColor: getOurPrimaryColor(100),
                              borderWith: 1,
                              borderColor: getOurPrimaryColor(100),
                              sizeOfButton: 1.8,
                              isShadowNeeded: true,
                            ),
                            TextButton(
                              key: const Key('go_login-button'),
                              onPressed: () {
                                goToLoginPage(context, false);
                              },
                              child: Text(
                                'Retour à l\'écran de connexion...',
                                style:
                                    TextStyle(color: getOurPrimaryColor(100)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )))));
  }
}
