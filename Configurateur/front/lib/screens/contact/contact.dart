import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:front/components/custom_footer.dart';
import 'package:front/components/custom_header.dart';
import 'package:front/network/informations.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/themes.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? token = '';
  String? userMail = '';
  String? uuid = '';
  bool showOpenedTickets = true;
  List<dynamic> conversation = [];

  Map<String, dynamic> openedTickets = {};
  Map<String, dynamic> closedTickets = {};

  String _title = "";
  String _message = "";

  Future<bool> handleSubmitMessage(String value) async {
    dynamic ticket = conversation.last;

    var header = <String, String>{
      'Authorization': token!,
      'Content-Type': 'application/json; charset=UTF-8',
      'Access-Control-Allow-Origin': '*',
    };

    var response = await http.post(
      Uri.parse('http://$serverIp:3000/api/tickets/create'),
      headers: header,
      body: jsonEncode(
        <String, String>{
          'content': value,
          'title': ticket["title"],
          'createdAt': DateTime.now().toString(),
          'chatUid': ticket["chatUid"],
          'assignedId': ticket['assignedId'],
          'uuid': uuid!,
        },
      ),
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkToken() async {
    token = await storageService.readStorage('token');
    await storageService.getUserMail().then((value) => userMail = value);
    await storageService.getUserUuid().then((value) => uuid = value);
    if (token == "") {
      context.go('/login');
    }
    return uuid != "";
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

  void getTickets() async {
    var header = <String, String>{
      'Authorization': token!,
      'Content-Type': 'application/json; charset=UTF-8',
      'Access-Control-Allow-Origin': '*',
    };

    var response = await http.get(
      Uri.parse('http://$serverIp:3000/api/tickets/user-ticket/$uuid'),
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

      setState(() {
        openedTickets = tmpOpenedTickets;
        closedTickets = tmpClosedTickets;
        conversation = [];
      });
    } else {
      print('Erreur lors de l\'envoi des données : ${response.statusCode}');
      Fluttertoast.showToast(
          msg: "Erreur durant la récupération des tickets",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red);
    }
  }

  ThemeData getCurrentTheme() {
    return Provider.of<ThemeService>(context).isDark ? darkTheme : lightTheme;
  }

  String formatDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    DateFormat formatter = DateFormat.yMd().add_Hm();
    return formatter.format(dateTime);
  }

  @override
  Future<void> initState() async {
    super.initState();
    while (await checkToken() == false) {}
    getTickets();
  }

  void createTicket() async {
    var header = <String, String>{
      'Authorization': token!,
      'Content-Type': 'application/json; charset=UTF-8',
      'Access-Control-Allow-Origin': '*',
    };

    var response = await http.post(
      Uri.parse('http://$serverIp:3000/api/tickets/create'),
      headers: header,
      body: jsonEncode(
        <String, String>{
          'content': _message,
          'title': _title,
          'createdAt': DateTime.now().toString(),
          'uuid': uuid!,
        },
      ),
    );
    if (response.statusCode == 201) {
      getTickets();
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _contentController = TextEditingController();

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
                                  ? const Text("Aucun Ticket")
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

                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              conversation = showOpenedTickets
                                                  ? openedTickets[key]
                                                  : closedTickets[key];
                                            });
                                          },
                                          child: Card(
                                            elevation: 5,
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(16),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    firstTicket["title"],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      color: getCurrentTheme()
                                                          .primaryColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Créé le : ${formatDateTime(firstTicket["createdAt"])}",
                                                  ),
                                                  Text(
                                                    "Dernière activité le : ${formatDateTime(lastTicket["createdAt"])}",
                                                  )
                                                ],
                                              ),
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
                                  onPressed: () {
                                    createTicket();
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
                              ]),
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
                                  itemBuilder:
                                      (BuildContext context, int index) {
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
                                                ? darkTheme.buttonTheme
                                                    .colorScheme!.primary
                                                : lightTheme
                                                    .secondaryHeaderColor
                                            : Provider.of<ThemeService>(context)
                                                    .isDark
                                                ? darkTheme.cardColor
                                                : lightTheme.cardColor),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                chat["content"],
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Text(
                                                formatDateTime(
                                                    chat["createdAt"]),
                                                style: const TextStyle(
                                                  fontStyle: FontStyle.italic,
                                                  fontSize: 12,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          TextFormField(
                            controller: _contentController,
                            onChanged: (value) => _message = value,
                            decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                onTap: () async {
                                  bool success =
                                      await handleSubmitMessage(_message);
                                  if (success) {
                                    final lastTicket = conversation.last;
                                    final newTicket = {
                                      "content": _message,
                                      'title': lastTicket["title"],
                                      'assignedId': lastTicket["assignedId"],
                                      'chatUid': lastTicket["chatUid"],
                                      'creatorId': uuid!,
                                      'createdAt': DateTime.now().toString(),
                                    };
                                    setState(
                                      () {
                                        conversation.add(newTicket);
                                        _contentController.clear();
                                        _message = "";
                                        // getTickets();
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
                            onFieldSubmitted: handleSubmitMessage,
                          ),
                          const SizedBox(height: 16.0),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      conversation = [];
                                    });
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
                              ]),
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
