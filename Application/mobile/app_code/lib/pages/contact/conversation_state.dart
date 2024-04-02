import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/utils/providers/theme.dart';

import 'package:risu/globals.dart';
import 'conversation_page.dart';

class ConversationPageState extends State<ConversationPage> {
  List<dynamic> tickets = [];

  @override
  void initState() {
    super.initState();
    tickets = widget.tickets;
  }

  String formatDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final scrollController = ScrollController();

    return Scaffold(
      appBar: MyAppBar(
        curveColor: context.select((ThemeProvider themeProvider) =>
            themeProvider.currentTheme.secondaryHeaderColor),
        showBackButton: false,
        showLogo: true,
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: context.select((ThemeProvider themeProvider) =>
          themeProvider.currentTheme.colorScheme.background),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Column(
          children: [
            Text(
              tickets[0]["title"],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: themeProvider.currentTheme.primaryColor,
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                reverse: true,
                itemCount: tickets.length,
                itemBuilder: (BuildContext context, int index) {
                  final currentTicket = tickets[tickets.length - 1 - index];
                  return Align(
                    alignment: (currentTicket["creatorId"] ==
                            userInformation?.ID
                        ? Alignment.topRight
                        : Alignment.topLeft),
                    child: Card(
                      elevation: 5,
                      margin: (currentTicket["creatorId"] ==
                              userInformation?.ID
                          ? const EdgeInsets.only(left: 32, top: 8, bottom: 8)
                          : const EdgeInsets.only(
                              right: 32, top: 8, bottom: 8)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: (currentTicket["creatorId"] ==
                              userInformation?.ID
                          ? themeProvider.currentTheme.primaryColor
                              .withOpacity(1)
                          : themeProvider.currentTheme.cardColor),
                      //themeProvider.currentTheme.cardColor,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentTicket["content"],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: (currentTicket["creatorId"] ==
                                      userInformation?.ID
                                    ? themeProvider
                                        .currentTheme.colorScheme.background
                                    : themeProvider
                                        .currentTheme
                                        .inputDecorationTheme
                                        .labelStyle
                                        ?.color),
                              ),
                            ),
                            Text(
                              formatDateTime(currentTicket["createdAt"]),
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: (currentTicket["creatorId"] ==
                                          userInformation?.ID
                                      ? themeProvider
                                          .currentTheme.colorScheme.background
                                      : themeProvider
                                          .currentTheme
                                          .inputDecorationTheme
                                          .labelStyle
                                          ?.color)),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                const Expanded(
                  flex: 7,
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Write here',
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.all(8)),
                Expanded(
                  flex: 1,
                  child: FloatingActionButton.extended(
                    onPressed: () async {},
                    backgroundColor: themeProvider.currentTheme.primaryColor,
                    label: const Icon(Icons.send),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
