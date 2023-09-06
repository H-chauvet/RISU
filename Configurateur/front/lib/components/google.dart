import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

///
/// Google button
/// 
class GoogleLogo extends StatelessWidget {
  GoogleLogo({super.key});

  final GoogleSignIn _googleSignIn = GoogleSignIn(clientId: "ID secret :)");

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          print('google');
          startSignIn();
        },
        child: Container(
          width: 200,
          height: 40,
          decoration: const BoxDecoration(
              color: Color.fromARGB(255, 214, 214, 214),
              borderRadius: BorderRadius.all(Radius.circular(30.0))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                  // decoration: BoxDecoration(color: Colors.blue),
                  child: Image.asset(
                'assets/google-logo.png',
                height: 20,
              )),
              const SizedBox(
                width: 5.0,
              ),
              const Text('Google')
            ],
          ),
        ));
  }

  void startSignIn() async {
    await _googleSignIn.signOut();
    GoogleSignInAccount? user = await _googleSignIn.signInSilently();

    if (user == null) {
      user = await _googleSignIn.signIn();
      if (user == null) {
        print('error');
      } else {
        registerGoogleConnection(user);
      }
    } else {
      registerGoogleConnection(user);
    }
  }

  void registerGoogleConnection(GoogleSignInAccount user) {
    print(user);
    http.post(
      Uri.parse('http://localhost:3000/api/auth/google-login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
      },
      body: jsonEncode(<String, String>{'email': user.email}),
    );
  }
}
