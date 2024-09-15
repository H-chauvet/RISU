import 'package:flutter/material.dart';

import 'contact_state.dart';

/// Contact page.
/// this page is used to display the contact information of the user
/// and the tickets that the user has created.
/// params:
/// [testTickets] - the tickets that the user has created.
class ContactPage extends StatefulWidget {
  final Map<String, List<dynamic>> testTickets;

  const ContactPage({
    super.key,
    this.testTickets = const {},
  });

  @override
  State<ContactPage> createState() => ContactPageState();
}
