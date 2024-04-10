import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/components/loader.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/contact/conversation_page.dart';
import 'package:risu/pages/contact/new_ticket_page.dart';
import 'package:risu/utils/errors.dart';
import 'package:risu/utils/time.dart';
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
    if (widget.testTickets.isEmpty) {
      getUserTickets();
    } else {
      openedTickets = widget.testTickets;
      closedTickets = widget.testTickets;
    }
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
      if (response.statusCode == 200) {
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

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: MyAppBar(
        curveColor: context.select((ThemeProvider themeProvider) =>
            themeProvider.currentTheme.secondaryHeaderColor),
        showBackButton: false,
        textTitle: AppLocalizations.of(context)!.myTickets,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        key: const Key('contact-ink-well-show-open'),
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
                              height: 30,
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
                                          ? Colors.grey[800]
                                          : Colors.grey[400],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        key: const Key('contact-ink-well-show-close'),
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
                              height: 30,
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
                                          ? Colors.grey[800]
                                          : Colors.grey[400],
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
                                child: GestureDetector(
                                  key: const Key('contact-gesture-go-to-chat'),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ConversationPage(
                                          tickets: showOpenedTickets
                                              ? openedTickets[key]
                                              : closedTickets[key],
                                          isOpen: showOpenedTickets,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                                      .currentTheme
                                                      .primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                AppLocalizations.of(context)!
                                                    .createdAt(
                                                  formatDateTime(
                                                      dateTimeString:
                                                          firstTicket[
                                                              "createdAt"]),
                                                ),
                                              ),
                                              Text(
                                                AppLocalizations.of(context)!
                                                    .lastActivity(formatDateTime(
                                                        dateTimeString:
                                                            lastTicket[
                                                                "createdAt"])),
                                              )
                                            ],
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Icon(
                                            Icons.navigate_next,
                                            color: themeProvider
                                                .currentTheme.primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NewTicketPage(),
                          ),
                        );
                      },
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
