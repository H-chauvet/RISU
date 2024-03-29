import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:front/components/alert_dialog.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/components/footer.dart';
import 'package:front/network/informations.dart';
import 'package:front/screens/container-list/container_web.dart';
import 'package:front/screens/messages/messages_card.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:front/screens/user-list/user-component-web.dart';
import 'package:front/screens/user-list/user-component.dart';
import 'package:front/services/storage_service.dart';
import 'package:http/http.dart' as http;

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
    MyAlertTest.checkSignInStatusAdmin(context);
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
      Fluttertoast.showToast(
        msg: 'Erreur lors de la récupération: ${response.statusCode}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
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
      Fluttertoast.showToast(
        msg: 'Erreur lors de la récupération: ${response.statusCode}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: CustomAppBar(
          'Gestion des utilisateurs',
          context: context,
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              const SliverAppBar(
                backgroundColor: Colors.white,
                floating: true,
                bottom: TabBar(
                  tabs: [
                    Tab(
                      child: Text(
                        'Utilisateurs Web',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Utilisateurs Mobile',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                  indicatorColor: Colors.blue,
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
              ),
            ],
          ),
        ),
        bottomNavigationBar: const CustomBottomNavigationBar(),
      ),
    );
  }
}
