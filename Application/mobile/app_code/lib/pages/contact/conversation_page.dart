import 'package:flutter/material.dart';
import 'package:risu/pages/contact/conversation_state.dart';

class ConversationPage extends StatefulWidget {
  final List<dynamic> tickets;
  final bool isOpen;

  const ConversationPage({
    super.key,
    required this.tickets,
    required this.isOpen,
  });

  @override
  State<ConversationPage> createState() => ConversationPageState();
}
