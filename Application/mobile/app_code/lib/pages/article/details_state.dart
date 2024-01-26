import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/components/outlined_button.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/article/article_list_data.dart';
import 'package:risu/pages/container/details_page.dart';
import 'package:risu/pages/rent/rent_page.dart';
import 'package:risu/utils/errors.dart';
import 'package:risu/utils/theme.dart';

import 'details_page.dart';

Future<dynamic> getArticleData(BuildContext context, String articleId) async {
  late http.Response response;

  try {
    response = await http.get(
      Uri.parse('http://$serverIp:8080/api/article/$articleId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      dynamic responseData = jsonDecode(response.body);
      return responseData;
    } else {
      if (context.mounted) {
        printServerResponse(context, response, 'getArticleData',
            message:
                "Une erreur est survenue lors de la récupération des données");
      }
    }
    return {
      'id': '',
      'containerId': '',
      'name': '',
      'available': false,
      'price': 0,
    };
  } catch (err, stacktrace) {
    if (context.mounted) {
      printCatchError(context, err, stacktrace, message: "Connexion refusée.");
    }
    return {
      'id': '',
      'containerId': '',
      'name': '',
      'available': false,
      'price': 0,
    };
  }
}

class ArticleDetailsState extends State<ArticleDetailsPage> {
  ArticleData articleData = ArticleData(
      id: '', containerId: '', name: '', available: false, price: 0);

  @override
  void initState() {
    super.initState();
    getArticleData(context, widget.articleId).then((dynamic value) {
      setState(() {
        articleData = ArticleData.fromJson(value);
      });
    });
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
                  articleData.name,
                  key: const Key('article-details_title'),
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
                        image: AssetImage('assets/volley.png'),
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
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Container(
                            color: context.select(
                                (ThemeProvider themeProvider) => themeProvider
                                    .currentTheme.colorScheme.background),
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
                                        color: context.select(
                                            (ThemeProvider themeProvider) =>
                                                themeProvider
                                                    .currentTheme.primaryColor),
                                        child: const Text(
                                          'Actuellement :',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        color: context.select(
                                            (ThemeProvider themeProvider) =>
                                                themeProvider
                                                    .currentTheme.primaryColor),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 10,
                                              height: 10,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: articleData.available ==
                                                        true
                                                    ? Colors.green
                                                    : Colors.red,
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              (articleData.available)
                                                  ? 'Disponible'
                                                  : 'indisponible',
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
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
                                        color: context
                                            .select(
                                                (ThemeProvider themeProvider) =>
                                                    themeProvider.currentTheme
                                                        .primaryColor)
                                            .withOpacity(0.6),
                                        child: const Text(
                                          'Prix à l\'heure :',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        color: context
                                            .select(
                                                (ThemeProvider themeProvider) =>
                                                    themeProvider.currentTheme
                                                        .primaryColor)
                                            .withOpacity(0.6),
                                        child: Text(
                                          '${articleData.price} €',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
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
                SizedBox(
                  width: double.infinity,
                  child: MyOutlinedButton(
                    text: 'Afficher le conteneur lié',
                    key: const Key('article-button_container-details'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ContainerDetailsPage(
                            containerId: articleData.containerId,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                if (articleData.available)
                  SizedBox(
                    width: double.infinity,
                    child: MyOutlinedButton(
                      text: 'Louer cet article',
                      key: const Key('article-button_article-rent'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RentArticlePage(
                              articleData: articleData,
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
