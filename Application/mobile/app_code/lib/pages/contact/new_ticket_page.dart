import 'package:flutter/material.dart';

import 'new_ticket_state.dart';

/// New ticket page.
/// this page is used to create a new ticket.
/// It contains a form to fill in the ticket details.
/// params:
/// [key] - key to identify the widget.
/// returns:
/// [StatefulWidget] - new ticket page.
class NewTicketPage extends StatefulWidget {
  const NewTicketPage({
    super.key,
  });

  @override
  State<NewTicketPage> createState() => NewTicketState();
}
