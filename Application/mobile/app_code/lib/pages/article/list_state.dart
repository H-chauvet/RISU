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

  bool isAscending = true;
  bool isAvailable = true;
  String articleName = '';
  String? selectedCategoryId = 'null';
  TextEditingController _searchController = TextEditingController();

  void updateItemsList() {
    getItemsData(context, _containerId, selectedCategoryId)
        .then((dynamic value) {
      setState(() {
        _itemsDatas = value;
      });
    });
  }

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
      final url = Uri.parse(
          '$baseUrl/api/mobile/container/$containerId/articleslist'
          '?articleName=$articleName&isAscending=$isAscending&isAvailable=$isAvailable${categoryId != null ? '&categoryId=$categoryId' : 'null'}');
      response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
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
        printCatchError(context, err, stacktrace,
            message: AppLocalizations.of(context)!.connectionRefused);
        return [];
      }
      return [];
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
    });
    _searchController.addListener(() {
      setState(() {
        articleName = _searchController.text;
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
        textTitle: AppLocalizations.of(context)!.articlesList,
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
                      const SizedBox(height: 16),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: MyTextInput(
                          key: const Key('filter-textInput_name'),
                          labelText: AppLocalizations.of(context)!.articleName,
                          keyboardType: TextInputType.text,
                          icon: Icons.article,
                          onChanged: (value) => {
                            setState(() {
                              articleName = value;
                            }),
                            getItemsData(
                                    context, _containerId, selectedCategoryId)
                                .then((dynamic value) {
                              setState(() {
                                _itemsDatas = value;
                              });
                            }),
                          },
                        ),
                      ),
                      const SizedBox(height: 32),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  isAscending = !isAscending!;
                                  getItemsData(context, _containerId,
                                          selectedCategoryId)
                                      .then((dynamic value) {
                                    setState(() {
                                      _itemsDatas = value;
                                    });
                                  });
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: context.select(
                                  (ThemeProvider themeProvider) =>
                                      themeProvider.currentTheme.primaryColor,
                                ),
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
                                  getItemsData(context, _containerId,
                                          selectedCategoryId)
                                      .then((dynamic value) {
                                    setState(() {
                                      _itemsDatas = value;
                                    });
                                  });
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 3,
                                backgroundColor: context.select(
                                  (ThemeProvider themeProvider) =>
                                      themeProvider.currentTheme.primaryColor,
                                ),
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
                            const SizedBox(width: 16),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.45,
                              // padding left
                              padding: const EdgeInsets.only(left: 7),
                              decoration: BoxDecoration(
                                color: context.select(
                                  (ThemeProvider themeProvider) =>
                                      themeProvider.currentTheme.primaryColor,
                                ),
                                borderRadius: BorderRadius.circular(
                                    10), // Adjust the value as needed
                              ),
                              child: DropdownButton<String>(
                                value: selectedCategoryId,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedCategoryId = newValue;
                                    getItemsData(context, _containerId,
                                            selectedCategoryId)
                                        .then((dynamic value) {
                                      setState(() {
                                        _itemsDatas = value;
                                      });
                                    });
                                  });
                                },
                                style: TextStyle(
                                  color: context.select(
                                    (ThemeProvider themeProvider) =>
                                        themeProvider.currentTheme.primaryColor,
                                  ),
                                ),
                                dropdownColor: context.select(
                                  (ThemeProvider themeProvider) =>
                                      themeProvider.currentTheme.primaryColor,
                                ),
                                underline: Container(
                                  height: 0,
                                  color: context.select(
                                    (ThemeProvider themeProvider) =>
                                        themeProvider
                                            .currentTheme.secondaryHeaderColor,
                                  ),
                                ),
                                items: [
                                  DropdownMenuItem<String>(
                                    value:
                                        'null', // Assurez-vous que la valeur n'est pas null
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .allCategories,
                                      style: TextStyle(
                                        color: context.select(
                                          (ThemeProvider themeProvider) =>
                                              themeProvider.currentTheme
                                                  .secondaryHeaderColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  for (var category in _articleCategories)
                                    DropdownMenuItem<String>(
                                      value: category['id'].toString(),
                                      child: Text(
                                        category['name'],
                                        style: TextStyle(
                                          color: context.select(
                                            (ThemeProvider themeProvider) =>
                                                themeProvider.currentTheme
                                                    .secondaryHeaderColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
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
