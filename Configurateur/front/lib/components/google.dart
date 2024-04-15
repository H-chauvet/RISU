import 'package:flutter/material.dart';
import 'package:front/network/informations.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';

import 'package:provider/provider.dart';

///
/// Google button
///
class GoogleLogo extends StatelessWidget {
  GoogleLogo({super.key});

  final GoogleSignIn _googleSignIn = GoogleSignIn(
      clientId:
          "750790002860-f4p6kt271o3fsp30ii3eqjj8hm7ehqve.apps.googleusercontent.com");

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          startSignIn(context);
        },
        child: Container(
          width: 200,
          height: 40,
          decoration: BoxDecoration(
              color: const Color(0xFF162A49),
              borderRadius: const BorderRadius.all(Radius.circular(30.0))),
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
              Text(
                'Google',
                style: TextStyle(
                    color: Provider.of<ThemeService>(context).isDark
                        ? Colors.black
                        : Colors.white),
              )
            ],
          ),
        ));
  }

  void startSignIn(BuildContext context) async {
    await _googleSignIn.signOut();
    GoogleSignInAccount? user = await _googleSignIn.signInSilently();

    if (user == null) {
      user = await _googleSignIn.signIn();
      if (user == null) {
        print('error');
      } else {
        // ignore: use_build_context_synchronously
        registerGoogleConnection(user, context);
      }
    } else {
      // ignore: use_build_context_synchronously
      registerGoogleConnection(user, context);
    }
  }

  void registerGoogleConnection(
      GoogleSignInAccount user, BuildContext context) async {
    dynamic response;
    await http
        .post(
          Uri.parse('http://$serverIp:3000/api/auth/google-login'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Access-Control-Allow-Origin': '*',
          },
          body: jsonEncode(<String, String>{'email': user.email}),
        )
        .then((value) => {
              if (value.statusCode == 200)
                {
                  Fluttertoast.showToast(
                    msg: 'Vous êtes désormais connecté !',
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                  ),
                  response = jsonDecode(value.body),
                  StorageService()
                      .writeStorage('token', response['accessToken']),
                  context.go('/')
                }
              else
                {
                  Fluttertoast.showToast(
                    msg: 'Echec de la connexion',
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                  ),
                }
            });
  }
}
