import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/components/loader.dart';
import 'package:risu/components/text_input.dart';
import 'package:risu/globals.dart';
import 'package:risu/utils/errors.dart';
import 'package:risu/utils/providers/theme.dart';

import 'article_filters_page.dart';
import 'article_list_data.dart';
import 'list_page.dart';

class ArticleListState extends State<ArticleListPage> {
  late Timer _debounceTimer;
  late int _containerId;
  List<dynamic> _itemsDatas = [];
  List<dynamic> _articleCategories = [];
  final LoaderManager _loaderManager = LoaderManager();

  String? sortBy = 'price';
  double? min;
  double? max;
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
          '?articleName=$articleName&isAscending=$isAscending&isAvailable=$isAvailable${categoryId != null ? '&categoryId=$categoryId' : 'null'}&sortBy=$sortBy${min != null ? '&min=$min' : ''}${max != null ? '&max=$max' : ''}');
      response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        dynamic responseData = jsonDecode(response.body);
        return responseData;
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
  void dispose() {
    _debounceTimer.cancel();
    super.dispose();
  }

  void _onTextChanged(String value) {
    _debounceTimer.cancel();
    _debounceTimer = Timer(Duration(milliseconds: 500), () {
      setState(() {
        articleName = value;
      });
      updateItemsList();
    });
  }

  @override
  void initState() {
    super.initState();
    _debounceTimer = Timer(Duration.zero, () {});
    _containerId = widget.containerId;
    setState(() {
      _itemsDatas = widget.testItemData;
    });
    if (_itemsDatas.isEmpty) {
      getItemsData(context, _containerId, selectedCategoryId)
          .then((dynamic value) {
        setState(() {
          _itemsDatas = value;
        });
      });
    }
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
                                onChanged: (value) {
                                  _onTextChanged(value);
                                },
                                labelText:
                                    AppLocalizations.of(context)!.articleName,
                                keyboardType: TextInputType.text,
                                icon: Icons.search,
                                rightIcon: Icons.tune,
                                rightIconKey: const Key('list-icon-filter'),
                                rightIconOnPressed: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ArticleFiltersPage(
                                        isAscending: isAscending,
                                        isAvailable: isAvailable,
                                        selectedCategoryId: selectedCategoryId,
                                        sortBy: sortBy,
                                        articleCategories: _articleCategories,
                                      ),
                                    ),
                                  ).then((filters) {
                                    if (filters != null) {
                                      setState(() {
                                        isAscending = filters['isAscending'];
                                        isAvailable = filters['isAvailable'];
                                        selectedCategoryId =
                                            filters['selectedCategoryId'];
                                        sortBy = filters['sortBy'];
                                        min = filters['min'];
                                        max = filters['max'];
                                        updateItemsList();
                                      });
                                    }
                                  });
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
