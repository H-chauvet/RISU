import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/components/outlined_button.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/article/list_page.dart';
import 'package:risu/utils/errors.dart';
import 'package:risu/utils/theme.dart';

import 'details_page.dart';

Future<dynamic> getContainerData(
    BuildContext context, String containerId) async {
  late http.Response response;
  try {
    response = await http.get(
      Uri.parse('http://$serverIp:8080/api/container/$containerId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      dynamic responseData = jsonDecode(response.body);
      return responseData;
    } else {
      printServerResponse(context, response, 'getContainerData',
          message:
              "Une erreur est survenue lors de la récupération des données");
      return {
        'address': '',
        'city': '',
        '_count': {'items': 0}
      };
    }
  } catch (err, stacktrace) {
    printCatchError(context, err, stacktrace, message: "Connexion refused.");
    return {
      'address': '',
      'city': '',
      '_count': {'items': 0}
    };
  }
}

class ContainerDetailsState extends State<ContainerDetailsPage> {
  String _containerId = "";
  String _address = "";
  String _city = "";
  int _availableItems = 0;

  @override
  void initState() {
    super.initState();
    _containerId = widget.containerId;
    getContainerData(context, _containerId).then((dynamic value) {
      setState(() {
        _address = value['address'].toString();
        _city = value['city'].toString();
        _availableItems = value['_count']['items'];
      });
    });
  }

  String getContainerId() {
    return _containerId;
  }

  String getAddress() {
    return _address;
  }

  String getCity() {
    return _city;
  }

  int getAvailableItems() {
    return _availableItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        curveColor: context.select((ThemeProvider themeProvider) =>
            themeProvider.currentTheme.secondaryHeaderColor),
        showBackButton: false,
        showLogo: true,
        showBurgerMenu: true,
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: context.select((ThemeProvider themeProvider) =>
          themeProvider.currentTheme.colorScheme.background),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$_address, $_city',
                  key: const Key('container-details_title'),
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: context.select((ThemeProvider themeProvider) =>
                        themeProvider.currentTheme.secondaryHeaderColor),
                    shadows: [
                      Shadow(
                        color: context.select((ThemeProvider themeProvider) =>
                            themeProvider.currentTheme.secondaryHeaderColor),
                        blurRadius: 24,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: 300,
                  height: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: const DecorationImage(
                        image: AssetImage('assets/container.png'),
                        fit: BoxFit.cover,
                      )),
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 2,
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: context.select(
                                (ThemeProvider themeProvider) => themeProvider
                                    .currentTheme.colorScheme.background),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: Text(
                            'Il y a actuellement $_availableItems articles disponible${_availableItems > 1 ? 's' : ''}',
                            key: const Key('container-details_article-list'),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: MyOutlinedButton(
                    text: 'Afficher la liste des articles',
                    key: const Key('container-button_article-list-page'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ArticleListPage(
                            containerId: _containerId,
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
