import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/components/loader.dart';
import 'package:risu/globals.dart';
import 'package:risu/utils/errors.dart';
import 'package:risu/utils/providers/theme.dart';
import 'package:risu/components/outlined_button.dart';
import 'package:risu/components/text_input.dart';

import 'article_list_data.dart';
import 'list_page.dart';

class ArticleListState extends State<ArticleListPage> {
  late int _containerId;
  List<dynamic> _itemsDatas = [];
  List<dynamic> _articleCategories = [];
  final LoaderManager _loaderManager = LoaderManager();

  bool _showFilter = false;
  bool isAscending = true;
  bool isAvailable = true;
  String articleName = '';
  String? selectedCategoryId = 'null';

  Future<dynamic> getArticleCategories() async {
    late http.Response response;

    try {
      setState(() {
        _loaderManager.setIsLoading(true);
      });
      response = await http.get(
        Uri.parse('$baseUrl/api/itemCategory'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      setState(() {
        _loaderManager.setIsLoading(false);
      });
      print('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        dynamic responseData = jsonDecode(response.body);
        return responseData;
      } else {
        if (context.mounted) {
          printServerResponse(context, response, 'getArticleCategories',
              message:
                  AppLocalizations.of(context)!.errorOccurredDuringGettingData);
        }
        return [];
      }
    } catch (err, stacktrace) {
      if (context.mounted) {
        setState(() {
          _loaderManager.setIsLoading(false);
        });
        printCatchError(context, err, stacktrace,
            message: AppLocalizations.of(context)!.connectionRefused);
        return [];
      }
    }
  }

  Future<dynamic> getItemsData(
      BuildContext context, int containerId, String? categoryId) async {
    late http.Response response;

    try {
      setState(() {
        _loaderManager.setIsLoading(true);
      });
      final url = Uri.parse(
          '$baseUrl/api/mobile/container/$containerId/articleslist'
          '?articleName=$articleName&isAscending=$isAscending&isAvailable=$isAvailable${categoryId != null ? '&categoryId=$categoryId' : 'null'}');
      response = await http.get(
        url,
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
      } else if (response.statusCode == 204) {
        return [];
      }
      if (context.mounted) {
        printServerResponse(context, response, 'getItemsData',
            message:
                AppLocalizations.of(context)!.errorOccurredDuringGettingData);
      }
      return [];
    } catch (err, stacktrace) {
      if (context.mounted) {
        setState(() {
          _loaderManager.setIsLoading(false);
        });
        printCatchError(context, err, stacktrace,
            message: AppLocalizations.of(context)!.connectionRefused);
        return [];
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _containerId = widget.containerId;
    getItemsData(context, _containerId, selectedCategoryId)
        .then((dynamic value) {
      setState(() {
        _itemsDatas = value;
      });
    });
    getArticleCategories().then((dynamic value) {
      setState(() {
        _articleCategories = value;
      });
      print('Article categories: $_articleCategories');
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
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: context.select((ThemeProvider themeProvider) =>
          themeProvider.currentTheme.colorScheme.background),
      body: (_loaderManager.getIsLoading())
          ? Center(child: _loaderManager.getLoader())
          : SingleChildScrollView(
              child: Center(
                child: Container(
                  margin: const EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 20.0, bottom: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context)!.articlesList,
                        key: const Key('articles-list_title'),
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: context.select((ThemeProvider themeProvider) =>
                              themeProvider.currentTheme.primaryColor),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        child: MyOutlinedButton(
                          text: AppLocalizations.of(context)!.filter,
                          key: const Key('article-button_show-filters'),
                          onPressed: () {
                            setState(() {
                              _showFilter = !_showFilter;
                            });
                          },
                        ),
                      ),
                      if (_showFilter) const SizedBox(height: 16),
                      if (_showFilter)
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: MyTextInput(
                            key: const Key('filter-textInput_name'),
                            labelText:
                                AppLocalizations.of(context)!.articleName,
                            keyboardType: TextInputType.emailAddress,
                            icon: Icons.article,
                            onChanged: (value) => {
                              setState(() {
                                articleName = value;
                              }),
                              Future.delayed(const Duration(milliseconds: 500),
                                  () {
                                getItemsData(context, _containerId,
                                        selectedCategoryId)
                                    .then((dynamic value) {
                                  setState(() {
                                    _itemsDatas = value;
                                  });
                                });
                              }),
                            },
                          ),
                        ),
                      if (_showFilter) const SizedBox(height: 16),
                      if (_showFilter)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  isAscending = !isAscending!;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                primary: context.select(
                                    (ThemeProvider themeProvider) =>
                                        themeProvider
                                            .currentTheme.primaryColor),
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 24),
                              ),
                              child: Text(
                                '${AppLocalizations.of(context)!.price} : ${isAscending ? AppLocalizations.of(context)!.ascending : AppLocalizations.of(context)!.descending}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: context.select(
                                      (ThemeProvider themeProvider) =>
                                          themeProvider.currentTheme
                                              .secondaryHeaderColor),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  isAvailable = !isAvailable!;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                primary: context.select(
                                    (ThemeProvider themeProvider) =>
                                        themeProvider
                                            .currentTheme.primaryColor),
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 24),
                              ),
                              child: Text(
                                '${AppLocalizations.of(context)!.status} : ${isAvailable ? AppLocalizations.of(context)!.available : AppLocalizations.of(context)!.unavailable}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: context.select(
                                      (ThemeProvider themeProvider) =>
                                          themeProvider.currentTheme
                                              .secondaryHeaderColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      if (_showFilter) const SizedBox(height: 16),
                      if (_showFilter)
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          decoration: BoxDecoration(
                            color: context.select(
                              (ThemeProvider themeProvider) =>
                                  themeProvider.currentTheme.primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SizedBox(
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DropdownButton<String>(
                                    value: selectedCategoryId,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedCategoryId = newValue;
                                        print(
                                            'Selected category: $selectedCategoryId');
                                      });
                                    },
                                    style: TextStyle(
                                      color: context.select(
                                        (ThemeProvider themeProvider) =>
                                            themeProvider
                                                .currentTheme.primaryColor,
                                      ),
                                    ),
                                    dropdownColor: context.select(
                                      (ThemeProvider themeProvider) =>
                                          themeProvider
                                              .currentTheme.primaryColor,
                                    ),
                                    underline: Container(
                                      height: 2,
                                      color: context.select(
                                        (ThemeProvider themeProvider) =>
                                            themeProvider.currentTheme
                                                .secondaryHeaderColor,
                                      ),
                                    ),
                                    items: [
                                      DropdownMenuItem<String>(
                                        value: null,
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .chooseAnArticleCategory,
                                          style: TextStyle(
                                            color: context.select(
                                              (ThemeProvider themeProvider) =>
                                                  themeProvider.currentTheme
                                                      .secondaryHeaderColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                      ..._articleCategories
                                          .map<DropdownMenuItem<String>>(
                                        (dynamic category) {
                                          return DropdownMenuItem<String>(
                                            value: category['id'].toString(),
                                            child: Text(
                                              category['name'],
                                              style: TextStyle(
                                                color: context.select(
                                                  (ThemeProvider
                                                          themeProvider) =>
                                                      themeProvider.currentTheme
                                                          .secondaryHeaderColor,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ).toList(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      if (_itemsDatas.isEmpty) ...[
                        Text(
                          AppLocalizations.of(context)!.articlesListEmpty,
                          key: const Key('articles-list_no-article'),
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: context.select(
                                (ThemeProvider themeProvider) =>
                                    themeProvider.currentTheme.primaryColor),
                            shadows: [
                              Shadow(
                                color: context.select(
                                    (ThemeProvider themeProvider) =>
                                        themeProvider
                                            .currentTheme
                                            .bottomNavigationBarTheme
                                            .selectedItemColor!),
                                blurRadius: 24,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                        )
                      ] else ...[
                        ListView.builder(
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
                      ]
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
