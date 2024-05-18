import 'package:flutter/material.dart';
import 'package:front/components/tickets_page.dart';

/// ContactPage
///
/// Page where you can contact the Risu team
class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  /// [Widget] : build the contact page
  @override
  Widget build(BuildContext context) {
    return const TicketsPage(isAdmin: false);
  }
}
