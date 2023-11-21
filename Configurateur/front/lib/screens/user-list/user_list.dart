import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/components/footer.dart';
import 'package:front/network/informations.dart';
import 'package:front/screens/user-list/user-component.dart';
import 'package:front/screens/user-list/user-component-web.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class tmp extends StatelessWidget {
  late List<UserMobile> users_mobile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: users_mobile.length,
        itemBuilder: (context, index) {
          final product = users_mobile[index];
          return UserMobileCard(
            user: product,
          );
        },
      ),
    );
  }
}

class _MessagePageState extends State<MessagePage> {
  List<User> users = [];
  List<UserMobile> users_mobile = [];

  @override
  void initState() {
    super.initState();
    fetchMessages();
    fetchMessagesMobile();
  }

  Future<void> fetchMessages() async {
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

  Future<void> fetchMessagesMobile() async {
    final response =
        await http.get(Uri.parse('http://localhost:8080/api/dev/user/listall'));
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20,),
            const Padding(
              padding: EdgeInsets.all(8.0), // Adjust the padding as needed
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
            const SizedBox(height: 20,),
            ListView.builder(
              shrinkWrap:
                  true,
              itemCount: users.length,
              itemBuilder: (context, index) {
                final product = users[index];
                return UserCard(
                  user: product,
                );
              },
            ),
            const SizedBox(height: 20,),
            const Padding(
              padding: EdgeInsets.all(8.0), // Adjust the padding as needed
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
            const SizedBox(height: 20,),
            ListView.builder(
              shrinkWrap: true,
              itemCount: users_mobile.length,
              itemBuilder: (context, index) {
                final product = users_mobile[index];
                return UserMobileCard(
                  user: product,
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
