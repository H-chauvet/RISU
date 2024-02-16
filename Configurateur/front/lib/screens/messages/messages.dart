import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:front/components/alert_dialog.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/components/footer.dart';
import 'package:front/network/informations.dart';
import 'package:front/screens/messages/messages_card.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:front/services/storage_service.dart';
import 'package:http/http.dart' as http;

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  List<Message> messages = [];
  bool jwtToken = false;

  @override
  void initState() {
    super.initState();
    fetchMessages();
    MyAlertTest.checkSignInStatusAdmin(context);
  }

  Future<void> deleteMessage(Message message) async {
    final Uri url = Uri.parse("http://${serverIp}:3000/api/messages/delete");
    final response = await http.post(
      url,
      body: json.encode({'id': message.id}),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: 'Message supprimé avec succès',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      fetchMessages();
    } else {
      Fluttertoast.showToast(
        msg: 'Erreur lors de la suppression du message: ${response.statusCode}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  Future<void> fetchMessages() async {
    final response =
        await http.get(Uri.parse('http://${serverIp}:3000/api/messages/list'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> messagesData = responseData["messages"];
      setState(() {
        messages = messagesData.map((data) => Message.fromJson(data)).toList();
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
    return Scaffold(
      appBar: CustomAppBar(
        'Gestion des messages',
        context: context,
      ),
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final product = messages[index];
          return MessageCard(
            message: product,
            onDelete: deleteMessage,
          );
        },
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
