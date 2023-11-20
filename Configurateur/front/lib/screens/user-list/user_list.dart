import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/components/footer.dart';
import 'package:front/network/informations.dart';
import 'package:front/screens/user-list/user-component.dart';
import 'package:http/http.dart' as http;

class UserListPage extends StatefulWidget {
  const UserListPage({Key? key}) : super(key: key);

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  List<User> messages = [];

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  Future<void> fetchMessages() async {
    final response =
        await http.get(Uri.parse('http://localhost:8080/api/dev/user/listall'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> messagesData = responseData["message"];
      setState(() {
        messages = messagesData.map((data) => User.fromJson(data)).toList();
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
        'Gestion des messages',
        context: context,
      ),
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return Text(messages[index].firstName);
        },
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
