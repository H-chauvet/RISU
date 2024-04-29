import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:front/components/alert_dialog.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/network/informations.dart';
import 'package:front/screens/profile/profile_page_style.dart';
import 'package:front/services/size_service.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/styles/globalStyle.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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
  String userMail = '';

  Future<void> fetchUserDetails(String email) async {
    final String apiUrl = "http://$serverIp:3000/api/auth/user-details/$email";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> userDetails = json.decode(response.body);

        setState(() {
          firstName = userDetails['firstName'];
          lastName = userDetails['lastName'];
          createdDate = DateTime.parse(userDetails['createdAt']);
          formattedDate = DateFormat('dd/MM/yyyy').format(createdDate);
          company = userDetails['company'];
        });
      } else {
        debugPrint(
            'Failed to fetch user details. Status code: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('Error fetching user details: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    storageService.getUserMail().then((value) {
      userMail = value;
      MyAlertTest.checkSignInStatus(context);
      fetchUserDetails(userMail);
    });
  }

  Future<void> showEditPopupName(BuildContext context, String initialFirstName,
      String initialLastName, Function(String, String) onEdit) async {
    TextEditingController firstNameController = TextEditingController();
    TextEditingController lastNameController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Modifier",
            style: TextStyle(
              fontSize:
                  SizeService().getScreenFormat(context) == ScreenFormat.desktop
                      ? desktopFontSize
                      : tabletFontSize,
            ),
          ),
          content: Container(
            height:
                SizeService().getScreenFormat(context) == ScreenFormat.desktop
                    ? desktopDialogHeight
                    : tabletDialogHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: firstNameController,
                  decoration: InputDecoration(
                      labelText: "Nouveau prénom", hintText: initialFirstName),
                ),
                const SizedBox(height: 10.0),
                TextField(
                  controller: lastNameController,
                  decoration: InputDecoration(
                      labelText: "Nouveau nom", hintText: initialLastName),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text(
                "Annuler",
                style: TextStyle(
                  fontSize: SizeService().getScreenFormat(context) ==
                          ScreenFormat.desktop
                      ? desktopFontSize
                      : tabletFontSize,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final String apiUrl =
                    "http://$serverIp:3000/api/auth/update-details/$userMail";
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
                      msg:
                          "Erreur durant l'envoi la modification des informations",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 3,
                      backgroundColor: Colors.red);
                }

                onEdit(firstNameController.text, lastNameController.text);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text(
                "Modifier",
                style: TextStyle(
                  fontSize: SizeService().getScreenFormat(context) ==
                          ScreenFormat.desktop
                      ? desktopFontSize
                      : tabletFontSize,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> showEditPopupCompany(BuildContext context, String initialCompany,
      Function(String) onEdit) async {
    TextEditingController companyController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Modifier",
            style: TextStyle(
              fontSize:
                  SizeService().getScreenFormat(context) == ScreenFormat.desktop
                      ? desktopFontSize
                      : tabletFontSize,
            ),
          ),
          content: Container(
            height:
                SizeService().getScreenFormat(context) == ScreenFormat.desktop
                    ? desktopDialogHeight
                    : tabletDialogHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: companyController,
                  decoration: InputDecoration(
                      labelText: "Nouveau nom d'entreprise",
                      hintText: initialCompany),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text(
                "Annuler",
                style: TextStyle(
                  fontSize: SizeService().getScreenFormat(context) ==
                          ScreenFormat.desktop
                      ? desktopFontSize
                      : tabletFontSize,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final String apiUrl =
                    "http://$serverIp:3000/api/auth/update-company/$userMail";
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
                      msg:
                          "Erreur durant l'envoi la modification de l'entreprise",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 3,
                      backgroundColor: Colors.red);
                }
                onEdit(companyController.text);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text(
                "Modifier",
                style: TextStyle(
                  fontSize: SizeService().getScreenFormat(context) ==
                          ScreenFormat.desktop
                      ? desktopFontSize
                      : tabletFontSize,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> showEditPopupMail(BuildContext context, String? initialMail,
      Function(String) onEdit) async {
    TextEditingController mailController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Modifier",
            style: TextStyle(
              fontSize:
                  SizeService().getScreenFormat(context) == ScreenFormat.desktop
                      ? desktopFontSize
                      : tabletFontSize,
            ),
          ),
          content: Container(
            height:
                SizeService().getScreenFormat(context) == ScreenFormat.desktop
                    ? desktopDialogHeight
                    : tabletDialogHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: mailController,
                  decoration: InputDecoration(
                      labelText: "Nouveau mail", hintText: initialMail),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text(
                "Annuler",
                style: TextStyle(
                  fontSize: SizeService().getScreenFormat(context) ==
                          ScreenFormat.desktop
                      ? desktopFontSize
                      : tabletFontSize,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final String apiUrl =
                    "http://$serverIp:3000/api/auth/update-mail";
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
                      backgroundColor: Colors.red);
                }
                onEdit(mailController.text);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text(
                "Modifier",
                style: TextStyle(
                  fontSize: SizeService().getScreenFormat(context) ==
                          ScreenFormat.desktop
                      ? desktopFontSize
                      : tabletFontSize,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> showEditPopupPassword(BuildContext context,
      String initialPassword, Function(String) onEdit) async {
    String password = '';
    String validedPassword = '';
    bool obscurePassword = true;
    bool obscureConfirmPassword = true;
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, setState) {
          return AlertDialog(
            title: Text(
              "Modifier",
              style: TextStyle(
                fontSize: SizeService().getScreenFormat(context) ==
                        ScreenFormat.desktop
                    ? desktopFontSize
                    : tabletFontSize,
              ),
            ),
            content: Container(
              height:
                  SizeService().getScreenFormat(context) == ScreenFormat.desktop
                      ? desktopDialogHeight
                      : tabletDialogHeight,
              child: Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        key: const Key('password'),
                        obscureText: obscurePassword,
                        decoration: InputDecoration(
                            hintText: 'Entrez votre mot de passe',
                            labelText: 'Mot de passe',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            suffixIcon: IconButton(
                                icon: Icon(
                                  obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    obscurePassword = !obscurePassword;
                                  });
                                })),
                        onChanged: (String? value) {
                          password = value!;
                        },
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez remplir ce champ';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        key: const Key('confirm-password'),
                        obscureText: obscureConfirmPassword,
                        decoration: InputDecoration(
                            hintText: 'Validation du mot de passe',
                            labelText: 'Valider le mot de passe',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            suffixIcon: IconButton(
                                icon: Icon(
                                  obscureConfirmPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    obscureConfirmPassword =
                                        !obscureConfirmPassword;
                                  });
                                })),
                        onChanged: (String? value) {
                          validedPassword = value!;
                        },
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez remplir ce champ';
                          }
                          if (value != password) {
                            return 'Les mots de passe ne correspondent pas';
                          }
                          return null;
                        },
                      ),
                    ],
                  )),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: Text("Annuler",
                    style: TextStyle(
                        fontSize: SizeService().getScreenFormat(context) ==
                                ScreenFormat.desktop
                            ? desktopFontSize
                            : tabletFontSize)),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate() &&
                      password == validedPassword) {
                    final String apiUrl =
                        "http://$serverIp:3000/api/auth/update-password/$userMail";
                    var body = {
                      'password': password,
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
                          msg:
                              "Erreur durant l'envoi la modification du mot de passe",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 3,
                          backgroundColor: Colors.red);
                    }
                    onEdit(password);
                    Navigator.of(context).pop();
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: Text(
                  "Modifier",
                  style: TextStyle(
                    fontSize: SizeService().getScreenFormat(context) ==
                            ScreenFormat.desktop
                        ? desktopFontSize
                        : tabletFontSize,
                  ),
                ),
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenFormat screenFormat = SizeService().getScreenFormat(context);

    return Scaffold(
      appBar: CustomAppBar(
        'Mon profil',
        context: context,
      ),
      body: Center(
        child: Container(
          width: screenFormat == ScreenFormat.desktop
              ? desktopCardWidth
              : tabletCardWidth,
          height: screenFormat == ScreenFormat.desktop
              ? desktopCardHeight
              : tabletCardHeight,
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
                    style: TextStyle(
                      color: Color(0xff4682B4),
                      fontSize: screenFormat == ScreenFormat.desktop
                          ? desktopNameFontSize
                          : tabletNameFontSize,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Verdana',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Row(
                    children: [
                      Text(
                        lastName,
                        style: TextStyle(
                          color: Color(0xff4682B4),
                          fontSize: screenFormat == ScreenFormat.desktop
                              ? desktopNameFontSize
                              : tabletNameFontSize,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Verdana',
                        ),
                      ),
                      const SizedBox(width: 5.0),
                      InkWell(
                        onTap: () async {
                          await showEditPopupName(context, firstName, lastName,
                              (String newFirstName, String newLastName) {
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
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      'E-mail',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenFormat == ScreenFormat.desktop
                            ? desktopFontSize
                            : tabletFontSize,
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
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: screenFormat == ScreenFormat.desktop
                                ? desktopFontSize
                                : tabletFontSize,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Verdana',
                          ),
                        ),
                        const SizedBox(width: 5.0),
                        InkWell(
                          onTap: () async {
                            await showEditPopupMail(context, userMail,
                                (String newMail) {
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
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      'Entreprise',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenFormat == ScreenFormat.desktop
                            ? desktopFontSize
                            : tabletFontSize,
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
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: screenFormat == ScreenFormat.desktop
                                ? desktopFontSize
                                : tabletFontSize,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Verdana',
                          ),
                        ),
                        const SizedBox(width: 5.0),
                        InkWell(
                          onTap: () async {
                            await showEditPopupCompany(context, company,
                                (String newCompany) {
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
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      'Mot de passe',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenFormat == ScreenFormat.desktop
                            ? desktopFontSize
                            : tabletFontSize,
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
                          '*********',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: screenFormat == ScreenFormat.desktop
                                ? desktopFontSize
                                : tabletFontSize,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Verdana',
                          ),
                        ),
                        const SizedBox(width: 5.0),
                        InkWell(
                          onTap: () async {
                            await showEditPopupPassword(context, "",
                                (String newPassword) {
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
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  onPressed: () {
                    context.go("/my-container");
                  },
                  child: Text(
                    "Mes sauvegardes",
                    style: TextStyle(
                      fontSize: screenFormat == ScreenFormat.desktop
                          ? desktopFontSize
                          : tabletFontSize,
                    ),
                  )),
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
                        child: Text(
                          "Retour à l'accueil",
                          style: TextStyle(
                              fontSize: screenFormat == ScreenFormat.desktop
                                  ? desktopFontSize
                                  : tabletFontSize),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'Créé le : $formattedDate',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: screenFormat == ScreenFormat.desktop
                          ? desktopDateFontSize
                          : tabletDateFontSize,
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
                          storageService.removeStorage('token');
                          storageService.removeStorage('tokenExpiration');
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
                        child: Text(
                          "Déconnexion",
                          style: TextStyle(
                              fontSize: screenFormat == ScreenFormat.desktop
                                  ? desktopFontSize
                                  : tabletFontSize),
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
