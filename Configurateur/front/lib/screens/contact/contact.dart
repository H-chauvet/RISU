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
import 'package:provider/provider.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  _ContactPageState createState() => _ContactPageState();
}

void sendFormData(
  GlobalKey<FormState> formKey,
  String surname,
  String name,
  String email,
  String message,
) async {
  var body = {
    'firstName': surname,
    'lastName': name,
    'email': email,
    'message': message,
  };

  var response = await http.post(
    Uri.parse('http://$serverIp:3000/api/contact'),
    body: body,
  );

  if (response.statusCode == 200) {
    print('Code 200, données envoyées.');
    Fluttertoast.showToast(
      msg: 'Message envoyé avec succès',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 3,
    );
    formKey.currentState!.reset();
  } else {
    print('Erreur lors de l\'envoi des données : ${response.statusCode}');
    Fluttertoast.showToast(
        msg: "Erreur durant l'envoi du message",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.red);
  }
}

class _ContactPageState extends State<ContactPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? token = '';
  String? userMail = '';
  String? uuid = '';
  bool showOpenedTickets = true;

  Map<String, dynamic> openedTickets = {};
  Map<String, dynamic> closedTickets = {};

  void checkToken() async {
    token = await storageService.readStorage('token');
    storageService.getUserMail().then((value) => userMail = value);
    storageService.getUserUuid().then((value) => uuid = value);
    if (token == "") {
      context.go('/login');
    }
    setState(() {});
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
      Uri.parse('http://localhost:3000/api/tickets/all-tickets'),
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
      });
    } else {
      print('Erreur lors de l\'envoi des données : ${response.statusCode}');
      Fluttertoast.showToast(
          msg: "Erreur durant l'envoi du message",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red);
    }
  }

  ThemeData getCurrentTheme() {
    return Provider.of<ThemeService>(context).isDark ? darkTheme : lightTheme;
  }

  @override
  void initState() {
    super.initState();
    checkToken();
    getTickets();
  }

  @override
  Widget build(BuildContext context) {
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
                          margin: const EdgeInsets.all(32),
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
                              Text(openedTickets.length.toString()),
                              /*Expanded(
                                child: (showOpenedTickets
                                            ? openedTickets
                                            : closedTickets)
                                        .isEmpty
                                    ? const Center(
                                        child: Text(
                                          "Aucun ticket",
                                          style: TextStyle(
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
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          String key = (showOpenedTickets
                                                  ? openedTickets
                                                  : closedTickets)
                                              .keys
                                              .elementAt(index);

                                          dynamic firstTicket =
                                              showOpenedTickets
                                                  ? openedTickets[key][0]
                                                  : closedTickets[key][0];
                                          dynamic lastTicket = showOpenedTickets
                                              ? openedTickets[key].last
                                              : closedTickets[key].last;

                                          return GestureDetector(
                                            key: const Key(
                                                'contact-gesture-go-to-chat'),
                                            onTap: () {
                                              /*Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ConversationPage(
                                                    tickets: showOpenedTickets
                                                        ? openedTickets[key]
                                                        : closedTickets[key],
                                                    isOpen: showOpenedTickets,
                                                  ),
                                                ),
                                              );*/
                                            },
                                            child: Card(
                                              elevation: 5,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              //color:
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            firstTicket[
                                                                "title"],
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              color: getCurrentTheme()
                                                                  .primaryColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          Text(
                                                            "Créé le : ${firstTicket["createdAt"]}",
                                                          ),
                                                          Text(
                                                            "Créé le : ${lastTicket["createdAt"]}",
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Icon(
                                                        Icons.navigate_next,
                                                        color: getCurrentTheme()
                                                            .primaryColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                              ),*/
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
                          decoration: InputDecoration(
                            labelText: 'Titre',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          maxLines: 15,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            labelText: 'Message',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {},
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
