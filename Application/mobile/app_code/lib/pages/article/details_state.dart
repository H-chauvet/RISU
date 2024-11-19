import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/components/loader.dart';
import 'package:risu/components/outlined_button.dart';
import 'package:risu/components/pop_scope_parent.dart';
import 'package:risu/components/toast.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/article/article_list_data.dart';
import 'package:risu/pages/opinion/opinion_page.dart';
import 'package:risu/pages/rent/rent_page.dart';
import 'package:risu/utils/check_signin.dart';
import 'package:risu/utils/errors.dart';
import 'package:risu/utils/image_loader.dart';
import 'package:risu/utils/providers/theme.dart';
import 'package:risu/utils/share_deeplink.dart';

import 'details_page.dart';

/// ArticleDetailsState class
/// This class is used to display the details of an article
class ArticleDetailsState extends State<ArticleDetailsPage> {
  ArticleData articleData = ArticleData(
    id: -1,
    containerId: -1,
    name: '',
    available: false,
    price: 0,
    categories: [],
    status: Status.VERYWORN,
    imagesUrl: null,
  );
  List<dynamic> similarArticles = [];
  List<dynamic> opinionsList = [];
  int maxOpinionsDisplayed = 5;

  bool isFavorite = false;
  final LoaderManager _loaderManager = LoaderManager();
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  int indexImage = 0;
  int nbImages = 0;

  /// getArticleData method
  /// This method is used to get the data of an article
  /// params:
  /// [context] - the context of the application.
  /// [articleId] - the id of the article.
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
      switch (response.statusCode) {
        case 200:
          dynamic responseData = jsonDecode(response.body);
          checkFavorite(responseData['id']);
          return responseData;
        default:
          if (context.mounted) {
            printServerResponse(
              context,
              response,
              'getArticleData',
              message:
                  AppLocalizations.of(context)!.errorOccurredDuringGettingData,
            );
          }
          break;
      }
      return {
        'id': -1,
        'containerId': -1,
        'name': '',
        'available': false,
        'price': 0,
        'categories': [],
        'imagesUrl': null,
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
          'imagesUrl': null,
        };
      }
      return {
        'id': '',
        'containerId': '',
        'name': '',
        'available': false,
        'price': 0,
        'categories': [],
        'imagesUrl': null,
      };
    }
  }

  /// createFavorite method
  /// This method is used to create a favorite article
  /// params:
  /// [articleId] - the id of the article.
  void getOpinions(itemId) async {
    try {
      setState(() {
        _loaderManager.setIsLoading(true);
      });
      final response = await http.get(
        Uri.parse('$baseUrl/api/mobile/opinion?itemId=$itemId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${userInformation?.token}',
        },
      );
      setState(() {
        _loaderManager.setIsLoading(false);
      });
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          opinionsList = data['opinions'];
        });
      } else {
        if (mounted) {
          printServerResponse(context, response, 'getOpinions',
              message: AppLocalizations.of(context)!
                  .errorOccurredDuringGettingReviews);
        }
      }
    } catch (err, stacktrace) {
      if (mounted) {
        setState(() {
          _loaderManager.setIsLoading(false);
        });
        printCatchError(context, err, stacktrace,
            message: AppLocalizations.of(context)!
                .errorOccurredDuringGettingReviews);
        return;
      }
      return;
    }
  }

  /// createFavorite method
  /// This method is used to create a favorite article
  /// params:
  /// [articleId] - the id of the article.
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
      switch (response.statusCode) {
        case 201:
          setState(() {
            isFavorite = true;
          });
          if (context.mounted) {
            MyToastMessage.show(
              message: AppLocalizations.of(context)!.addedToFavorites,
              context: context,
            );
          }
          break;
        case 401:
          await tokenExpiredShowDialog(context);
          break;
        default:
          if (context.mounted) {
            printServerResponse(
              context,
              response,
              'createFavorite',
              message: AppLocalizations.of(context)!
                  .errorOccurredDuringCreatingFavorite,
            );
          }
          break;
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

  /// _getStatusTranslation
  /// This method is used to get the good translation
  /// params:
  /// [status] - the status enum
  /// [context] - the application context
  String _getStatusTranslation(Status status, BuildContext context) {
    switch (status) {
      case Status.GOOD:
        return AppLocalizations.of(context)!.goodStatus;
      case Status.WORN:
        return AppLocalizations.of(context)!.wornStatus;
      case Status.VERYWORN:
        return AppLocalizations.of(context)!.veryWornStatus;
    }
  }

  /// checkFavorite method
  /// This method is used to check if the article is a favorite
  /// It returns the favorite status of the article
  /// params:
  /// [articleId] - the id of the article.
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
      switch (response.statusCode) {
        case 200:
          setState(() {
            isFavorite = jsonDecode(response.body);
          });
          break;
        case 401:
          await tokenExpiredShowDialog(context);
          break;
        default:
          if (context.mounted) {
            printServerResponse(
              context,
              response,
              'checkFavorite',
              message: AppLocalizations.of(context)!
                  .errorOccurredDuringGettingFavorite,
            );
          }
          break;
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

  /// deleteFavorite method
  /// This method is used to delete a favorite article
  /// params:
  /// [articleId] - the id of the article.
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
      switch (response.statusCode) {
        case 200:
          setState(() {
            isFavorite = false;
          });
          if (context.mounted) {
            MyToastMessage.show(
              message: AppLocalizations.of(context)!.deletedFromFavorites,
              context: context,
            );
          }
          break;
        case 401:
          await tokenExpiredShowDialog(context);
          break;
        default:
          if (context.mounted) {
            printServerResponse(
              context,
              response,
              'deleteFavorite',
              message: AppLocalizations.of(context)!
                  .errorOccurredDuringDeletingFavorite,
            );
          }
          break;
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

  /// getSimilarArticles method
  /// This method is used to get the similar articles
  /// params:
  /// [context] - the context of the application.
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
      switch (response.statusCode) {
        case 200:
          dynamic responseData = jsonDecode(response.body);
          setState(() {
            similarArticles = responseData;
          });
          break;
        default:
          if (context.mounted) {
            printServerResponse(
              context,
              response,
              'getSimilarArticles',
              message:
                  AppLocalizations.of(context)!.errorOccurredDuringGettingData,
            );
          }
          break;
      }
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
          nbImages = 0;
          if (articleData.imagesUrl != null) {
            nbImages = articleData.imagesUrl!.length;
          }
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
    getOpinions(widget.articleId);
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

    return MyPopScope(
      child: Scaffold(
        appBar: MyAppBar(
          curveColor: context.select((ThemeProvider themeProvider) =>
              themeProvider.currentTheme.secondaryHeaderColor),
          showBackButton: false,
          textTitle: AppLocalizations.of(context)!.articleDetails,
          action: Row(
            children: [
              IconButton(
                onPressed: () {
                  createDeeplink(
                      path: 'article/?id=${articleData.id}', context: context);
                },
                icon: Icon(
                  Icons.share,
                  color: context.select((ThemeProvider themeProvider) =>
                      themeProvider.currentTheme.bottomNavigationBarTheme
                          .selectedItemColor),
                ),
              ),
              IconButton(
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
            ],
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
                    margin: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          articleData.name,
                          key: const Key('article-details_title'),
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: context.select(
                                (ThemeProvider themeProvider) =>
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
                        Stack(
                          children: [
                            if (nbImages > 0) ...[
                              if (nbImages > 1) ...[
                                CarouselSlider(
                                  carouselController: _carouselController,
                                  options: CarouselOptions(
                                    initialPage: 0,
                                    autoPlay: true,
                                    viewportFraction: 1.0,
                                    onPageChanged: (index, reason) {
                                      setState(() {
                                        indexImage = index;
                                      });
                                    },
                                  ),
                                  items: articleData.imagesUrl!
                                      .map<Widget>((image) {
                                    return loadImageFromURL(image);
                                  }).toList(),
                                ),
                              ] else ...[
                                loadImageFromURL(articleData.imagesUrl![0]),
                              ],
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  color: Colors.black54,
                                  child: Text(
                                    '${indexImage + 1} / $nbImages',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 8,
                                    ),
                                  ),
                                ),
                              ),
                            ] else ...[
                              Container(
                                width: 200,
                                height: 200,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/no_image.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ]
                          ],
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(top: 32, bottom: 8),
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
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              color: themeProvider
                                                  .currentTheme.primaryColor
                                                  .withOpacity(0.8),
                                              child: Text(
                                                "${AppLocalizations.of(context)!.condition}:",
                                                style: TextStyle(
                                                  fontSize: 16,
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
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              color: themeProvider
                                                  .currentTheme.primaryColor
                                                  .withOpacity(0.8),
                                              child: Text(
                                                _getStatusTranslation(
                                                    articleData.status,
                                                    context),
                                                style: TextStyle(
                                                  fontSize: 16,
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
                                      TableRow(
                                        children: [
                                          TableCell(
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              color: themeProvider.currentTheme
                                                  .secondaryHeaderColor,
                                              child: Text(
                                                "${AppLocalizations.of(context)!.currently}:",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: themeProvider
                                                      .currentTheme
                                                      .primaryColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              color: themeProvider.currentTheme
                                                  .secondaryHeaderColor,
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 8,
                                                    height: 8,
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
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              color: themeProvider
                                                  .currentTheme.primaryColor
                                                  .withOpacity(0.8),
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .pricePerHour,
                                                style: TextStyle(
                                                  fontSize: 16,
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
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              color: themeProvider
                                                  .currentTheme.primaryColor
                                                  .withOpacity(0.8),
                                              child: Text(
                                                "${articleData.price}€",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: themeProvider
                                                      .currentTheme
                                                      .secondaryHeaderColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        articleData.description != ""
                            ? Text(
                                '${AppLocalizations.of(context)!.description}: ${articleData.description}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : Container(),
                        const SizedBox(height: 24),
                        if (articleData.available)
                          SizedBox(
                            width: double.infinity,
                            child: MyOutlinedButton(
                              text:
                                  AppLocalizations.of(context)!.rentThisArticle,
                              key: const Key('article-button_article-rent'),
                              onPressed: () async {
                                bool signIn = await checkSignin(context);
                                if (!signIn || !context.mounted) {
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
                        GestureDetector(
                          key: const Key('article_details-opinion_see_all'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OpinionPage(
                                  itemId: articleData.id,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.opinions,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Icon(Icons.arrow_forward),
                              ],
                            ),
                          ),
                        ),
                        if (opinionsList.isNotEmpty)
                          for (var i = 0;
                              i < opinionsList.length &&
                                  i < maxOpinionsDisplayed;
                              i++)
                            Card(
                              key: Key('opinion-card_$i'),
                              elevation: 5,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              color: context.select(
                                  (ThemeProvider themeProvider) => themeProvider
                                      .currentTheme
                                      .inputDecorationTheme
                                      .fillColor),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 15, 15, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          key: Key('opinion-user_$i'),
                                          child: Text(
                                            (opinionsList[i]['user'] != null &&
                                                    opinionsList[i]['user']
                                                            ['firstName'] !=
                                                        null &&
                                                    opinionsList[i]['user']
                                                            ['lastName'] !=
                                                        null)
                                                ? '${opinionsList[i]['user']['firstName']} ${opinionsList[i]['user']['lastName']}'
                                                : AppLocalizations.of(context)!
                                                    .anonymous,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ListTile(
                                    contentPadding: const EdgeInsets.all(20)
                                        .copyWith(top: 0),
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: List.generate(
                                            5,
                                            (index) => Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 2),
                                              child: Icon(
                                                key: Key(
                                                    'opinion-star_$i-$index'),
                                                index <
                                                        int.parse(
                                                            opinionsList[i]
                                                                ['note'])
                                                    ? Icons.star
                                                    : Icons.star_border,
                                                color: index <
                                                        int.parse(
                                                            opinionsList[i]
                                                                ['note'])
                                                    ? Colors.yellow
                                                    : Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          key: Key('opinion-comment_$i'),
                                          opinionsList[i]['comment'],
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        if (opinionsList.isEmpty) ...[
                          const SizedBox(height: 16),
                          Text(
                            key: const Key('opinion-empty_text'),
                            AppLocalizations.of(context)!.reviewsEmpty,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                        if (similarArticles.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  key: const Key('article-similar_title'),
                                  AppLocalizations.of(context)!.similarArticles,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: GestureDetector(
                                    key: const Key(
                                        'detail-gesture-go_to_similar'),
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
                                            child: loadImageFromURL(
                                              article['imageUrl'],
                                              maxHeight: 120,
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
      ),
    );
  }
}
