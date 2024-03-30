import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/utils/providers/theme.dart';

import 'conversation_page.dart';

class ConversationPageState extends State<ConversationPage> {
  List<dynamic> tickets = [];

  @override
  void initState() {
    super.initState();
    tickets = widget.tickets;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: MyAppBar(
        curveColor: context.select((ThemeProvider themeProvider) =>
            themeProvider.currentTheme.secondaryHeaderColor),
        showBackButton: false,
        showLogo: true,
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: context.select((ThemeProvider themeProvider) =>
          themeProvider.currentTheme.colorScheme.background),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: Text(tickets.length.toString()),
      ),
    );
  }
}
