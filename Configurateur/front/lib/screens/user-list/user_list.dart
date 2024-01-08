import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:front/components/alert_dialog.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/components/footer.dart';
import 'package:front/network/informations.dart';
import 'package:front/screens/user-list/user-component.dart';
import 'package:front/screens/user-list/user-component-web.dart';
import 'package:front/services/storage_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List<User> users = [];
  List<UserMobile> users_mobile = [];
  bool jwtToken = false;

  @override
  void initState() {
    super.initState();
    fetchUser();
    fetchUserMobile();
    if (token != "") {
      jwtToken = true;
    } else {
      jwtToken = false;
    }
  }

  Future<void> deleteUserWeb(User user) async {
    final Uri url = Uri.parse("http://${serverIp}:3000/api/auth/delete");
    final response = await http.post(
      url,
      body: json.encode({'email': user.email}),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: 'utilisateur supprimé avec succès',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      fetchUser();
    } else {
      Fluttertoast.showToast(
        msg:
            'Erreur lors de la suppression du utilisateur: ${response.statusCode}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  Future<void> deleteUserMobile(UserMobile user) async {
    final Uri url = Uri.parse("http://localhost:8080/api/dev/user/delete");
    final response = await http.post(
      url,
      body: json.encode({'email': user.email}),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: 'utilisateur supprimé avec succès',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      fetchUserMobile();
    } else {
      Fluttertoast.showToast(
        msg:
            'Erreur lors de la suppression du utilisateur: ${response.statusCode}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  Future<void> fetchUser() async {
    final response =
        await http.get(Uri.parse('http://${serverIp}:3000/api/auth/listAll'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> usersData = responseData["user"];
      setState(() {
        users = usersData.map((data) => User.fromJson(data)).toList();
      });
    } else {
      // Fluttertoast.showToast(
      //   msg: 'Erreur lors de la récupération: ${response.statusCode}',
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.CENTER,
      // );
    }
  }

  Future<void> fetchUserMobile() async {
    final response = await http
        .get(Uri.parse('http://${serverIp}:8080/api/dev/user/listall'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> usersData = responseData["user"];
      setState(() {
        users_mobile =
            usersData.map((data) => UserMobile.fromJson(data)).toList();
      });
    } else {
      // Fluttertoast.showToast(
      //   msg: 'Erreur lors de la récupération: ${response.statusCode}',
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.CENTER,
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      appBar: CustomAppBar(
        'Gestion des utilisateurs',
        context: context,
      ),
      body: jwtToken
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Web :",
                      style: TextStyle(
                        color: Color.fromRGBO(70, 130, 180, 1),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationThickness: 2.0,
                        decorationStyle: TextDecorationStyle.solid,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final product = users[index];
                      return UserCard(
                        user: product,
                        onDelete: deleteUserWeb,
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Mobile :",
                      style: TextStyle(
                        color: Color.fromRGBO(70, 130, 180, 1),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationThickness: 2.0,
                        decorationStyle: TextDecorationStyle.solid,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: users_mobile.length,
                    itemBuilder: (context, index) {
                      final product = users_mobile[index];
                      return UserMobileCard(
                        user: product,
                        onDelete: deleteUserMobile,
                      );
                    },
                  ),
                ],
              ),
            )
          : const CustomAlertDialog(
              title: "Connexion requise",
              message: 'Vous devez être connecté à un compte pour poursuivre.',
            ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
