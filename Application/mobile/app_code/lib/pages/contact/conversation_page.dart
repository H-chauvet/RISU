import 'package:flutter/material.dart';
import 'package:risu/pages/contact/conversation_state.dart';

/// ConversationPage
/// This is the main page for the conversation.
/// It will display the conversation between the user and the support team.
/// It will also allow the user to send messages to the support team.
/// params:
/// [tickets] - The list of tickets that are being displayed.
/// [isOpen] - A boolean value that determines if the ticket is open or closed.
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
