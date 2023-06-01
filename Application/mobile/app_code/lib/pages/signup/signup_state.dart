import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../material_lib_functions/material_functions.dart';
import '../../network/informations.dart';
import '../login/login_functional.dart';
import 'signup_page.dart';

class SignupPageState extends State<SignupPage> {
  /// email to signup
  String? _email;

  /// password to signup
  String? _password;

  /// password to signup
  String? _confirmation_password;

  /// future api answer
  late Future<String> _futureSignup;

  /// Network function calling the api to signup
  Future<String> apiAskForSignup() async {
    if (_email == null || _password == null || _confirmation_password == null) {
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
      return 'Signup succeed ! Check your email and go to Login page';
    } else {
      return 'Invalid e-mail address !';
    }
  }

  /// Initialization function for the api answer
  Future<String> getAFirstSignupAnswer() async {
    return '';
  }

  /// This function display the login and the name of our project
  Widget displayAreaLoginSentence() {
    return const Text('Risu',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 42));
  }

  /// This function display our logo and the login name of our project
  Widget displayLogoAndName() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          const Text(""),
          // displayLogo(90),
          displayAreaLoginSentence()
        ]);
  }

  @override
  void initState() {
    super.initState();
    _futureSignup = getAFirstSignupAnswer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
            child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        displayLogoAndName(),
                        const Text(
                          'Création d\'un compte',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        TextFormField(
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
                            _confirmation_password = value;
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
                            materialElevatedButtonArea(
                              ElevatedButton(
                                key: const Key('SendSignupButton'),
                                onPressed: () {
                                  setState(() {
                                    _futureSignup = apiAskForSignup();
                                  });
                                },
                                child: const Text('Inscription'),
                              ),
                              context,
                              primaryColor: getOurPrimaryColor(100),
                              borderWith: 1,
                              borderColor: getOurPrimaryColor(100),
                              sizeOfButton: 1.8,
                              isShadowNeeded: true,
                            ),
                            TextButton(
                              key: const Key('GoLoginButton'),
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
