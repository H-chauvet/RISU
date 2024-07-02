import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/components/loader.dart';
import 'package:risu/components/outlined_button.dart';
import 'package:risu/components/toast.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/article/article_list_data.dart';
import 'package:risu/pages/opinion/opinion_page.dart';
import 'package:risu/pages/rent/rent_page.dart';
import 'package:risu/utils/check_signin.dart';
import 'package:risu/utils/errors.dart';
import 'package:risu/utils/providers/theme.dart';
import 'package:risu/utils/image_loader.dart';

import 'details_page.dart';

class ArticleDetailsState extends State<ArticleDetailsPage> {
  ArticleData articleData = ArticleData(
    id: -1,
    containerId: -1,
    name: '',
    available: false,
    price: 0,
    categories: [],
  );
  List<dynamic> similarArticles = [];

  bool isFavorite = false;
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
        checkFavorite(responseData['id']);
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
        'categories': [],
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
          'categories': [],
        };
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

  void createFavorite(articleId) async {
    try {
      setState(() {
        _loaderManager.setIsLoading(true);
      });
      final token = userInformation!.token;
      final response = await http.post(
        Uri.parse('$baseUrl/api/mobile/favorite/$articleId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );
      setState(() {
        _loaderManager.setIsLoading(false);
      });
      if (response.statusCode == 201) {
        setState(() {
          isFavorite = true;
        });
        if (context.mounted) {
          MyToastMessage.show(
              message: AppLocalizations.of(context)!.addedToFavorites,
              context: context);
        }
      } else {
        if (context.mounted) {
          printServerResponse(context, response, 'createFavorite',
              message: AppLocalizations.of(context)!
                  .errorOccurredDuringCreatingFavorite);
        }
      }
    } catch (err, stacktrace) {
      if (mounted) {
        setState(() {
          _loaderManager.setIsLoading(false);
        });
        printCatchError(
          context,
          err,
          stacktrace,
          message: AppLocalizations.of(context)!.connectionRefused,
        );
      }
    }
  }

  Future<void> checkFavorite(articleId) async {
    try {
      if (userInformation == null) return;
      setState(() {
        _loaderManager.setIsLoading(true);
      });
      final token = userInformation!.token;
      final response = await http.get(
        Uri.parse('$baseUrl/api/mobile/favorite/$articleId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );
      setState(() {
        _loaderManager.setIsLoading(false);
      });
      if (response.statusCode == 200) {
        setState(() {
          isFavorite = jsonDecode(response.body);
        });
      } else {
        if (context.mounted) {
          printServerResponse(context, response, 'createFavorite',
              message: AppLocalizations.of(context)!
                  .errorOccurredDuringGettingFavorite);
        }
      }
    } catch (err, stacktrace) {
      if (mounted) {
        setState(() {
          _loaderManager.setIsLoading(false);
        });
        printCatchError(
          context,
          err,
          stacktrace,
          message: AppLocalizations.of(context)!.connectionRefused,
        );
      }
    }
  }

  void deleteFavorite(articleId) async {
    try {
      setState(() {
        _loaderManager.setIsLoading(true);
      });
      final token = userInformation!.token;
      final response = await http.delete(
        Uri.parse('$baseUrl/api/mobile/favorite/$articleId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );
      setState(() {
        _loaderManager.setIsLoading(false);
      });
      if (response.statusCode == 200) {
        setState(() {
          isFavorite = false;
        });
        if (context.mounted) {
          MyToastMessage.show(
              message: AppLocalizations.of(context)!.deletedFromFavorites,
              context: context);
        }
      } else {
        if (context.mounted) {
          printServerResponse(context, response, 'createFavorite',
              message: AppLocalizations.of(context)!
                  .errorOccurredDuringDeletingFavorite);
        }
      }
    } catch (err, stacktrace) {
      if (mounted) {
        setState(() {
          _loaderManager.setIsLoading(false);
        });
        printCatchError(
          context,
          err,
          stacktrace,
          message: AppLocalizations.of(context)!.connectionRefused,
        );
      }
    }
  }

  void getSimilarArticles(BuildContext context) async {
    try {
      setState(() {
        _loaderManager.setIsLoading(true);
      });
      final response = await http.get(
        Uri.parse(
            '$baseUrl/api/mobile/article/${articleData.id}/similar?containerId=${articleData.containerId}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      setState(() {
        _loaderManager.setIsLoading(false);
      });
      if (response.statusCode == 200) {
        dynamic responseData = jsonDecode(response.body);
        setState(() {
          similarArticles = responseData;
        });
      } else {
        if (context.mounted) {
          printServerResponse(context, response, 'getSimilarArticles',
              message:
                  AppLocalizations.of(context)!.errorOccurredDuringGettingData);
        }
      }
    } catch (err, stacktrace) {
      if (mounted) {
        setState(() {
          _loaderManager.setIsLoading(false);
        });
        printCatchError(
          context,
          err,
          stacktrace,
          message: AppLocalizations.of(context)!.connectionRefused,
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.testArticleData.isEmpty) {
      getArticleData(context, widget.articleId).then((dynamic value) {
        setState(() {
          articleData = ArticleData.fromJson(value);
        });
        if (widget.similarArticlesData.isNotEmpty) {
          setState(() {
            similarArticles = widget.similarArticlesData;
          });
        } else {
          getSimilarArticles(context);
        }
      });
    } else {
      setState(() {
        articleData = ArticleData.fromJson(widget.testArticleData);
      });
    }
  }

  IconData getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'beach':
        return Icons.beach_access;
      case 'sports':
        return Icons.sports_soccer;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: MyAppBar(
        curveColor: context.select((ThemeProvider themeProvider) =>
            themeProvider.currentTheme.secondaryHeaderColor),
        showBackButton: false,
        textTitle: AppLocalizations.of(context)!.articleDetails,
        action: IconButton(
          key: const Key('article-button_add-favorite'),
          onPressed: () async {
            bool signIn = await checkSignin(context);
            if (!signIn) {
              return;
            }

            bool backupFavorite = isFavorite;
            await checkFavorite(articleData.id);
            if (backupFavorite != isFavorite) return;
            (isFavorite)
                ? deleteFavorite(articleData.id)
                : createFavorite(articleData.id);
          },
          icon: Icon(
            (isFavorite)
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            size: 28,
            color: themeProvider
                .currentTheme.bottomNavigationBarTheme.selectedItemColor,
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: context.select((ThemeProvider themeProvider) =>
          themeProvider.currentTheme.colorScheme.surface),
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
                              themeProvider.currentTheme.primaryColor),
                        ),
                      ),
                      // icons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        key: const Key('article_categories_icons'),
                        children:
                            articleData.categories.map<Widget>((category) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(
                              getCategoryIcon(category['name']),
                              size: 24.0,
                              color: Theme.of(context).primaryColor,
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: 300,
                        height: 200,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: AssetImage(imageLoader(articleData.name)),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
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
                                            padding: const EdgeInsets.all(8.0),
                                            color: themeProvider.currentTheme
                                                .secondaryHeaderColor,
                                            child: Text(
                                              "${AppLocalizations.of(context)!.currently}: ",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: themeProvider
                                                    .currentTheme.primaryColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Container(
                                            padding: const EdgeInsets.all(8.0),
                                            color: themeProvider.currentTheme
                                                .secondaryHeaderColor,
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 10,
                                                  height: 10,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color:
                                                        articleData.available ==
                                                                true
                                                            ? Colors.green
                                                            : Colors.red,
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                Text(
                                                  articleData.available == true
                                                      ? AppLocalizations.of(
                                                              context)!
                                                          .available
                                                      : AppLocalizations.of(
                                                              context)!
                                                          .unavailable,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: themeProvider
                                                        .currentTheme
                                                        .primaryColor,
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
                                            color: themeProvider
                                                .currentTheme.primaryColor
                                                .withOpacity(0.8),
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .pricePerHour,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: themeProvider
                                                    .currentTheme
                                                    .secondaryHeaderColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Container(
                                            padding: const EdgeInsets.all(8.0),
                                            color: themeProvider
                                                .currentTheme.primaryColor
                                                .withOpacity(0.8),
                                            child: Text(
                                              "${articleData.price}€",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: themeProvider
                                                    .currentTheme
                                                    .secondaryHeaderColor,
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
                      const SizedBox(height: 24),
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
                      ),
                      if (similarArticles.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Text(
                          AppLocalizations.of(context)!.similarArticles,
                          key: const Key('article-similar_title'),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: context.select(
                                (ThemeProvider themeProvider) =>
                                    themeProvider.currentTheme.primaryColor),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: similarArticles
                                .asMap()
                                .entries
                                .map((MapEntry<int, dynamic> entry) {
                              final article = entry.value;
                              final index = entry.key;
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: GestureDetector(
                                  key:
                                      const Key('detail-gesture-go_to_similar'),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ArticleDetailsPage(
                                          articleId: article['id'],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          key: Key(
                                              'article-similar_image_$index'),
                                          padding: const EdgeInsets.all(6.0),
                                          child: Container(
                                            width: 130,
                                            height: 80,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(
                                                  imageLoader(articleData.name),
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          key: Key(
                                              'article-similar_name_$index'),
                                          padding: const EdgeInsets.all(3.0),
                                          child: Text(
                                            article['name'].length > 15
                                                ? article['name']
                                                        .substring(0, 15) +
                                                    '...'
                                                : article['name'],
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          key: Key(
                                              'article-similar_price_$index'),
                                          padding: const EdgeInsets.only(
                                            left: 8.0,
                                            right: 8.0,
                                            bottom: 8.0,
                                          ),
                                          child: Text(
                                            '${AppLocalizations.of(context)!.price} : ${article['price']}€',
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
