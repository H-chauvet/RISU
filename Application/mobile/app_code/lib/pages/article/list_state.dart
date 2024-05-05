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
import 'package:risu/components/filled_button.dart';

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
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: MyTextInput(
                                key: const Key('filter-textInput_name'),
                                labelText:
                                    AppLocalizations.of(context)!.articleName,
                                keyboardType: TextInputType.text,
                                icon: Icons.article,
                                rightIcon: Icons.filter_list,
                                rightIconOnPressed: () async {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                          AppLocalizations.of(context)!.filter,
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              width: double.infinity,
                                              child: MyOutlinedButton(
                                                text:
                                                    '${AppLocalizations.of(context)!.price} : ${isAscending ? AppLocalizations.of(context)!.ascending : AppLocalizations.of(context)!.descending}',
                                                key: const Key(
                                                    'article-button_filter-ascending'),
                                                onPressed: () {
                                                  setState(() {
                                                    isAscending = !isAscending!;
                                                    getItemsData(
                                                      context,
                                                      _containerId,
                                                      selectedCategoryId,
                                                    ).then((dynamic value) {
                                                      setState(() {
                                                        _itemsDatas = value;
                                                      });
                                                    });
                                                  });
                                                },
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            SizedBox(
                                              width: double.infinity,
                                              child: MyOutlinedButton(
                                                text:
                                                    '${AppLocalizations.of(context)!.status} : ${isAvailable ? AppLocalizations.of(context)!.available : AppLocalizations.of(context)!.unavailable}',
                                                key: const Key(
                                                    'article-button_filter-available'),
                                                onPressed: () {
                                                  setState(() {
                                                    isAvailable = !isAvailable!;
                                                    getItemsData(
                                                      context,
                                                      _containerId,
                                                      selectedCategoryId,
                                                    ).then((dynamic value) {
                                                      setState(() {
                                                        _itemsDatas = value;
                                                      });
                                                    });
                                                  });
                                                },
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            SizedBox(
                                              width: double.infinity,
                                              child: Container(
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: context.select(
                                                        (ThemeProvider
                                                                themeProvider) =>
                                                            themeProvider
                                                                .currentTheme
                                                                .buttonTheme
                                                                .colorScheme!
                                                                .secondary),
                                                    width: 2,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                child: DropdownButton<String>(
                                                  value: selectedCategoryId,
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      selectedCategoryId =
                                                          newValue;
                                                      getItemsData(
                                                        context,
                                                        _containerId,
                                                        selectedCategoryId,
                                                      ).then((dynamic value) {
                                                        setState(() {
                                                          _itemsDatas = value;
                                                        });
                                                      });
                                                    });
                                                  },
                                                  style: TextStyle(
                                                    color: context.select(
                                                        (ThemeProvider
                                                                themeProvider) =>
                                                            themeProvider
                                                                .currentTheme
                                                                .primaryColor),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.0,
                                                  ),
                                                  dropdownColor: context.select(
                                                      (ThemeProvider
                                                              themeProvider) =>
                                                          themeProvider
                                                              .currentTheme
                                                              .secondaryHeaderColor),
                                                  underline: Container(
                                                    height: 0,
                                                    color: context.select(
                                                      (ThemeProvider
                                                              themeProvider) =>
                                                          themeProvider
                                                              .currentTheme
                                                              .secondaryHeaderColor,
                                                    ),
                                                  ),
                                                  icon: Icon(
                                                    Icons.arrow_drop_down,
                                                    color: context.select(
                                                      (ThemeProvider
                                                              themeProvider) =>
                                                          themeProvider
                                                              .currentTheme
                                                              .primaryColor,
                                                    ),
                                                  ),
                                                  elevation: 3,
                                                  items: [
                                                    DropdownMenuItem<String>(
                                                      value: 'null',
                                                      child: Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .allCategories,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                    for (var category
                                                        in _articleCategories)
                                                      DropdownMenuItem<String>(
                                                        value: category['id']
                                                            .toString(),
                                                        child: Text(
                                                          category['name'],
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          Row(
                                            children: [
                                              MyButton(
                                                key: const Key(
                                                    'article-button_article-rent'),
                                                text: AppLocalizations.of(
                                                        context)!
                                                    .close,
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
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
