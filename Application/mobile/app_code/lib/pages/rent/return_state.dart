import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:risu/components/alert_dialog.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/components/loader.dart';
import 'package:risu/components/outlined_button.dart';
import 'package:risu/globals.dart';
import 'package:risu/utils/errors.dart';
import 'package:risu/utils/theme.dart';

import 'return_page.dart';

class ReturnArticleState extends State<ReturnArticlePage> {
  final LoaderManager _loaderManager = LoaderManager();
  dynamic rent = {
    'id': '',
    'price': '',
    'createdAt': '',
    'duration': '',
    'userId': '',
    'ended': '',
    'item': {
      'id': '',
      'name': '',
      'container': {
        'id': '',
        'address': '',
      },
    },
  };

  @override
  void initState() {
    super.initState();
    getRent();
  }

  void getRent() async {
    try {
      _loaderManager.setIsLoading(true);
      final token = userInformation?.token ?? 'defaultToken';
      final response = await http.get(
        Uri.parse('http://$serverIp:8080/api/rent/${widget.rentId}'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 201) {
        _loaderManager.setIsLoading(false);
        setState(() {
          rent = jsonDecode(response.body)['rental'];
        });
      } else {
        _loaderManager.setIsLoading(false);
        if (context.mounted) {
          printServerResponse(context, response, 'getRent',
              message: "La location n'a pas pu être récupérée.");
        }
      }
    } catch (err, stacktrace) {
      _loaderManager.setIsLoading(false);
      if (context.mounted) {
        printCatchError(context, err, stacktrace,
            message: "La location n'a pas pu être récupérée.");
      }
    }
  }

  void returnArticle() async {
    try {
      _loaderManager.setIsLoading(true);
      final token = userInformation?.token ?? 'defaultToken';
      final response = await http.post(
        Uri.parse('http://$serverIp:8080/api/rent/${rent['id']}/return'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 201) {
        _loaderManager.setIsLoading(false);
        setState(() {
          rent['ended'] = true;
        });
      } else {
        _loaderManager.setIsLoading(false);
        if (context.mounted) {
          printServerResponse(context, response, 'returnArticle',
              message: "La location n'a pas pu être rendue.");
        }
      }
    } catch (err, stacktrace) {
      _loaderManager.setIsLoading(false);
      if (context.mounted) {
        printCatchError(context, err, stacktrace,
            message: "La location n'a pas pu être rendue.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: MyAppBar(
        curveColor: themeProvider.currentTheme.secondaryHeaderColor,
        showBackButton: false,
        showLogo: true,
        showBurgerMenu: false,
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: themeProvider.currentTheme.colorScheme.background,
      body: (_loaderManager.getIsLoading())
          ? Center(child: _loaderManager.getLoader())
          : Center(
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      key: const Key('rent_return-title'),
                      'Retour de location',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: themeProvider.currentTheme.secondaryHeaderColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // image
                    Container(
                      width: 256,
                      height: 192,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: const DecorationImage(
                          image: AssetImage('assets/volley.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      elevation: 2,
                      margin: const EdgeInsets.all(8),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: themeProvider
                                    .currentTheme.colorScheme.background,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: Text(
                                '${rent['item']['name']} | ${rent['item']['container']['address']}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: themeProvider.currentTheme
                                      .inputDecorationTheme.labelStyle!.color,
                                ),
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Container(
                                color: themeProvider
                                    .currentTheme.colorScheme.background,
                                child: Table(
                                  columnWidths: const {
                                    0: FlexColumnWidth(1.0),
                                    1: FlexColumnWidth(1.0),
                                  },
                                  children: [
                                    TableRow(
                                      children: [
                                        TableCell(
                                          child: Container(
                                            padding: const EdgeInsets.all(8.0),
                                            color: themeProvider
                                                .currentTheme.primaryColor,
                                            child: Text(
                                              'Prix',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: themeProvider
                                                    .currentTheme
                                                    .inputDecorationTheme
                                                    .labelStyle!
                                                    .color,
                                              ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Container(
                                            padding: const EdgeInsets.all(8.0),
                                            color: themeProvider
                                                .currentTheme.primaryColor,
                                            child: Text(
                                              'Durée',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: themeProvider
                                                    .currentTheme
                                                    .inputDecorationTheme
                                                    .labelStyle!
                                                    .color,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        TableCell(
                                          child: Container(
                                            padding: const EdgeInsets.all(8.0),
                                            color: themeProvider
                                                .currentTheme.primaryColor
                                                .withOpacity(0.6),
                                            child: Text(
                                              '${rent['price']} €',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: themeProvider
                                                    .currentTheme
                                                    .inputDecorationTheme
                                                    .labelStyle!
                                                    .color,
                                              ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Container(
                                            padding: const EdgeInsets.all(8.0),
                                            color: themeProvider
                                                .currentTheme.primaryColor
                                                .withOpacity(0.6),
                                            child: Text(
                                              '${rent['duration']} heures',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: themeProvider
                                                    .currentTheme
                                                    .inputDecorationTheme
                                                    .labelStyle!
                                                    .color,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (rent['ended'] == false) ...[
                      SizedBox(
                        width: double.infinity,
                        child: MyOutlinedButton(
                          text: 'Rendre l\'article',
                          key: const Key('rent_return-button-return_article'),
                          onPressed: () async {
                            bool returnRent =
                                await MyAlertDialog.showChoiceAlertDialog(
                              context: context,
                              title: 'Confirmer le rendu de l\'article',
                              message: 'Voules-vous rendre votre location ?',
                              onOkName: 'Accepter',
                              onCancelName: 'Annuler',
                            );
                            if (returnRent == true) {
                              returnArticle();
                            }
                          },
                        ),
                      ),
                    ] else ...[
                      SizedBox(
                        width: double.infinity,
                        child: Container(
                          decoration: BoxDecoration(
                            color: themeProvider
                                .currentTheme.colorScheme.background,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: Text(
                            'Location déjà rendue',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: themeProvider.currentTheme
                                  .inputDecorationTheme.labelStyle!.color,
                            ),
                          ),
                        ),
                      )
                    ]
                  ],
                ),
              ),
            ),
    );
  }
}
