import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:front/components/custom_footer.dart';
import 'package:front/components/custom_header.dart';
import 'package:front/network/informations.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/themes.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  _ContactPageState createState() => _ContactPageState();
}

void sendFormData(
  GlobalKey<FormState> formKey,
  String surname,
  String name,
  String email,
  String message,
) async {
  var body = {
    'firstName': surname,
    'lastName': name,
    'email': email,
    'message': message,
  };

  var response = await http.post(
    Uri.parse('http://$serverIp:3000/api/contact'),
    body: body,
  );

  if (response.statusCode == 200) {
    print('Code 200, données envoyées.');
    Fluttertoast.showToast(
      msg: 'Message envoyé avec succès',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 3,
    );
    formKey.currentState!.reset();
  } else {
    print('Erreur lors de l\'envoi des données : ${response.statusCode}');
    Fluttertoast.showToast(
        msg: "Erreur durant l'envoi du message",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.red);
  }
}

class _ContactPageState extends State<ContactPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _content = "";
  String _title = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FooterView(
        footer: Footer(
          child: CustomFooter(context: context),
        ),
        children: [
          LandingAppBar(context: context),
          Text(
            'Mes tickets',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 35,
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              color: Provider.of<ThemeService>(context).isDark
                  ? darkTheme.secondaryHeaderColor
                  : lightTheme.secondaryHeaderColor,
              shadows: [
                Shadow(
                  color: Provider.of<ThemeService>(context).isDark
                      ? darkTheme.secondaryHeaderColor
                      : lightTheme.secondaryHeaderColor,
                  offset: const Offset(0.75, 0.75),
                  blurRadius: 1.5,
                ),
              ],
            ),
          ),
          const SizedBox(height: 100),
          Padding(
            padding: const EdgeInsets.only(right: 256, left: 256),
            child: Form(
              key: _formKey,
              child: Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text("AAA"),
                      Text("BBB"),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: const SizedBox(
                      height: 512,
                      width: 1,
                      child: VerticalDivider(
                        thickness: 1,
                      ),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Text("AZERTY"),
                      /*Container(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Titre',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer votre titre';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _title = value!;
                          },
                        ),
                      ),
                      const SizedBox(height: 32),*/
                    ],
                  )
                  /*Row(
                    children: <Widget>[

                      const SizedBox(width: 16.0),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Nom',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer votre nom';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _name = value!;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Veuillez entrer votre email';
                      } else if (!RegExp(
                              r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                          .hasMatch(value)) {
                        return 'Veuillez entrer un email valide';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      _email = value!;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    maxLines: 5,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Veuillez entrer votre message';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _message = value!;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        sendFormData(
                            _formKey, _surname, _name, _email, _message);
                      } else {}
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 190, 189, 189),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: Text(
                      'Envoyer',
                      style: TextStyle(
                        color: Provider.of<ThemeService>(context).isDark
                            ? darkTheme.primaryColor
                            : lightTheme.primaryColor,
                        fontSize: 18,
                      ),
                    ),
                  ),*/
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
