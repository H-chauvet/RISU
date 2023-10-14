import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../network/informations.dart';
import '../../utils/theme.dart';
import '../login/login_page.dart';
import 'contact_functional.dart';
import 'contact_page.dart';
import 'package:risu/components/text_input.dart';
import 'package:risu/network/informations.dart';
import 'package:http/http.dart' as http;
import 'package:risu/components/alert_dialog.dart';
import 'dart:convert';


class ContactPageState extends State<ContactPage> {
  String? _name;
  String? _email;
  String? _message;

  Future<bool> apiContact(String name, String email, String message) async {
    late http.Response response;
    try {
      response = await http.post(
        Uri.parse('http://$serverIp:8080/api/contact'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{'name': name, 'email': email, 'message': message}),
      );
    } catch (err) {
      if (context.mounted) {
        await MyAlertDialog.showInfoAlertDialog(
            context: context,
            title: 'Contact',
            message: 'Connection refused.');
        print(err);
        print(response.statusCode);
      }
    }
    if (response.statusCode == 201) {
      if (context.mounted) {
        await MyAlertDialog.showInfoAlertDialog(
            context: context,
            title: 'Contact',
            message: 'Message envoyé.');
        return true;
      }
    } else {
      if (context.mounted) {
        print(response.statusCode);
        await MyAlertDialog.showInfoAlertDialog(
            context: context,
            title: 'Contact',
            message: 'Erreur lors de l\'envoi du message.');
      }
    }
    return false;
  }

  /// Update state function
  void update() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    updatePage = update;
  }

  /// Re sync all flutter object
  void homeSync() async {
    update();
  }

  @override
  Widget build(BuildContext context) {
    /*if (logout || userInformation == null) {
      userInformation = null;
      return const LoginPage();
    } else {*/
    if (true) {
      return Scaffold(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Chevron bleu pour la navigation vers /home
                      GestureDetector(
                        onTap: () {
                          // Naviguer vers la route "/home"
                          context.go('/home');
                        },
                        child: const Icon(
                          Icons.chevron_left,
                          color: Colors.blue, // Couleur du chevron
                          size: 30.0, // Taille du chevron
                        ),
                      ),
                      // Espacement entre le chevron et le logo

                      // Logo RISU
                      Expanded(
                        child: Center(
                          child: Image.asset(
                            'assets/logo_noir.png',
                            width: 200,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Nous contacter',
                    key: const Key('subtitle-text'),
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
                  const SizedBox(height: 42),
                  MyTextInput(
                    labelText: "Nom",
                    keyboardType: TextInputType.name,
                    icon: Icons.person,
                    onChanged: (value) => _name = value,
                  ),
                  const SizedBox(height: 16),
                  MyTextInput(
                    labelText: "Email",
                    keyboardType: TextInputType.emailAddress,
                    icon: Icons.email_outlined,
                    onChanged: (value) => _email = value,
                  ),
                  const SizedBox(height: 16),
                  MyTextInput(
                    labelText: "Message",
                    keyboardType: TextInputType.multiline,
                    icon: Icons.message_outlined,
                    onChanged: (value) => _message = value,
                    height: 200,
                  ),
                  const SizedBox(height: 36),
                  OutlinedButton(
                    key: const Key('new-contact-button'),
                    onPressed: () {
                      print('Nom : $_name');
                      print('Email : $_email');
                      print('Message : $_message');
                      if (_name != "" && _email != "" && _message != "") {
                        apiContact(_name!, _email!, _message!).then((value) => {
                        });
                      } else {
                        MyAlertDialog.showInfoAlertDialog(
                            context: context,
                            title: 'champs invalides',
                            message: 'Veuillez entrer des informations valides.');
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                      side: BorderSide(
                        color: context.select((ThemeProvider themeProvider) =>
                        themeProvider.currentTheme.secondaryHeaderColor),
                        width: 3.0,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48.0,
                        vertical: 16.0,
                      ),
                    ),
                    child: Text(
                      'Envoyer',
                      style: TextStyle(
                        color: context.select((ThemeProvider themeProvider) =>
                        themeProvider.currentTheme.secondaryHeaderColor),
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
