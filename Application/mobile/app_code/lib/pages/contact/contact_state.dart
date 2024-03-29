import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:risu/components/alert_dialog.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/components/loader.dart';
import 'package:risu/components/outlined_button.dart';
import 'package:risu/components/text_input.dart';
import 'package:risu/globals.dart';
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
                                AppLocalizations.of(context)!.rentsListEmpty,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : const Center(
                              child: Text(
                                "Working",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FloatingActionButton.extended(
                      key: const Key('add_ticket-button'),
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
