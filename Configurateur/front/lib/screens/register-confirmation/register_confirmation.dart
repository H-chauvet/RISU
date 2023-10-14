import 'package:flutter/material.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/main.dart';
import 'package:front/network/informations.dart';
import 'package:front/screens/login/login.dart';
import 'package:front/services/storage_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterConfirmation extends StatefulWidget {
  const RegisterConfirmation({super.key, required this.params});

  final String params;

  @override
  State<RegisterConfirmation> createState() => RegisterConfirmationState();
}

///
/// Register confirmation screen
///
/// page de confirmation d'inscription pour le configurateur
class RegisterConfirmationState extends State<RegisterConfirmation> {
  String jwtToken = '';

  @override
  void initState() {
    StorageService().readStorage('token').then((value) => {
          debugPrint(value),
          if (value == null)
            {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()))
            }
          else
            {
              jwtToken = value,
            }
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime lastClicked = DateTime.parse("1969-07-20 20:18:04Z");
    DateTime now = DateTime.now();
    return Scaffold(
        appBar: CustomAppBar(
          "Confirmation d'inscription",
          context: context,
        ),
        body: Center(
            child: FractionallySizedBox(
                widthFactor: 0.3,
                heightFactor: 0.7,
                child: Column(
                  children: [
                    const Text(
                      "Afin de finaliser l'inscription de votre compte, merci de confirmer cette dernière grâce au lien que vous avez reçu par mail.",
                      style: TextStyle(fontSize: 26),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 80.0,
                    ),
                    const Text(
                      "Vous n'avez pas reçu le mail de confirmation ?",
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 35.0,
                    ),
                    SizedBox(
                      height: 40,
                      width: 400,
                      child: ElevatedButton(
                        key: const Key('send-mail'),
                        onPressed: () async {
                          now = DateTime.now();
                          final difference =
                              now.difference(lastClicked).inMinutes;
                          if (difference >= 1) {
                            lastClicked = DateTime.now();
                            await http.post(
                              Uri.parse(
                                  'http://$serverIp:3000/api/auth/register-confirmation'),
                              headers: <String, String>{
                                'Authorization': jwtToken,
                                'Content-Type':
                                    'application/json; charset=UTF-8',
                                'Access-Control-Allow-Origin': '*',
                              },
                              body: jsonEncode(<String, String>{
                                'email': widget.params,
                              }),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff4682B4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: const Text(
                          "Renvoyer le mail de confirmation",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    InkWell(
                      key: const Key('go-home'),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const MyHomePage(title: 'tile')));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              Text(
                                "Retour à l'acceuil",
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 16),
                              ),
                            ]),
                      ),
                    ),
                  ],
                ))));
  }
}
