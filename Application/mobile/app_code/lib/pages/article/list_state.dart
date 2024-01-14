import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:risu/components/alert_dialog.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/components/outlined_button.dart';
import 'package:risu/globals.dart';
import 'package:risu/utils/theme.dart';

import 'list_page.dart';
import 'article_list_data.dart';

Future<dynamic> getItemsData(BuildContext context, String containerId) async {
  final token = userInformation?.token ?? 'defaultToken';
  late http.Response response;

  try {
    response = await http.get(
      Uri.parse(
          'http://$serverIp:8080/api/container/articleslist/${containerId}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      dynamic responseData = jsonDecode(response.body);
      return responseData;
    } else if (response.statusCode == 200) {
      return null;
    } else {
      if (context.mounted) {
        print(response.statusCode);
        print(response.reasonPhrase);
        await MyAlertDialog.showErrorAlertDialog(
            key: const Key('article-list_invaliddata'),
            context: context,
            title: 'Article-list',
            message: 'Failed to get article list');
      }
    }
  } catch (err) {
    if (context.mounted) {
      await MyAlertDialog.showErrorAlertDialog(
          key: const Key('article-list_connectionrefused'),
          context: context,
          title: 'Article-list',
          message: 'connexion refused');
    }
  }
}

class ArticleListState extends State<ArticleListPage> {
  late String _containerId;
  List<dynamic> _itemsDatas = [];

  @override
  void initState() {
    super.initState();
    _containerId = widget.containerId;
    getItemsData(context, _containerId).then((dynamic value) {
      setState(() {
        _itemsDatas = value;
      });
    });
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
            margin: EdgeInsets.only(
                left: 10.0, right: 10.0, top: 20.0, bottom: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                Text(
                  'Liste des articles',
                  key: const Key('articles-list_title'),
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4682B4),
                  ),
                ),
                const SizedBox(height: 16),
                (_itemsDatas.length == 0)
                    ? Text(
                        'Aucun articles disponibles pour ce conteneur',
                        key: const Key('articles-list_no-article'),
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4682B4),
                        ),
                      )
                    : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _itemsDatas.length,
                        itemBuilder: (context, index) {
                          final item = _itemsDatas.elementAt(index);
                          return ArticleDataCard(
                            articleData: ArticleData.fromJson(item),
                          );
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
