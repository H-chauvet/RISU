import 'package:flutter/material.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/network/informations.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';

class PasswordChange extends StatefulWidget {
  const PasswordChange({super.key, required this.params});

  final String params;

  @override
  State<PasswordChange> createState() => PasswordChangeState();
}

///
/// Password change screen
///
/// page de changement de mot de passe pour le configurateur
class PasswordChangeState extends State<PasswordChange> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    String password = '';
    String validedPassword = '';

    return Scaffold(
        appBar: CustomAppBar(
          'Nouveau mot de passe',
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
                        width: 300,
                        child: ElevatedButton(
                          key: const Key('change-password'),
                          onPressed: () async {
                            if (formKey.currentState!.validate() &&
                                password == validedPassword) {
                              var response = await http.post(
                                Uri.parse(
                                    'http://$serverIp:3000/api/auth/update-password'),
                                headers: <String, String>{
                                  'Content-Type':
                                      'application/json; charset=UTF-8',
                                  'Access-Control-Allow-Origin': '*',
                                },
                                body: jsonEncode(<String, String>{
                                  'uuid': widget.params,
                                  'password': password,
                                }),
                              );
                              if (response.statusCode == 200) {
                                Fluttertoast.showToast(
                                  msg: 'Mot de passe changé avec succès',
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                );
                              } else {
                                Fluttertoast.showToast(
                                  msg:
                                      'Echec lors du changement du mot de passe',
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                );
                              }
                              // ignore: use_build_context_synchronously
                              context.go("/");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: const Text(
                            "Changer le mot de passe",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ])))));
  }
}
