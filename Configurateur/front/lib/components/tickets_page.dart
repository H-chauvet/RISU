import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:front/network/informations.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/themes.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'custom_footer.dart';
import 'custom_header.dart';

class TicketsPage extends StatefulWidget {
  final bool isAdmin;

  const TicketsPage({
    super.key,
    this.isAdmin = false,
  });

  @override
  TicketsState createState() => TicketsState();
}

class TicketsState extends State<TicketsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? token = '';
  String? uuid = '';

  Map<String, dynamic> openedTickets = {};
  Map<String, dynamic> closedTickets = {};

  bool showOpenedTickets = true;
  List<dynamic> conversation = [];

  String _title = "";
  String _message = "";

  bool isAdmin = false;

  ThemeData getCurrentTheme() {
    return Provider.of<ThemeService>(context).isDark ? darkTheme : lightTheme;
  }

  String formatDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    DateFormat formatter = DateFormat.yMd().add_Hm();
    return formatter.format(dateTime);
  }

  Future<bool> createTicket(
      {required String title, String? chatUid, String assignedId = ""}) async {
    var header = <String, String>{
      'Authorization': token!,
      'Content-Type': 'application/json; charset=UTF-8',
      'Access-Control-Allow-Origin': '*',
    };

    var body = <String, String>{
      'content': _message,
      'title': title,
      'createdAt': DateTime.now().toString(),
      'uuid': uuid!,
      'assignedId': assignedId,
    };

    if (chatUid != null && chatUid.isNotEmpty) {
      body['chatUid'] = chatUid;
    }
    var response = await http.post(
      Uri.parse('http://$serverIp:3000/api/tickets/create'),
      headers: header,
      body: jsonEncode(body),
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      Fluttertoast.showToast(
          msg: "Erreur durant la création du ticket" + assignedId,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red);
    }
    return false;
  }

  Future<void> closeTicket({required String chatUid}) async {
    var header = <String, String>{
      'Authorization': token!,
      'Content-Type': 'application/json; charset=UTF-8',
      'Access-Control-Allow-Origin': '*',
    };

    var response = await http.put(
      Uri.parse('http://$serverIp:3000/api/tickets/$chatUid'),
      headers: header,
      body: jsonEncode(
        <String, String>{
          'uuid': uuid!,
        },
      ),
    );
    if (response.statusCode == 201) {
    } else {
      Fluttertoast.showToast(
          msg: "Erreur durant la cloture du ticket",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red);
    }
  }

  Future<bool> assignTicket({required List<dynamic> tickets}) async {
    String ids = "";
    for (dynamic element in tickets) {
      ids += element["id"].toString();
      if (tickets.last != element) {
        ids += "_";
      }
    }

    var header = <String, String>{
      'Authorization': token!,
      'Content-Type': 'application/json; charset=UTF-8',
      'Access-Control-Allow-Origin': '*',
    };

    var response = await http.put(
      Uri.parse('http://$serverIp:3000/api/tickets/assign/$uuid'),
      headers: header,
      body: jsonEncode(
        <String, String>{
          'ticketIds': ids,
        },
      ),
    );
    if (response.statusCode == 201) {
      setState(
        () {
          for (dynamic ticket in tickets) {
            ticket["assignedId"] = uuid!;
          }
        },
      );
      return true;
    } else {
      Fluttertoast.showToast(
          msg: "Erreur durant l'assignement des tickets",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red);
    }
    return false;
  }

  bool notAssigned(List<dynamic> tickets) {
    for (dynamic ticket in tickets) {
      if (ticket["assignedId"] != null && ticket["assignedId"] != "") {
        return false;
      }
    }
    return true;
  }

  bool assigned(List<dynamic> tickets) {
    for (dynamic ticket in tickets) {
      if (ticket["assignedId"] == uuid!) {
        return true;
      }
    }
    return false;
  }

  String findAssigned() {
    for (var element in conversation) {
      final creator = element["creatorId"];
      final assigned = element["assignedId"];
      if (creator != null && creator != "" && creator != uuid) {
        return creator;
      }
      if (assigned != null && assigned != "" && assigned != uuid) {
        return assigned;
      }
    }
    return "";
  }

  void sortTickets(Map<String, dynamic> tickets) {
    tickets.forEach(
      (key, value) {
        if (tickets[key].length > 1) {
          tickets[key].sort(
            (a, b) {
              String strA = a["createdAt"];
              String strB = b["createdAt"];
              return strA.compareTo(strB);
            },
          );
        }
      },
    );
  }

  void getTickets() async {
    String url = "";
    if (isAdmin) {
      url = 'http://$serverIp:3000/api/tickets/all-tickets';
    } else {
      url = 'http://$serverIp:3000/api/tickets/user-ticket/$uuid';
    }

    var header = <String, String>{
      'Authorization': token!,
      'Content-Type': 'application/json; charset=UTF-8',
      'Access-Control-Allow-Origin': '*',
    };

    var response = await http.get(
      Uri.parse(url),
      headers: header,
    );
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

      setState(
        () {
          openedTickets = tmpOpenedTickets;
          closedTickets = tmpClosedTickets;
          conversation = [];
        },
      );
    } else {
      Fluttertoast.showToast(
          msg: "Erreur durant la récupération des tickets",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red);
    }
  }

  Future<void> checkToken() async {
    token = await storageService.readStorage('token');
    uuid = await storageService.getUserUuid();
    if (token == "") {
      context.go('/login');
    } else {
      getTickets();
    }
  }

  @override
  void initState() {
    super.initState();
    isAdmin = widget.isAdmin;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkToken();
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _contentController = TextEditingController();
    final TextEditingController _convController = TextEditingController();

    return Scaffold(
      body: FooterView(
        footer: Footer(
          child: CustomFooter(context: context),
        ),
        children: [
          LandingAppBar(context: context),
          Text(
            'Contactez le support RISU !',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 35,
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              color: Provider.of<ThemeService>(context).isDark
                  ? darkTheme.secondaryHeaderColor
                  : lightTheme.secondaryHeaderColor,
              shadows: [
                Shadow(
                  color: Provider.of<ThemeService>(context).isDark
                      ? darkTheme.secondaryHeaderColor
                      : lightTheme.secondaryHeaderColor,
                  offset: const Offset(0.75, 0.75),
                  blurRadius: 1.5,
                ),
              ],
            ),
          ),
          const SizedBox(height: 100),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 150),
            child: Form(
              key: _formKey,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Liste des tickets',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 35,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            color: Provider.of<ThemeService>(context).isDark
                                ? darkTheme.secondaryHeaderColor
                                : lightTheme.secondaryHeaderColor,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(64),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    key: const Key("ticket-state-open"),
                                    onTap: () {
                                      setState(
                                        () {
                                          showOpenedTickets = true;
                                        },
                                      );
                                    },
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(8.0),
                                        bottomLeft: Radius.circular(8.0),
                                      ),
                                      child: Container(
                                        constraints: const BoxConstraints(
                                          maxWidth: 256,
                                          maxHeight: 32,
                                        ),
                                        decoration: BoxDecoration(
                                          color: showOpenedTickets
                                              ? getCurrentTheme()
                                                  .buttonTheme
                                                  .colorScheme
                                                  ?.primary
                                              : getCurrentTheme().primaryColor,
                                        ),
                                        child: Center(
                                          child: Text(
                                            "En cours",
                                            style: TextStyle(
                                              color: showOpenedTickets
                                                  ? getCurrentTheme()
                                                      .primaryColor
                                                  : getCurrentTheme()
                                                      .buttonTheme
                                                      .colorScheme
                                                      ?.primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    key: const Key("ticket-state-closed"),
                                    onTap: () {
                                      setState(
                                        () {
                                          showOpenedTickets = false;
                                        },
                                      );
                                    },
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(8.0),
                                        bottomRight: Radius.circular(8.0),
                                      ),
                                      child: Container(
                                        constraints:
                                            const BoxConstraints.expand(
                                          width: 256,
                                          height: 32,
                                        ),
                                        decoration: BoxDecoration(
                                          color: showOpenedTickets
                                              ? getCurrentTheme().primaryColor
                                              : getCurrentTheme()
                                                  .buttonTheme
                                                  .colorScheme
                                                  ?.primary,
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Fermés",
                                            style: TextStyle(
                                              color: !showOpenedTickets
                                                  ? getCurrentTheme()
                                                      .primaryColor
                                                  : getCurrentTheme()
                                                      .buttonTheme
                                                      .colorScheme
                                                      ?.primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),
                              (showOpenedTickets
                                          ? openedTickets
                                          : closedTickets)
                                      .isEmpty
                                  ? Text(
                                      "Aucun Ticket",
                                      style: TextStyle(
                                        color:
                                            Provider.of<ThemeService>(context)
                                                    .isDark
                                                ? darkTheme.secondaryHeaderColor
                                                : lightTheme
                                                    .secondaryHeaderColor,
                                      ),
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: showOpenedTickets
                                          ? openedTickets.length
                                          : closedTickets.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
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
                                        dynamic tickets = showOpenedTickets
                                            ? openedTickets[key]
                                            : closedTickets[key];

                                        return Card(
                                          color: Provider.of<ThemeService>(
                                                      context)
                                                  .isDark
                                              ? lightTheme.secondaryHeaderColor
                                              : darkTheme.secondaryHeaderColor,
                                          elevation: 5,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(
                                                        () {
                                                          conversation =
                                                              tickets;
                                                        },
                                                      );
                                                    },
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          firstTicket["title"],
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            color:
                                                                getCurrentTheme()
                                                                    .primaryColor,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          "Créé le : ${formatDateTime(
                                                            firstTicket[
                                                                "createdAt"],
                                                          )}",
                                                          style: TextStyle(
                                                            color:
                                                                getCurrentTheme()
                                                                    .primaryColor,
                                                          ),
                                                        ),
                                                        Text(
                                                          "Dernière activité le : ${formatDateTime(
                                                            lastTicket[
                                                                "createdAt"],
                                                          )}",
                                                          style: TextStyle(
                                                            color:
                                                                getCurrentTheme()
                                                                    .primaryColor,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                isAdmin && notAssigned(tickets)
                                                    ? Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: GestureDetector(
                                                          onTap: () async {
                                                            await assignTicket(
                                                                tickets:
                                                                    tickets);
                                                          },
                                                          child: const Text(
                                                            "S'assigner",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : Container()
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: SizedBox(
                      height: 512,
                      width: 1,
                      child: VerticalDivider(
                        thickness: 1,
                      ),
                    ),
                  ),
                  if (conversation.isEmpty)
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Nouveau ticket',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 35,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              color: Provider.of<ThemeService>(context).isDark
                                  ? darkTheme.secondaryHeaderColor
                                  : lightTheme.secondaryHeaderColor,
                            ),
                          ),
                          const SizedBox(height: 50),
                          TextFormField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              labelText: 'Titre',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            onChanged: (value) => _title = value,
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _contentController,
                            maxLines: 15,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              labelText: 'Message',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            onChanged: (value) => _message = value,
                          ),
                          const SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  await createTicket(title: _title);
                                  getTickets();
                                  _titleController.clear();
                                  _contentController.clear();
                                  _message = "";
                                  _title = "";
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                child: Text(
                                  'Soumettre votre ticket',
                                  style: TextStyle(
                                    color: Provider.of<ThemeService>(context)
                                            .isDark
                                        ? darkTheme.primaryColor
                                        : lightTheme.primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  else
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            conversation[0]["title"],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 35,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              color: Provider.of<ThemeService>(context).isDark
                                  ? darkTheme.secondaryHeaderColor
                                  : lightTheme.secondaryHeaderColor,
                            ),
                          ),
                          const SizedBox(height: 38),
                          Container(
                            width: double.infinity,
                            height: 400,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(32),
                              child: ListView.builder(
                                itemCount: conversation.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final chat = conversation[index];

                                  return Align(
                                    alignment: chat["creatorId"] == uuid
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Card(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      color: (chat["creatorId"] == uuid
                                          ? Provider.of<ThemeService>(context)
                                                  .isDark
                                              ? darkTheme.secondaryHeaderColor
                                              : lightTheme.secondaryHeaderColor
                                          : Provider.of<ThemeService>(context)
                                                  .isDark
                                              ? lightTheme.secondaryHeaderColor
                                              : darkTheme.secondaryHeaderColor),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              chat["content"],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: (chat["creatorId"] ==
                                                        uuid
                                                    ? Provider.of<ThemeService>(
                                                                context)
                                                            .isDark
                                                        ? lightTheme
                                                            .secondaryHeaderColor
                                                        : darkTheme.primaryColor
                                                    : Provider.of<ThemeService>(
                                                                context)
                                                            .isDark
                                                        ? darkTheme
                                                            .secondaryHeaderColor
                                                        : lightTheme
                                                            .secondaryHeaderColor),
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              formatDateTime(chat["createdAt"]),
                                              style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: (chat["creatorId"] ==
                                                        uuid
                                                    ? Provider.of<ThemeService>(
                                                                context)
                                                            .isDark
                                                        ? lightTheme
                                                            .secondaryHeaderColor
                                                        : darkTheme.primaryColor
                                                    : Provider.of<ThemeService>(
                                                                context)
                                                            .isDark
                                                        ? darkTheme
                                                            .secondaryHeaderColor
                                                        : lightTheme
                                                            .secondaryHeaderColor),
                                                fontSize: 12,
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
                          ),
                          const SizedBox(height: 8.0),
                          (isAdmin &&
                                      assigned(conversation) &&
                                      conversation.last["closed"] == 0 ||
                                  (!isAdmin &&
                                      conversation.last["closed"] == 0))

                              /// Rajoter un isOpen qui check si la conversation est ouverte en vérifiant les ["closed"] des tickets de conversations
                              ? TextFormField(
                                  controller: _convController,
                                  onChanged: (value) => _message = value,
                                  decoration: InputDecoration(
                                    suffixIcon: GestureDetector(
                                      onTap: () async {
                                        final lastTicket = conversation.last;
                                        final assignedId = findAssigned();
                                        bool success = await createTicket(
                                            title: lastTicket["title"],
                                            chatUid: lastTicket["chatUid"],
                                            assignedId: assignedId);
                                        if (success) {
                                          final newTicket = {
                                            "content": _message,
                                            'title': lastTicket["title"],
                                            'assignedId': assignedId,
                                            'chatUid': lastTicket["chatUid"],
                                            'creatorId': uuid!,
                                            'createdAt':
                                                DateTime.now().toString(),
                                          };
                                          _convController.clear();
                                          _message = "";
                                          setState(
                                            () {
                                              conversation.add(newTicket);
                                            },
                                          );
                                        }
                                      },
                                      child: const Icon(Icons.arrow_upward),
                                    ),
                                    labelText: 'Nouveau message',
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                    ),
                                  ),
                                )
                              : Container(),
                          const SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Clore le ticket seulement si admin
                              // main and cross axis alignment à .start
                              // Et l'elevated Button dans un Align
                              // avec Alignment.centerRight
                              // Et après call la fonction back
                              // /!\ VERIFIER QU'ON PEUT PLUS ECRIRE si le ticket est close

                              if (isAdmin &&
                                  assigned(conversation) &&
                                  conversation.last["closed"] == 0)
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await closeTicket(
                                          chatUid:
                                              conversation.last["chatUid"]);
                                      getTickets();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                    ),
                                    child: Text(
                                      'Cloturer la conversation',
                                      style: TextStyle(
                                        color:
                                            Provider.of<ThemeService>(context)
                                                    .isDark
                                                ? darkTheme.primaryColor
                                                : lightTheme.primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              const Spacer(),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(
                                      () {
                                        conversation = [];
                                      },
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                  child: Text(
                                    'Fermer la conversation',
                                    style: TextStyle(
                                      color: Provider.of<ThemeService>(context)
                                              .isDark
                                          ? darkTheme.primaryColor
                                          : lightTheme.primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
