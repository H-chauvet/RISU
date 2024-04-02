import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:risu/components/alert_dialog.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/components/loader.dart';
import 'package:risu/components/outlined_button.dart';
import 'package:risu/components/text_input.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/contact/conversation_page.dart';
import 'package:risu/utils/errors.dart';
import 'package:risu/utils/providers/theme.dart';

import 'contact_page.dart';

class ContactPageState extends State<ContactPage> {
  Map<String, dynamic> openedTickets = {};
  Map<String, dynamic> closedTickets = {};
  final LoaderManager _loaderManager = LoaderManager();
  bool showOpenedTickets = true;

  @override
  void initState() {
    super.initState();
    getUserTickets();
  }

  String formatDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  void sortTickets(Map<String, dynamic> tickets) {
    tickets.forEach((key, value) {
      if (tickets[key].length > 1) {
        tickets[key].sort((a, b) {
          String strA = a["createdAt"];
          String strB = b["createdAt"];
          return strA.compareTo(strB);
        });
      }
    });
  }

  void getUserTickets() async {
    late http.Response response;

    try {
      setState(() {
        _loaderManager.setIsLoading(true);
      });
      response = await http.get(
        Uri.parse('$baseUrl/api/mobile/ticket/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${userInformation?.token}',
        },
      );
      setState(() {
        _loaderManager.setIsLoading(false);
      });
      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        List<dynamic> tickets = data["tickets"];
        Map<String, dynamic> tmpOpenedTickets = {};
        Map<String, dynamic> tmpClosedTickets = {};

        for (var element in tickets) {
          if (element["closed"]) {
            tmpClosedTickets.containsKey(element["chatUid"])
                ? tmpClosedTickets[element["chatUid"]].add(element)
                : tmpClosedTickets[element["chatUid"]] = [element];
          } else {
            tmpOpenedTickets.containsKey(element["chatUid"])
                ? tmpOpenedTickets[element["chatUid"]].add(element)
                : tmpOpenedTickets[element["chatUid"]] = [element];
          }
        }

        sortTickets(tmpClosedTickets);
        sortTickets(tmpOpenedTickets);

        setState(() {
          openedTickets = tmpOpenedTickets;
          closedTickets = tmpClosedTickets;
        });
      } else {
        if (context.mounted) {
          printServerResponse(context, response, 'getTickets',
              message: AppLocalizations.of(context)!
                  .errorOccurredDuringGettingUserTickets);
        }
      }
    } catch (err, stacktrace) {
      if (context.mounted) {
        setState(() {
          _loaderManager.setIsLoading(false);
        });
        printCatchError(context, err, stacktrace,
            message: AppLocalizations.of(context)!
                .errorOccurredDuringGettingUserTickets);
        return;
      }
    }
  }

  Future<bool> apiContact(String name, String email, String message) async {
    late http.Response response;
    try {
      setState(() {
        _loaderManager.setIsLoading(true);
      });
      response = await http.post(
        Uri.parse('$baseUrl/api/mobile/contact'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': name,
          'email': email,
          'message': message,
        }),
      );
    } catch (err, stacktrace) {
      if (context.mounted) {
        setState(() {
          _loaderManager.setIsLoading(false);
        });
        printCatchError(context, err, stacktrace,
            message: AppLocalizations.of(context)!.connectionRefused);
        return false;
      }
    }
    setState(() {
      _loaderManager.setIsLoading(false);
    });
    if (response.statusCode == 201) {
      if (context.mounted) {
        await MyAlertDialog.showInfoAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.contact,
          message: AppLocalizations.of(context)!.messageSent,
        );
        return true;
      }
    } else {
      if (context.mounted) {
        printServerResponse(context, response, 'apiContact',
            message: AppLocalizations.of(context)!
                .errorOccurredDuringSendingMessage);
      }
    }
    return false;
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
      body: (_loaderManager.getIsLoading())
          ? Center(child: _loaderManager.getLoader())
          : Container(
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  Text(
                    AppLocalizations.of(context)!.myTickets,
                    key: const Key('my-tickets-title'),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      color: themeProvider.currentTheme.primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            showOpenedTickets = true;
                          });
                        },
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0),
                          ),
                          child: Container(
                            constraints: BoxConstraints.expand(
                              width: MediaQuery.of(context).size.width / 3,
                              height: 30, // hauteur du bouton
                            ),
                            decoration: BoxDecoration(
                              color: showOpenedTickets
                                  ? themeProvider.currentTheme.primaryColor
                                  : themeProvider
                                      .currentTheme.secondaryHeaderColor,
                            ),
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)!.inProgress,
                                style: TextStyle(
                                  color: showOpenedTickets
                                      ? themeProvider
                                          .currentTheme.secondaryHeaderColor
                                      : themeProvider.currentTheme.brightness ==
                                              Brightness.light
                                          ? Colors.grey[
                                              800] // Gris foncé pour le mode clair
                                          : Colors.grey[400],
                                  // Gris clair pour le mode sombre
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            showOpenedTickets = false;
                          });
                        },
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(8.0),
                            bottomRight: Radius.circular(8.0),
                          ),
                          child: Container(
                            constraints: BoxConstraints.expand(
                              width: MediaQuery.of(context).size.width / 3,
                              height: 30, // hauteur du bouton
                            ),
                            decoration: BoxDecoration(
                              color: !showOpenedTickets
                                  ? themeProvider.currentTheme.primaryColor
                                  : themeProvider
                                      .currentTheme.secondaryHeaderColor,
                            ),
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)!.closed,
                                style: TextStyle(
                                  color: !showOpenedTickets
                                      ? themeProvider
                                          .currentTheme.secondaryHeaderColor
                                      : themeProvider.currentTheme.brightness ==
                                              Brightness.light
                                          ? Colors.grey[
                                              800] // Gris foncé pour le mode clair
                                          : Colors.grey[400],
                                  // Gris clair pour le mode sombre
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: (showOpenedTickets ? openedTickets : closedTickets)
                            .isEmpty
                        ? Center(
                            child: Text(
                              AppLocalizations.of(context)!.ticketListEmpty,
                              key: const Key("contact-tickets-empty"),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: showOpenedTickets
                                ? openedTickets.length
                                : closedTickets.length,
                            itemBuilder: (BuildContext context, int index) {
                              String key = (showOpenedTickets
                                      ? openedTickets
                                      : closedTickets)
                                  .keys
                                  .elementAt(index);

                              dynamic firstTicket = showOpenedTickets
                                  ? openedTickets[key][0]
                                  : closedTickets[key][0];
                              dynamic lastTicket = showOpenedTickets
                                  ? openedTickets[key].last
                                  : closedTickets[key].last;
                              return Card(
                                elevation: 5,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                color: themeProvider.currentTheme.cardColor,
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              firstTicket["title"],
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: themeProvider
                                                    .currentTheme.primaryColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .createdAt(
                                                formatDateTime(
                                                    firstTicket["createdAt"]),
                                              ),
                                            ),
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .lastActivity(formatDateTime(
                                                      lastTicket["createdAt"])),
                                            )
                                          ],
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: FloatingActionButton.small(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ConversationPage(
                                                  tickets: showOpenedTickets
                                                      ? openedTickets[key]
                                                      : closedTickets[key],
                                                ),
                                              ),
                                            );
                                          },
                                          backgroundColor: themeProvider
                                              .currentTheme
                                              .secondaryHeaderColor,
                                          child: Icon(
                                            Icons.navigate_next,
                                            color: themeProvider
                                                .currentTheme.primaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FloatingActionButton.extended(
                      key: const Key('contact-add_ticket-button'),
                      onPressed: () async {},
                      backgroundColor:
                          themeProvider.currentTheme.secondaryHeaderColor,
                      label: Text(
                        AppLocalizations.of(context)!.createTicket,
                        style: TextStyle(
                            color: themeProvider.currentTheme.primaryColor),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
