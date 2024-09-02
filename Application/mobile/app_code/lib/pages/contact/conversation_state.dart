import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/components/loader.dart';
import 'package:risu/globals.dart';
import 'package:risu/utils/errors.dart';
import 'package:risu/utils/providers/theme.dart';
import 'package:risu/utils/time.dart';

import 'conversation_page.dart';

/// State class for the [ConversationPage] widget.
/// It contains the logic for the conversation page.
/// It is used to manage the state of the conversation page.
class ConversationPageState extends State<ConversationPage> {
  List<dynamic> tickets = [];
  bool isOpen = false;
  TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    tickets = widget.tickets;
    isOpen = widget.isOpen;
  }

  @override
  void dispose() {
    super.dispose();
    contentController.dispose();
  }

  final LoaderManager _loaderManager = LoaderManager();

  /// Function to post a ticket.
  /// It sends a POST request to the server to post a ticket.
  /// It returns a boolean value indicating if the request was successful.
  Future<bool> postTicket(String content) async {
    late http.Response response;
    dynamic previousTicket = tickets.last;

    try {
      setState(() {
        _loaderManager.setIsLoading(true);
      });
      response = await http.post(Uri.parse('$baseUrl/api/mobile/ticket/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${userInformation?.token}',
          },
          body: jsonEncode(<String, String>{
            'content': content,
            'title': previousTicket["title"],
            'createdAt': DateTime.now().toString(),
            'assignedId': previousTicket["assignedId"],
            'chatUid': previousTicket["chatUid"],
          }));
      setState(() {
        _loaderManager.setIsLoading(false);
      });
      if (response.statusCode == 201) {
        return true;
      } else {
        if (context.mounted) {
          printServerResponse(context, response, 'postTicket',
              message:
                  AppLocalizations.of(context)!.errorOccurredDuringPostTicket);
          return false;
        }
      }
    } catch (err, stacktrace) {
      if (context.mounted) {
        setState(() {
          _loaderManager.setIsLoading(false);
        });
        printCatchError(context, err, stacktrace,
            message:
                AppLocalizations.of(context)!.errorOccurredDuringPostTicket);
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: MyAppBar(
        curveColor: context.select((ThemeProvider themeProvider) =>
            themeProvider.currentTheme.secondaryHeaderColor),
        showBackButton: false,
        textTitle: tickets[0]["title"],
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: context.select((ThemeProvider themeProvider) =>
          themeProvider.currentTheme.colorScheme.surface),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                reverse: true,
                itemCount: tickets.length,
                itemBuilder: (BuildContext context, int index) {
                  final currentTicket = tickets[tickets.length - 1 - index];
                  return Align(
                    alignment:
                        (currentTicket["creatorId"] == userInformation?.ID
                            ? Alignment.topRight
                            : Alignment.topLeft),
                    child: Card(
                      elevation: 5,
                      margin: (currentTicket["creatorId"] == userInformation?.ID
                          ? const EdgeInsets.only(left: 32, top: 8, bottom: 8)
                          : const EdgeInsets.only(
                              right: 32, top: 8, bottom: 8)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: (currentTicket["creatorId"] == userInformation?.ID
                          ? themeProvider.currentTheme.primaryColor
                              .withOpacity(1)
                          : themeProvider.currentTheme.cardColor),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentTicket["content"],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: (currentTicket["creatorId"] ==
                                        userInformation?.ID
                                    ? themeProvider
                                        .currentTheme.colorScheme.surface
                                    : themeProvider
                                        .currentTheme
                                        .inputDecorationTheme
                                        .labelStyle
                                        ?.color),
                              ),
                            ),
                            Text(
                              formatDateTime(
                                  dateTimeString: currentTicket["createdAt"]),
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 12,
                                color: (currentTicket["creatorId"] ==
                                        userInformation?.ID
                                    ? themeProvider
                                        .currentTheme.colorScheme.surface
                                    : themeProvider
                                        .currentTheme
                                        .inputDecorationTheme
                                        .labelStyle
                                        ?.color),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            isOpen
                ? Row(
                    children: [
                      Expanded(
                        flex: 7,
                        child: TextField(
                          key: const Key("conversation-text_field-message"),
                          controller: contentController,
                          onChanged: (String? value) {
                            setState(() {});
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Write here',
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.all(8)),
                      Expanded(
                        flex: 1,
                        child: FloatingActionButton.extended(
                          key: const Key('chat-button-send-message'),
                          backgroundColor: (contentController.text.isNotEmpty)
                              ? themeProvider.currentTheme.primaryColor
                              : Colors.grey,
                          onPressed: (contentController.text.isNotEmpty)
                              ? () async {
                                  final newContent = contentController.text;
                                  bool success = await postTicket(newContent!);
                                  if (success) {
                                    final lastTicket = tickets.last;
                                    final newTicket = {
                                      "content": newContent,
                                      'title': lastTicket["title"],
                                      'assignedId': lastTicket["assignedId"],
                                      'chatUid': lastTicket["chatUid"],
                                      'creatorId': userInformation!.ID!,
                                      'createdAt': DateTime.now().toString(),
                                    };
                                    setState(() {
                                      tickets.add(newTicket);
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                    });
                                  }
                                }
                              : null,
                          label: const Icon(Icons.send),
                        ),
                      ),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
