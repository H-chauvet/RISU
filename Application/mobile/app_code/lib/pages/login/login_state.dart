import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:risu/flutter_objects/alert_dialog.dart';
import 'package:risu/flutter_objects/text_input.dart';
import 'package:risu/network/informations.dart';
import 'package:risu/pages/home/home_functional.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:risu/utils/validators.dart';

import '../../flutter_objects/filled_button.dart';
import '../../flutter_objects/user_data.dart';
import '../../material_lib_functions/material_functions.dart';
import '../../utils/theme.dart';
import '../home/home_page.dart';
import '../signup/signup_functional.dart';
import 'login_page.dart';

class LoginPageState extends State<LoginPage> {
  String? _email;
  String? _password;
  bool _isPasswordVisible = false;

  void apiLogin() async {
    if (_email == null || _password == null) {
      if (context.mounted) {
        await MyAlertDialog.showInfoAlertDialog(
            context: context,
            title: 'Connexion',
            message: 'Please fill all the fields!');
      }
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
      if (context.mounted) {
        await MyAlertDialog.showInfoAlertDialog(
            context: context,
            title: 'Connexion',
            message: 'Connection refused.');
      }
    }

    if (response.statusCode == 201) {
      try {
        final jsonData = jsonDecode(response.body);
        if (jsonData.containsKey('data')) {
          userInformation = UserData.fromJson(jsonData['data']);
        } else {
          if (context.mounted) {
            await MyAlertDialog.showInfoAlertDialog(
                context: context,
                title: 'Connexion',
                message: 'Invalid token... Please retry (data not found)');
          }
        }
      } catch (err) {
        debugPrint(err.toString());
        if (context.mounted) {
          await MyAlertDialog.showInfoAlertDialog(
              context: context,
              title: 'Connexion',
              message: 'Invalid token... Please retry.');
        }
      }
    } else {
      try {
        final jsonData = jsonDecode(response.body);
        if (jsonData.containsKey('message')) {
          if (context.mounted) {
            await MyAlertDialog.showInfoAlertDialog(
                context: context,
                title: 'Connexion',
                message: jsonData['message']);
          }
        } else {
          if (context.mounted) {
            await MyAlertDialog.showInfoAlertDialog(
                context: context,
                title: 'Connexion',
                message: 'Invalid credentials.');
          }
        }
      } catch (err) {
        if (context.mounted) {
          await MyAlertDialog.showInfoAlertDialog(
              context: context,
              title: 'Connexion',
              message: 'Invalid credentials.');
        }
      }
    }
  }

  Future<String> apiResetPassword(BuildContext context) async {
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
    if (context.mounted) {
      await MyAlertDialog.showInfoAlertDialog(
          context: context,
          title: 'Email',
          message: 'A reset password has been sent to your email box.');
    }
    return jsonDecode(response.body)['message'].toString();
  }

  Widget displayGoToSignup(BuildContext context) {
    return TextButton(
      key: const Key('goto_signup-button'),
      onPressed: () {
        goToSignupPage(context);
      },
      child: Text(
        'Pas de compte ? S\'inscrire',
        style: TextStyle(
            color: context.select((ThemeProvider themeProvider) =>
                themeProvider.currentTheme.secondaryHeaderColor)),
      ),
    );
  }

  Widget displayLoginButton(snapshot, BuildContext context) {
    return Column(children: [
      MyButton(
        key: const Key('login-button'),
        text: 'Se connecter',
        onPressed: () {
          setState(() {
            apiLogin();
          });
        },
      ),
      displayGoToSignup(context)
    ]);
  }

  Widget displayResetPassword(BuildContext context) {
    bool isButtonDisabled = false;
    return Column(
      children: [
        TextButton(
          key: const Key('reset_password-button'),
          onPressed: isButtonDisabled
              ? null
              : () {
                  setState(() {
                    apiResetPassword(context);
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
            style: TextStyle(
                fontSize: 12,
                color: context.select((ThemeProvider themeProvider) =>
                    themeProvider.currentTheme.secondaryHeaderColor)),
          ),
        ),
      ],
    );
  }

  Widget displayEmailConnexionInputs(snapshot, BuildContext context) {
    return Column(
      children: [
        MyTextInput(
          hintText: "Email",
          labelText: "Email",
          keyboardType: TextInputType.emailAddress,
          icon: Icons.email_outlined,
          onChanged: (value) => _email = value,
        ),
        const SizedBox(height: 16),
        MyTextInput(
            hintText: "Mot de passe",
            labelText: "Mot de passe",
            keyboardType: TextInputType.visiblePassword,
            obscureText: !_isPasswordVisible,
            icon: Icons.lock_outline,
            rightIcon:
                _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
            rightIconOnPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
            onChanged: (value) => _password = value,
            validator: (value) => Validators().notEmpty(context, value)),
        Align(
          alignment: Alignment.centerRight,
          child: displayResetPassword(context),
        ),
        if (snapshot.hasError)
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: context.select((ThemeProvider themeProvider) =>
          themeProvider.currentTheme.colorScheme.background),
      body: Center(
        child: FutureBuilder<String>(
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              if (userInformation != null) {
                return const HomePage();
              }
              logout = false;
              return Align(
                alignment: Alignment.center,
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      displayLogo(90),
                      const SizedBox(height: 8),
                      Text(
                        'Connexion à mon compte',
                        key: Key('subtitle-text'),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: context.select(
                                (ThemeProvider themeProvider) => themeProvider
                                    .currentTheme.secondaryHeaderColor)),
                      ),
                      const SizedBox(height: 8),
                      displayEmailConnexionInputs(snapshot, context),
                      displayLoginButton(snapshot, context),
                    ],
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
