import 'package:flutter/material.dart';
import 'package:front/components/tickets_page.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    return const TicketsPage(isAdmin: false);
  }
}
