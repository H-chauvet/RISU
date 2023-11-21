import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/components/footer.dart';
import 'package:front/network/informations.dart';
import 'package:front/screens/user-list/user-component.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    fetchMessages();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      appBar: CustomAppBar(
        'Gestion des utilisateurs',
        context: context,
      ),
      body:
        ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final product = users[index];
            return UserCard(
              user: product,
            );
          },
        ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
