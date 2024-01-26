import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:risu/components/alert_dialog.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/components/outlined_button.dart';
import 'package:risu/components/text_input.dart';
import 'package:risu/globals.dart';
import 'package:risu/utils/errors.dart';
import 'package:risu/utils/theme.dart';

import 'contact_page.dart';

class ContactPageState extends State<ContactPage> {
  String? _name;
  String? _email;
  String? _message;

  @override
  void initState() {
    super.initState();
  }

  Future<bool> apiContact(String name, String email, String message) async {
    late http.Response response;
    try {
      response = await http.post(
        Uri.parse('http://$serverIp:8080/api/contact'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
            <String, String>{'name': name, 'email': email, 'message': message}),
      );
    } catch (err, stacktrace) {
      if (context.mounted) {
        printCatchError(context, err, stacktrace,
            message: "Connexion refused.");
      }
    }
    if (response.statusCode == 201) {
      if (context.mounted) {
        await MyAlertDialog.showInfoAlertDialog(
          context: context,
          title: 'Contact',
          message: 'Message envoyé.',
        );
        return true;
      }
    } else {
      if (context.mounted) {
        printServerResponse(context, response, 'apiContact',
            message: "Erreur lors de l'envoi du message.");
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        curveColor: context.select((ThemeProvider themeProvider) =>
            themeProvider.currentTheme.secondaryHeaderColor),
        showBackButton: false,
        showLogo: true,
        showBurgerMenu: false,
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: context.select((ThemeProvider themeProvider) =>
          themeProvider.currentTheme.colorScheme.background),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Text(
                  'Nous contacter',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: context.select((ThemeProvider themeProvider) =>
                        themeProvider.currentTheme.secondaryHeaderColor),
                    shadows: [
                      Shadow(
                        color: context.select((ThemeProvider themeProvider) =>
                            themeProvider.currentTheme.secondaryHeaderColor),
                        blurRadius: 24,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                MyTextInput(
                  key: const Key('contact-text_input-input_name'),
                  labelText: "Nom",
                  keyboardType: TextInputType.name,
                  icon: Icons.person,
                  onChanged: (value) => _name = value,
                ),
                const SizedBox(height: 16),
                MyTextInput(
                  key: const Key('contact-text_input-input_email'),
                  labelText: "Email",
                  keyboardType: TextInputType.emailAddress,
                  icon: Icons.email_outlined,
                  onChanged: (value) => _email = value,
                ),
                const SizedBox(height: 16),
                MyTextInput(
                  key: const Key('contact-text_input-input_message'),
                  labelText: "Message",
                  keyboardType: TextInputType.multiline,
                  icon: Icons.message_outlined,
                  onChanged: (value) => _message = value,
                  height: 128,
                ),
                const SizedBox(height: 36),
                MyOutlinedButton(
                  text: 'Envoyer',
                  key: const Key('contact-button-send_message'),
                  onPressed: () {
                    if (_name != null &&
                        _name != "" &&
                        _email != null &&
                        _email != "" &&
                        _message != null &&
                        _message != "") {
                      apiContact(_name!, _email!, _message!)
                          .then((value) => {});
                    } else {
                      MyAlertDialog.showErrorAlertDialog(
                        key: const Key("contact-alert_dialog-invalid_info"),
                        context: context,
                        title: 'Erreur',
                        message: 'Veuillez entrer des informations valides.',
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
