import 'package:flutter/material.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConfirmedUser extends StatefulWidget {
  const ConfirmedUser({super.key, required this.params});

  final String params;

  @override
  State<ConfirmedUser> createState() => ConfirmedUserState();
}

///
/// Password change screen
///
/// page de confirmation d'enregistrement pour le configurateur
class ConfirmedUserState extends State<ConfirmedUser> {
  @override
  void initState() {
    http.post(
      Uri.parse('http://localhost:3000/api/auth/confirmed-register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
      },
      body: jsonEncode(<String, String>{
        'uuid': widget.params,
      }),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                      "Votre inscription a bien été confirmée, vous pouvez maintenant vous connecter et profiter de notre application",
                      style: TextStyle(fontSize: 26),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 80.0,
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
