import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:front/components/alert_dialog.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/network/informations.dart';
import 'package:front/services/storage_service.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Future<Map<String, dynamic>> fetchUserDetails(String email) async {
  final String apiUrl = "http://$serverIp:3000/api/auth/user-details/$email";

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> userDetails = json.decode(response.body);
      debugPrint('User details: $userDetails');
      return userDetails;
    } else {
      debugPrint('Failed to fetch user details. Status code: ${response.statusCode}');
      return {};
    }
  } catch (error) {
    debugPrint('Error fetching user details: $error');
    return {};
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String firstName;
  late String lastName;
  late DateTime createdDate;
  late String formattedDate;
  late String company;

  @override
  void initState() {
    super.initState();
    MyAlertTest.checkSignInStatus(context);
    fetchUserDetails(userMail);
  }

  Future<void> showEditPopupName(BuildContext context, String initialFirstName, String initialLastName, Function(String, String) onEdit) async {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Modifier"),
        content: Container(
          height: 120.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: firstNameController,
                decoration: InputDecoration(labelText: "Nouveau prénom", hintText: initialFirstName),
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: lastNameController,
                decoration: InputDecoration(labelText: "Nouveau nom", hintText: initialLastName),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () async {
              final String apiUrl = "http://$serverIp:3000/api/auth/update-details/$userMail";
              var body = {
                'firstName': firstNameController.text,
                'lastName': lastNameController.text,
              };

              var response = await http.post(
                Uri.parse(apiUrl),
                body: body,
              );

              if (response.statusCode == 200) {
                Fluttertoast.showToast(
                    msg: 'Modification effectuée avec succès',
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 3,
                  );
              } else {
                Fluttertoast.showToast(
                    msg: "Erreur durant l'envoi la modification des informations",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 3,
                    backgroundColor: Colors.red
                  );
              }

              onEdit(firstNameController.text, lastNameController.text);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            child: const Text("Modifier"),
          ),
        ],
      );
    },
  );
}

Future<void> showEditPopupCompany(BuildContext context, String initialCompany, Function(String) onEdit) async {
  TextEditingController companyController = TextEditingController();

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Modifier"),
        content: Container(
          height: 60.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: companyController,
                decoration: InputDecoration(labelText: "Nouveau nom d'entreprise", hintText: initialCompany),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () async {
              final String apiUrl = "http://$serverIp:3000/api/auth/update-company/$userMail";
              var body = {
                'company': companyController.text,
              };

              var response = await http.post(
                Uri.parse(apiUrl),
                body: body,
              );

              if (response.statusCode == 200) {
                Fluttertoast.showToast(
                    msg: 'Entreprise modifiée avec succès',
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 3,
                  );
              } else {
                Fluttertoast.showToast(
                    msg: "Erreur durant l'envoi la modification de l'entreprise",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 3,
                    backgroundColor: Colors.red
                  );
              }
              onEdit(companyController.text);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            child: const Text("Modifier"),
          ),
        ],
      );
    },
  );
}

Future<void> showEditPopupMail(BuildContext context, String initialMail, Function(String) onEdit) async {
  TextEditingController mailController = TextEditingController();

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Modifier"),
        content: Container(
          height: 60.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: mailController,
                decoration: InputDecoration(labelText: "Nouveau mail", hintText: initialMail),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () async {
              final String apiUrl = "http://$serverIp:3000/api/auth/update-mail";
              var body = {
                'oldMail': userMail,
                'newMail': mailController.text,
              };

              var response = await http.post(
                Uri.parse(apiUrl),
                body: body,
              );

              if (response.statusCode == 200) {
                Fluttertoast.showToast(
                    msg: 'Email modifié avec succès',
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 3,
                  );
              } else {
                Fluttertoast.showToast(
                    msg: "Erreur durant l'envoi la modification de l'email",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 3,
                    backgroundColor: Colors.red
                  );
              }
              onEdit(mailController.text);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            child: const Text("Modifier"),
          ),
        ],
      );
    },
  );
}

Future<void> showEditPopupPassword(BuildContext context, String initialPassword, Function(String) onEdit) async {
  TextEditingController passwordController = TextEditingController();

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Modifier"),
        content: Container(
          height: 60.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: "Nouveau mot de passe", hintText: initialPassword),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () async {
              final String apiUrl = "http://$serverIp:3000/api/auth/update-password/$userMail";
              var body = {
                'password': passwordController.text,
              };

              var response = await http.post(
                Uri.parse(apiUrl),
                body: body,
              );

              if (response.statusCode == 200) {
                Fluttertoast.showToast(
                    msg: 'Mot de passe modifié avec succès',
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 3,
                  );
              } else {
                Fluttertoast.showToast(
                    msg: "Erreur durant l'envoi la modification du mot de passe",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 3,
                    backgroundColor: Colors.red
                  );
              }

              onEdit(passwordController.text);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            child: const Text("Modifier"),
          ),
        ],
      );
    },
  );
}




  Future<void> fetchUserDetails(String email) async {
    final String apiUrl = "http://$serverIp:3000/api/auth/user-details/$email";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> userDetails = json.decode(response.body);
        debugPrint('User details: $userDetails');

        setState(() {
          firstName = userDetails['firstName'];
          lastName = userDetails['lastName'];
          createdDate = DateTime.parse(userDetails['createdAt']);
          formattedDate = DateFormat('dd/MM/yyyy').format(createdDate);
          company = userDetails['company'];
        });
      } else {
        debugPrint('Failed to fetch user details. Status code: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('Error fetching user details: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        'Mon profil',
        context: context,
      ),
      body: Center(
        child: Container(
          width: 700.0,
          height: 600.0,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 231, 223, 223),
            borderRadius: BorderRadius.circular(30.0),
            boxShadow: [
              BoxShadow(
                color: const Color(0xff4682B4).withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    firstName,
                    style: const TextStyle(
                      color: Color(0xff4682B4),
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Verdana',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Row(
                    children: [
                      Text(
                        lastName,
                        style: const TextStyle(
                          color: Color(0xff4682B4),
                          fontSize: 26.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Verdana',
                        ),
                      ),
                      const SizedBox(width: 5.0),
                      InkWell(
                        onTap: () async {
                          await showEditPopupName(context, firstName, lastName, (String newFirstName, String newLastName) {
                            setState(() {
                              firstName = newFirstName;
                              lastName = newLastName;
                            });
                          });
                        },
                        child: const Icon(
                          Icons.edit,
                          color: Colors.grey,
                          size: 26.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 90),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text(
                      'E-mail',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Verdana',
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Row(
                        children: [
                          Text(
                            userMail,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Verdana',
                            ),
                          ),
                          const SizedBox(width: 5.0),
                          InkWell(
                            onTap: () async {
                              await showEditPopupMail(context, userMail, (String newMail) {
                                setState(() {
                                  userMail = newMail;
                                });
                              });
                            },
                            child: const Icon(
                              Icons.edit,
                              color: Colors.grey,
                              size: 18.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(
                color: Colors.black,
                thickness: 2,
                indent: 20,
                endIndent: 20,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text(
                      'Entreprise',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Verdana',
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Row(
                      children: [
                        Text(
                          company,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Verdana',
                          ),
                        ),
                        const SizedBox(width: 5.0),
                        InkWell(
                          onTap: () async {
                          await showEditPopupCompany(context, company, (String newCompany) {
                            setState(() {
                              company = newCompany;
                            });
                          });
                        },
                          child: const Icon(
                            Icons.edit,
                            color: Colors.grey,
                            size: 18.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              const Divider(
                color: Colors.black,
                thickness: 2,
                indent: 20,
                endIndent: 20,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text(
                      'Mot de passe',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Verdana',
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Row(
                      children: [
                        const Text(
                          '*********',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Verdana',
                          ),
                        ),
                        const SizedBox(width: 5.0),
                        InkWell(
                          onTap: () async {
                              await showEditPopupPassword(context, "", (String newPassword) {
                                setState(() {});
                              });
                            },
                          child: const Icon(
                            Icons.edit,
                            color: Colors.grey,
                            size: 18.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          context.go("/");
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: const Text(
                          "Retour à l'accueil",
                        ),
                        
                      ),
                    ),
                  ),
                  Text(
                    'Créé le : $formattedDate',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Verdana',
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          userMail = '';
                          token = '';
                          context.go("/");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: const Text(
                          "Déconnexion",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
