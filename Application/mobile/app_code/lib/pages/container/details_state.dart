import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:risu/components/alert_dialog.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/components/outlined_button.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/article/list_page.dart';
import 'package:risu/utils/theme.dart';

import 'details_page.dart';

Future<dynamic> getContainerData(
    BuildContext context, String containerId) async {
  final token = userInformation?.token ?? 'defaultToken';
  late http.Response response;

  try {
    response = await http.post(
      Uri.parse('http://$serverIp:8080/api/container/details'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'containerId': containerId,
      }),
    );
    if (response.statusCode == 200) {
      dynamic responseData = jsonDecode(response.body);
      return responseData;
    } else {
      if (context.mounted) {
        print(response.statusCode);
        print(response.reasonPhrase);
        MyAlertDialog.showErrorAlertDialog(
            key: const Key('container-details_invaliddata'),
            context: context,
            title: 'Container-details',
            message: 'Failed to get container');
      }
      return {
        'owner': '',
        'localization': '',
        '_count': {'items': 0}
      };
    }
  } catch (err) {
    if (context.mounted) {
      MyAlertDialog.showErrorAlertDialog(
          key: const Key('container-details_connectionrefused'),
          context: context,
          title: 'Container-details',
          message: 'Connexion refused');
    }
    return {
      'owner': '',
      'localization': '',
      '_count': {'items': 0}
    };
  }
}

class ContainerDetailsState extends State<ContainerDetailsPage> {
  String _containerId = "";
  String _owner = "";
  String _localization = "";
  int _availableItems = 0;

  @override
  void initState() {
    super.initState();
    _containerId = widget.containerId;
    getContainerData(context, _containerId).then((dynamic value) {
      setState(() {
        _owner = value['owner'].toString();
        _localization = value['localization'].toString();
        _availableItems = value['_count']['items'];
      });
    });
  }

  String getContainerId() {
    return _containerId;
  }

  String getOwner() {
    return _owner;
  }

  String getLocalization() {
    return _localization;
  }

  int getAvalableItems() {
    return _availableItems;
  }

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
                  '$_localization par $_owner',
                  key: const Key('container-details_title'),
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4682B4),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: 300,
                  height: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
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
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: Text(
                            'Il y a Actuellement $_availableItems articles disponibles',
                            key: const Key('container-details_article-list'),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
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
                    text: 'Afficher la liste des article',
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
