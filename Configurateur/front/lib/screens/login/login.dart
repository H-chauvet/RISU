import 'package:flutter/material.dart';
import 'package:front/components/google.dart';
import 'package:front/main.dart';
import 'package:front/screens/register/register.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    String mail = '';
    String password = '';
    bool error = false;

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Connexion',
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
                      TextFormField(
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const MyHomePage(title: 'recup mdp')));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: const <Widget>[
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
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              debugPrint('$mail, $password');

                              try {
                                http
                                    .post(
                                      Uri.parse(
                                          'http://localhost:3000/api/auth/login'),
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
                                          debugPrint(value.body),
                                          if (value.statusCode == 200)
                                            {
                                              {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const MyHomePage(
                                                                title:
                                                                    'login success')))
                                              }
                                            }
                                          else
                                            {
                                              error = true,
                                              debugPrint('error'),
                                            }
                                        });
                              } catch (e) {
                                debugPrint(e.toString());

                                debugPrint('$error');
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff4682B4),
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
                        onTap: () {
                          setState(() => {debugPrint('test'), error = true});
                          /*Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const RegisterScreen()));*/
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const <Widget>[
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
                      const GoogleLogo(),
                      if (error) const Text('test'),
                    ])))));
  }
}
