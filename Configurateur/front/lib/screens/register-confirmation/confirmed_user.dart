import 'package:flutter/material.dart';
import 'package:front/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConfirmedUser extends StatefulWidget {
  const ConfirmedUser({super.key, required this.params});

  final String params;

  @override
  State<ConfirmedUser> createState() => ConfirmedUserState();
}

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
        appBar: AppBar(
          title: const Text(
            "Confirmation d'inscription",
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
