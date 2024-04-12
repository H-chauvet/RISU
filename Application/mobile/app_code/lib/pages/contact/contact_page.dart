import 'package:flutter/material.dart';

import 'contact_state.dart';

class ContactPage extends StatefulWidget {
  final Map<String, List<dynamic>> testTickets;

  const ContactPage({
    super.key,
    this.testTickets = const {},
  });

  static const String routeName = '/contact';

  @override
  State<ContactPage> createState() => ContactPageState();
}
