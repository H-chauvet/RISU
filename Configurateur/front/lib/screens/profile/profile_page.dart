import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:front/components/alert_dialog.dart';
import 'package:front/components/custom_footer.dart';
import 'package:front/components/custom_header.dart';
import 'package:front/network/informations.dart';
import 'package:front/screens/profile/profile_page_style.dart';
import 'package:front/services/size_service.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/styles/globalStyle.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/themes.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

/// ProfilePage
///
/// Page of the user's profil
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

/// ProfileState
///
class _ProfilePageState extends State<ProfilePage> {
  late String firstName = '';
  late String lastName = '';
  late DateTime createdDate = DateTime.now();
  late String formattedDate = '';
  late String company = '';
  String userMail = '';

  /// [Function] : Get the user's details in the database
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

    /// Récupère l'email de l'utilisateur dans le stockage local
    storageService.getUserMail().then((value) {
      userMail = value;
      MyAlertTest.checkSignInStatus(context);
      fetchUserDetails(userMail);
    });
  }

  /// [Function] : Show pop up to modify the user's name
  /// [initialFirstName] : User's first name
  /// [initialLastName] : User's last name
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
                  key: const Key("first-name"),
                  controller: firstNameController,
                  decoration: InputDecoration(
                      labelText: "Nouveau prénom", hintText: initialFirstName),
                ),
                const SizedBox(height: 10.0),
                TextField(
                  key: const Key("last-name"),
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
                key: const Key("cancel-edit-name"),
                style: TextStyle(
                  fontSize: SizeService().getScreenFormat(context) ==
                          ScreenFormat.desktop
                      ? desktopFontSize
                      : tabletFontSize,
                ),
              ),
            ),
            ElevatedButton(
              key: const Key("button-name"),
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

  /// [Function] : Check the token in the storage service
  /// [initialCompany] : Initial user's company
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
                  key: const Key("company"),
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
                key: const Key("cancel-edit-company"),
                style: TextStyle(
                  fontSize: SizeService().getScreenFormat(context) ==
                          ScreenFormat.desktop
                      ? desktopFontSize
                      : tabletFontSize,
                ),
              ),
            ),
            ElevatedButton(
              key: const Key("button-company"),
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

  /// [Function] : Show pop up to modify the user's mail
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
                  key: const Key("user-mail"),
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
                key: const Key("cancel-edit-mail"),
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

  /// [Function] : Show pop up to modify the user's password
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
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
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
                height: SizeService().getScreenFormat(context) ==
                        ScreenFormat.desktop
                    ? desktopDialogHeight * 1.25
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
                  ),
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
                  child:
                      const Text("Annuler", key: Key("cancel-edit-password")),
                ),
                ElevatedButton(
                  key: const Key("button-password"),
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
      },
    );
  }

  /// [Widget] : Build the user's profil page
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
            'Modifier votre profil à votre convenance !',
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
          Center(
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
                        style: TextStyle(
                          color: lightTheme.primaryColor,
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
                            style: TextStyle(
                              color: lightTheme.primaryColor,
                              fontSize: 26.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Verdana',
                            ),
                          ),
                          const SizedBox(width: 5.0),
                          InkWell(
                            key: const Key('edit-name'),
                            onTap: () async {
                              await showEditPopupName(
                                context,
                                firstName,
                                lastName,
                                (String newFirstName, String newLastName) {
                                  setState(() {
                                    firstName = newFirstName;
                                    lastName = newLastName;
                                  });
                                },
                              );
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
                              key: const Key('edit-mail'),
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
                              key: const Key('edit-company'),
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
                              key: const Key('edit-password'),
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
                        color: Provider.of<ThemeService>(context).isDark
                            ? darkTheme.primaryColor
                            : lightTheme.primaryColor,
                      ),
                    ),
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
                            child: Text(
                              "Retour à l'accueil",
                              style: TextStyle(
                                color: Provider.of<ThemeService>(context).isDark
                                    ? darkTheme.primaryColor
                                    : lightTheme.primaryColor,
                              ),
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
                              storageService.removeStorage('token');
                              storageService.removeStorage('tokenExpiration');
                              Fluttertoast.showToast(
                                msg: "Vous êtes bien déconnecté !",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.CENTER,
                              );
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
        ],
      ),
    );
  }
}
