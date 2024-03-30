import 'package:flutter/material.dart';
import 'package:risu/pages/contact/conversation_state.dart';

class ConversationPage extends StatefulWidget {
  final List<dynamic> tickets;

  const ConversationPage({
    super.key,
    required this.tickets,
  });

  @override
  State<ConversationPage> createState() => ConversationPageState();
}
