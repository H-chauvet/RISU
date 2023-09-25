import 'package:flutter/material.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:http/http.dart' as http;


class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}


void sendFormData(String name, String email, String message) async {
  var body = {
    'name': name,
    'email': email,
    'message': message,
  };

  var response = await http.post(
    Uri.parse('http://193.70.89.108:3000/contact'),
    body: body,
  );

  if (response.statusCode == 200) {
    print('Code 200, données envoyées.');
  } else {
    print('Erreur lors de l\'envoi des données : ${response.statusCode}');
  }
}


class _ContactPageState extends State<ContactPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _name = "";
  String _email = "";
  String _message = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          'Contact',
          context: context,
        ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Nom Prénom'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Veuillez entrer votre nom et prénom';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _name = value!;
                      },
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Veuillez entrer votre email';
                        } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(value)) {
                          return 'Veuillez entrer un email valide';
                        }
                      },
                      onSaved: (value) {
                        _email = value!;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Message'),
                maxLines: 5, // Nombre de lignes à afficher
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
              SizedBox(height: 16.0), // Ajout d'espace vertical entre le champ message et le bouton envoyer
              ElevatedButton(
                child: Text('Envoyer'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    sendFormData(_name, _email, _message);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
