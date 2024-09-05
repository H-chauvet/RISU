import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/components/loader.dart';
import 'package:risu/components/pop_scope_parent.dart';
import 'package:risu/components/toast.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/article/details_page.dart';
import 'package:risu/utils/check_signin.dart';
import 'package:risu/utils/errors.dart';
import 'package:risu/utils/image_loader.dart';
import 'package:risu/utils/providers/theme.dart';

import 'favorite_page.dart';

/// FavoritePageState is a StatefulWidget that creates the FavoritePage.
/// It contains the logic for getting, creating and deleting favorites.
/// It also contains the logic for displaying the favorites.
class FavoriteSate extends State<FavoritePage> {
  final LoaderManager _loaderManager = LoaderManager();
  List<dynamic> favorites = [];
  List<dynamic> deletedFavorites = [];

  @override
  void initState() {
    super.initState();
    if (widget.testFavorites.isNotEmpty) {
      favorites = widget.testFavorites;
    } else {
      getFavorites();
    }
  }

  /// getFavorites is a function that gets the favorites of the user.
  /// It sends a GET request to the server to get the favorites.
  void getFavorites() async {
    try {
      if (userInformation == null) return;
      setState(() {
        _loaderManager.setIsLoading(true);
      });
      final token = userInformation!.token;
      final response = await http.get(
        Uri.parse('$baseUrl/api/mobile/favorite'),
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
            favorites = jsonDecode(response.body)['favorites'];
          });
          break;
        case 401:
          await tokenExpiredShowDialog(context);
          break;
        default:
          if (context.mounted) {
            printServerResponse(context, response, 'getFavorites',
                message: AppLocalizations.of(context)!
                    .errorOccurredDuringGettingFavorite);
          }
      }
    } catch (err, stacktrace) {
      if (mounted) {
        setState(() {
          _loaderManager.setIsLoading(false);
        });
        printCatchError(context, err, stacktrace);
      }
    }
  }

  /// createFavorite is a function that creates a favorite.
  /// It sends a POST request to the server to create a favorite.
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
            deletedFavorites.remove(articleId);
          });
          break;
        case 401:
          await tokenExpiredShowDialog(context);
          break;
        default:
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
      return;
    }
  }

  /// deleteFavorite is a function that deletes a favorite.
  /// It sends a DELETE request to the server to delete a favorite.
  Future<bool> deleteFavorite(articleId) async {
    try {
      if (userInformation == null) {
        return false;
      }
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
          MyToastMessage.show(
            message: AppLocalizations.of(context)!.deletedFromFavorites,
            context: context,
          );
          return true;
        case 401:
          await tokenExpiredShowDialog(context);
          return false;
        default:
          if (context.mounted) {
            printServerResponse(context, response, 'deleteFavorite',
                message: AppLocalizations.of(context)!
                    .errorOccurredDuringDeletingFavorite);
          }
          return false;
      }
    } catch (err, stacktrace) {
      if (mounted) {
        setState(() {
          _loaderManager.setIsLoading(false);
        });
        printCatchError(context, err, stacktrace);
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MyPopScope(
      child: Scaffold(
        appBar: MyAppBar(
          curveColor: themeProvider.currentTheme.secondaryHeaderColor,
          showBackButton: false,
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: themeProvider.currentTheme.colorScheme.surface,
        body: (_loaderManager.getIsLoading())
            ? Center(child: _loaderManager.getLoader())
            : Center(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      Text(
                        AppLocalizations.of(context)!.myFavorites,
                        key: const Key('my-favorites-titles'),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                          color: themeProvider.currentTheme.primaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      Expanded(
                        key: const Key('favorite-list'),
                        child: (favorites.isEmpty)
                            ? Center(
                                child: Text(
                                  key: const Key('favorites-list_empty'),
                                  AppLocalizations.of(context)!
                                      .favoritesListEmpty,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: favorites.length,
                                itemBuilder: (BuildContext context, int index) {
                                  dynamic favorite = favorites[index];
                                  return GestureDetector(
                                      key: Key('favorite-card_$index'),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ArticleDetailsPage(
                                                    articleId: favorite['item']
                                                        ['id']),
                                          ),
                                        ).then((value) => getFavorites());
                                      },
                                      child: Stack(
                                        children: [
                                          Card(
                                            elevation: 5,
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            color: themeProvider
                                                .currentTheme.cardColor,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    children: [
                                                      SizedBox(
                                                        key: Key(
                                                            'favorite-image_$index'),
                                                        height: 100,
                                                        width: 100,
                                                        child: Transform.scale(
                                                          scale: 0.7,
                                                          child: Image.asset(
                                                              imageLoader(
                                                                  favorite[
                                                                          'item']
                                                                      [
                                                                      'name'])),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        key: Key(
                                                            'favorite-name_$index'),
                                                        '${favorite['item']['name']}',
                                                        style: TextStyle(
                                                          color: themeProvider
                                                              .currentTheme
                                                              .primaryColor,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20.0,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Text(
                                                        key: Key(
                                                            'favorite-price_$index'),
                                                        AppLocalizations.of(
                                                                context)!
                                                            .priceXPerHour(
                                                                favorite['item']
                                                                    ['price']),
                                                        style: const TextStyle(
                                                            fontSize: 15.0),
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            key: Key(
                                                                'favorite-status_$index'),
                                                            "${AppLocalizations.of(context)!.status}: ",
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        15.0),
                                                          ),
                                                          Container(
                                                            key: Key(
                                                                'favorite-status_circle_$index'),
                                                            width: 10,
                                                            height: 10,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: favorite[
                                                                          'item']
                                                                      [
                                                                      'available']
                                                                  ? Colors.green
                                                                  : Colors.red,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 5),
                                                          Text(
                                                            key: Key(
                                                                'favorite-status_text_$index'),
                                                            favorite['item'][
                                                                    'available']
                                                                ? AppLocalizations.of(
                                                                        context)!
                                                                    .available
                                                                : AppLocalizations.of(
                                                                        context)!
                                                                    .unavailable,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        15.0),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            right: 0,
                                            top: 0,
                                            bottom: 0,
                                            child: Center(
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    key: Key(
                                                        'favorite-arrow_$index'),
                                                    Icons.chevron_right,
                                                    size: 28,
                                                  ),
                                                  const SizedBox(width: 8),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: IconButton(
                                              key: Key(
                                                  'favorite-button_heart_$index'),
                                              onPressed: () async {
                                                if (deletedFavorites.contains(
                                                    favorite['item']['id'])) {
                                                  createFavorite(
                                                      favorite['item']['id']);
                                                } else {
                                                  deleteFavorite(
                                                          favorite['item']
                                                              ['id'])
                                                      .then((value) => {
                                                            if (value)
                                                              {
                                                                setState(() {
                                                                  deletedFavorites
                                                                      .add(favorite[
                                                                              'item']
                                                                          [
                                                                          'id']);
                                                                }),
                                                              }
                                                          });
                                                }
                                              },
                                              icon: Icon(
                                                deletedFavorites.contains(
                                                        favorite['item']['id'])
                                                    ? Icons.favorite_border
                                                    : Icons.favorite_rounded,
                                                size: 28,
                                                color: themeProvider
                                                    .currentTheme
                                                    .bottomNavigationBarTheme
                                                    .selectedItemColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ));
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
