import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:risu/flutter_objects/alert_dialog.dart';

import '../../flutter_objects/filled_button.dart';
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
                margin:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [displayLogo(90)]),
                    const SizedBox(height: 8),
                    const Text(
                      'Création d\'un compte',
                      key: Key('subtitle-text'),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
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
                    const SizedBox(height: 8),
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
                    const SizedBox(height: 8),
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
                        MyButton(
                          key: const Key('send_signup-button'),
                          text: 'Inscription',
                          onPressed: () {
                            setState(() {
                              apiSignup();
                            });
                          },
                        ),
                        TextButton(
                          key: const Key('go_login-button'),
                          onPressed: () {
                            goToLoginPage(context);
                          },
                          child: Text(
                            'Retour à l\'écran de connexion...',
                            style: TextStyle(color: getOurPrimaryColor(100)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ))));
  }
}
