import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/components/loader.dart';
import 'package:risu/components/outlined_button.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/article/article_list_data.dart';
import 'package:risu/pages/opinion/opinion_page.dart';
import 'package:risu/pages/rent/rent_page.dart';
import 'package:risu/utils/check_signin.dart';
import 'package:risu/utils/errors.dart';
import 'package:risu/utils/providers/theme.dart';

import 'details_page.dart';

class ArticleDetailsState extends State<ArticleDetailsPage> {
  ArticleData articleData = ArticleData(
    id: -1,
    containerId: -1,
    name: '',
    available: false,
    price: 0,
  );
  final LoaderManager _loaderManager = LoaderManager();

  Future<dynamic> getArticleData(BuildContext context, int articleId) async {
    late http.Response response;

    try {
      setState(() {
        _loaderManager.setIsLoading(true);
      });
      response = await http.get(
        Uri.parse('$baseUrl/api/mobile/article/$articleId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      setState(() {
        _loaderManager.setIsLoading(false);
      });
      if (response.statusCode == 200) {
        dynamic responseData = jsonDecode(response.body);
        return responseData;
      } else {
        if (context.mounted) {
          printServerResponse(
            context,
            response,
            'getArticleData',
            message:
                AppLocalizations.of(context)!.errorOccurredDuringGettingData,
          );
        }
      }
      return {
        'id': -1,
        'containerId': -1,
        'name': '',
        'available': false,
        'price': 0,
      };
    } catch (err, stacktrace) {
      if (context.mounted) {
        setState(() {
          _loaderManager.setIsLoading(false);
        });
        printCatchError(
          context,
          err,
          stacktrace,
          message: AppLocalizations.of(context)!.connectionRefused,
        );
        return {
          'id': -1,
          'containerId': -1,
          'name': '',
          'available': false,
          'price': 0,
        };
      }
    }
  }

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
          : SingleChildScrollView(
              child: Center(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
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
                              color: context.select(
                                  (ThemeProvider themeProvider) => themeProvider
                                      .currentTheme.secondaryHeaderColor),
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
                          ),
                        ),
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
                                      (ThemeProvider themeProvider) =>
                                          themeProvider.currentTheme.colorScheme
                                              .background),
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
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              color: themeProvider
                                                  .currentTheme.primaryColor,
                                              child: Text(
                                                "${AppLocalizations.of(context)!.currently}: ",
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              color: themeProvider
                                                  .currentTheme.primaryColor,
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 10,
                                                    height: 10,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: articleData
                                                                  .available ==
                                                              true
                                                          ? Colors.green
                                                          : Colors.red,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    articleData.available ==
                                                            true
                                                        ? AppLocalizations.of(
                                                                context)!
                                                            .available
                                                        : AppLocalizations.of(
                                                                context)!
                                                            .unavailable,
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              color: themeProvider
                                                  .currentTheme.primaryColor
                                                  .withOpacity(0.6),
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .pricePerHour,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              color: themeProvider
                                                  .currentTheme.primaryColor
                                                  .withOpacity(0.6),
                                              child: Text(
                                                "${articleData.price}€",
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
                      const SizedBox(height: 16),
                      if (articleData.available)
                        SizedBox(
                          width: double.infinity,
                          child: MyOutlinedButton(
                            text: AppLocalizations.of(context)!.rentThisArticle,
                            key: const Key('article-button_article-rent'),
                            onPressed: () async {
                              bool signIn = await checkSignin(context);
                              if (!signIn) {
                                return;
                              }
                              if (context.mounted) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RentArticlePage(
                                      articleData: articleData,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: MyOutlinedButton(
                          text: AppLocalizations.of(context)!
                              .consultArticleOpinions,
                          key: const Key('article-button_article-opinion'),
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OpinionPage(
                                  itemId: articleData.id,
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
