import 'dart:convert';

import 'package:risu/network/informations.dart';
import 'package:risu/pages/home/home_functional.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

import '../../flutter_objects/user_data.dart';
import '../../material_lib_functions/material_functions.dart';
import '../signup/signup_functional.dart';
import 'login_page.dart';

class LoginPageState extends State<LoginPage> {
  /// email to login with
  String? _email;

  /// password to login with
  String? _password;

  /// To know if an user connect himself with email method
  bool _isConnexionWithEmail = false;

  /// future api answer
  late Future<String> _futureLogin;

  /// Network function calling the API to login
  Future<String> apiAskForLogin() async {
    if (_email == null || _password == null) {
      return 'Please fill all the fields!';
    }

    late http.Response response;
    try {
      response = await http.post(
        Uri.parse('http://$serverIp:8080/api/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
            <String, String>{'email': _email!, 'password': _password!}),
      );
    } catch (err) {
      return 'Connection refused.';
    }

    if (response.statusCode == 201) {
      try {
        final jsonData = jsonDecode(response.body);
        if (jsonData.containsKey('data')) {
          userInformation = UserData.fromJson(jsonData['data']);
          return 'Login succeeded!';
        } else {
          return 'Invalid token... Please retry (data not found)';
        }
      } catch (err) {
        debugPrint(err.toString());
        return 'Invalid token... Please retry';
      }
    } else {
      try {
        final jsonData = jsonDecode(response.body);
        if (jsonData.containsKey('message')) {
          return jsonData['message'];
        } else {
          return 'Invalid credentials.';
        }
      } catch (err) {
        return 'Invalid credentials.';
      }
    }
  }

  /// Network function calling the API to reset password
  Future<String> apiAskForResetPassword() async {
    if (_email == null) {
      return 'Please provide a valid email !';
    }
    var response = await http.post(
      Uri.parse('http://$serverIp:8080/api/user/resetPassword'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'email': _email!}),
    );
    return jsonDecode(response.body)['message'].toString();
  }

  /// Initialization function for the api answer
  Future<String> getAFirstLoginAnswer() async {
    return '';
  }

  /// This function display the login name of our project
  Widget displayAppName() {
    return const Text('Se connecter à RISU',
        key: Key('title-text'),
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 42));
  }

  /// This function display our logo and the login name of our project
  Widget displayLogoAndName() {
    return Column(
        key: const Key('logo_name-column'),
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[displayLogo(90), displayAppName()]);
  }

  /// This function display the button for create a new account
  Widget displayButtonRequestANewAccount() {
    return TextButton(
      key: const Key('goto_signup-button'),
      onPressed: () {
        goToSignupPage(context);
      },
      child: Text(
        'Pas de compte ? S\'inscrire',
        style: TextStyle(color: getOurPrimaryColor(100)),
      ),
    );
  }

  /// This function display all widget for the login with an email
  Widget displayButtonRequestForEmailLogin() {
    return Column(
      children: <Widget>[
        SizedBox(
          child: materialElevatedButton(
            ElevatedButton(
              key: const Key('continue_email-button'),
              onPressed: () {
                setState(() {
                  _isConnexionWithEmail = true;
                });
              },
              child: const Text('Continuer avec un e-mail',
                  key: Key('subtitle-text'),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: 'Roboto-Black')),
            ),
            context,
            primaryColor: getOurPrimaryColor(100),
            borderWith: 1,
            borderColor: getOurPrimaryColor(100),
            sizeOfButton: 1.8,
            isShadowNeeded: true,
          ),
        ),
        displayButtonRequestANewAccount()
      ],
    );
  }

  /// This function display widgets for connexion password with an email
  Widget displayInputForEmailConnexion(snapshot) {
    return Column(children: <Widget>[
      SizedBox(
          child: materialElevatedButton(
        ElevatedButton(
          key: const Key('login-button'),
          onPressed: () {
            setState(() {
              _futureLogin = apiAskForLogin();
            });
          },
          child: const Text(
            'Se connecter',
            style: TextStyle(color: Colors.white),
          ),
        ),
        context,
        primaryColor: getOurPrimaryColor(100),
        borderWith: 1,
        borderColor: getOurPrimaryColor(100),
        sizeOfButton: 1.8,
        isShadowNeeded: true,
      )),
      displayButtonRequestANewAccount()
    ]);
  }

  /// This function displays the button for requesting a new password
  Widget displayResetAndForgotPassword() {
    bool isButtonDisabled = false;
    return Column(
      children: <Widget>[
        TextButton(
          key: const Key('reset_password-button'),
          // ignore: dead_code
          onPressed: isButtonDisabled
              ? null
              : () {
                  setState(() {
                    _futureLogin = apiAskForResetPassword();
                    isButtonDisabled = true;
                    Timer(const Duration(seconds: 5), () {
                      setState(() {
                        isButtonDisabled = false;
                      });
                    });
                  });
                },
          child: Text(
            'Mot de passe oublié ?',
            style: TextStyle(fontSize: 12, color: getOurPrimaryColor(100)),
          ),
        ),
      ],
    );
  }

  /// This function display input for email login (input mail and password)
  Widget displayInputForEmailLogin(snapshot) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        /// Put Login with Gmail or an other login
        TextFormField(
          key: const Key('email-text_input'),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            labelText: 'E-mail',
          ),
          initialValue: _email,
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
        const SizedBox(
          height: 20,
        ),
        if (_isConnexionWithEmail == true)
          Column(
            children: [
              TextFormField(
                key: const Key('password-text_input'),
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Mot de passe',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  displayResetAndForgotPassword(),
                ],
              ),
            ],
          ),
        if (_isConnexionWithEmail == true && snapshot.hasError)
          Text(
            '{$snapshot.error}',
            style: const TextStyle(fontSize: 12),
          )
        else
          Text(
            snapshot.data!,
            style: const TextStyle(fontSize: 12),
          ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _futureLogin = getAFirstLoginAnswer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: FutureBuilder<String>(
          future: _futureLogin,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show a loading indicator while waiting for the future to complete
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              // Handle the error state
              return Text('Error: ${snapshot.error}');
            } else {
              // Display the UI based on the future result
              logout = false;
              return Center(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        displayLogoAndName(),
                        const SizedBox(height: 20),
                        if (_isConnexionWithEmail)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isConnexionWithEmail = false;
                                  });
                                },
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  color: getOurPrimaryColor(100),
                                ),
                              ),
                            ],
                          ),
                        displayInputForEmailLogin(snapshot),
                        if (_isConnexionWithEmail == false)
                          displayButtonRequestForEmailLogin(),
                        if (_isConnexionWithEmail)
                          displayInputForEmailConnexion(snapshot),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
