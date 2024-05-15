import 'package:flutter/material.dart';
import 'package:front/components/alert_dialog.dart';
import 'package:front/components/tickets_page.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  bool jwtToken = false;

  @override
  void initState() {
    super.initState();
    MyAlertTest.checkSignInStatusAdmin(context);
  }

  @override
  Widget build(BuildContext context) {
    return const TicketsPage(isAdmin: true);
  }
}
