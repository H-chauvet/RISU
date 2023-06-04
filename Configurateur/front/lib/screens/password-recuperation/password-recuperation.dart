import 'package:flutter/material.dart';
import 'package:front/components/google.dart';
import 'package:front/main.dart';
import 'package:http/http.dart' as http;
import 'package:local_captcha/local_captcha.dart';
import 'dart:convert';

class PasswordRecuperation extends StatefulWidget {
  const PasswordRecuperation({super.key});

  @override
  State<PasswordRecuperation> createState() => PasswordRecuperationState();
}

class PasswordRecuperationState extends State<PasswordRecuperation> {
  final captchaController = LocalCaptchaController();
  var inputCode = '';

  @override
  void dispose() {
    captchaController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final configFormData = ConfigFormData();

    String mail = '';

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Inscription',
            style: TextStyle(fontSize: 40),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xff4682B4),
          toolbarHeight: MediaQuery.of(context).size.height / 8,
          leading: Container(),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.elliptical(1920, 56.0),
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Image.asset("logo.png"),
              iconSize: 80,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyHomePage(title: 'tile')));
              },
            ),
          ],
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
                      LocalCaptcha(
                        key: ValueKey(configFormData.toString()),
                        controller: captchaController,
                        height: 100,
                        width: 200,
                        backgroundColor: Colors.grey[100]!,
                        chars: configFormData.chars,
                        length: configFormData.length,
                        caseSensitive: true,
                        codeExpireAfter: const Duration(minutes: 10),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Enter code',
                          hintText: 'Enter code',
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            if (value.length != configFormData.length) {
                              return '* Code must be length of ${configFormData.length}.';
                            }

                            final validation =
                                captchaController.validate(value);

                            switch (validation) {
                              case LocalCaptchaValidation.invalidCode:
                                return '* Invalid code.';
                              case LocalCaptchaValidation.codeExpired:
                                return '* Code expired.';
                              case LocalCaptchaValidation.valid:
                              default:
                                return null;
                            }
                          }

                          return '* Required field.';
                        },
                        onSaved: (value) => inputCode = value ?? '',
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                        height: 40.0,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => captchaController.refresh(),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blueGrey,
                          ),
                          child: const Text('Refresh'),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              http.post(
                                Uri.parse(
                                    'http://localhost:3000/api/auth/update-password'),
                                headers: <String, String>{
                                  'Content-Type':
                                      'application/json; charset=UTF-8',
                                  'Access-Control-Allow-Origin': '*',
                                },
                                body: jsonEncode(<String, String>{
                                  'email': mail,
                                }),
                              );
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const MyHomePage(title: 'tile')));
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
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ])))));
  }
}

class ConfigFormData {
  String chars = 'abdefghnryABDEFGHNQRY3468';
  int length = 5;
  double fontSize = 0;
  bool caseSensitive = false;
  Duration codeExpireAfter = const Duration(minutes: 10);

  @override
  String toString() {
    return '$chars$length$caseSensitive${codeExpireAfter.inMinutes}';
  }
}
