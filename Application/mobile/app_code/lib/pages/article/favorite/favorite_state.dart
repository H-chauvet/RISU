import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/components/loader.dart';
import 'package:risu/components/toast.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/article/details_page.dart';
import 'package:risu/utils/errors.dart';
import 'package:risu/utils/providers/theme.dart';

import 'favorite_page.dart';

class FavoriteSate extends State<FavoritePage> {
  final LoaderManager _loaderManager = LoaderManager();
  List<dynamic> favorites = [];
  List<dynamic> deletedFavorites = [];

  @override
  void initState() {
    super.initState();
    getFavorites();
  }

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
      if (response.statusCode == 200) {
        setState(() {
          favorites = jsonDecode(response.body)['favorites'];
        });
      } else {
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
          deletedFavorites.remove(articleId);
        });
        return;
      } else {
        if (context.mounted) {
          printServerResponse(context, response, 'createFavorite',
              message: AppLocalizations.of(context)!
                  .errorOccurredDuringCreatingFavorite);
        }
        return;
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

  Future<bool> deleteFavorite(articleId) async {
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
      if (response.statusCode != 200) {
        if (context.mounted) {
          printServerResponse(context, response, 'deleteFavorite',
              message: AppLocalizations.of(context)!
                  .errorOccurredDuringDeletingFavorite);
        }
        return false;
      }
      if (context.mounted) {
        MyToastMessage.show(
            message: AppLocalizations.of(context)!.deletedFromFavorites,
            context: context);
      }
      return true;
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
    return Scaffold(
      appBar: MyAppBar(
        curveColor: themeProvider.currentTheme.secondaryHeaderColor,
        showBackButton: false,
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: themeProvider.currentTheme.colorScheme.background,
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
                                            padding: const EdgeInsets.all(20.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 100,
                                                      width: 100,
                                                      child: Transform.scale(
                                                        scale: 0.6,
                                                        child: Image.asset(
                                                            'assets/volley.png'),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
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
                                                    const SizedBox(height: 10),
                                                    Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .priceXPerHour(
                                                              favorite['item']
                                                                  ['price']),
                                                      style: const TextStyle(
                                                          fontSize: 15.0),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "${AppLocalizations.of(context)!.status}: ",
                                                          style:
                                                              const TextStyle(
                                                                  fontSize:
                                                                      15.0),
                                                        ),
                                                        Container(
                                                          width: 10,
                                                          height: 10,
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: favorite[
                                                                        'item'][
                                                                    'available']
                                                                ? Colors.green
                                                                : Colors.red,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 5),
                                                        Text(
                                                          favorite['item']
                                                                  ['available']
                                                              ? AppLocalizations
                                                                      .of(
                                                                          context)!
                                                                  .available
                                                              : AppLocalizations
                                                                      .of(context)!
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
                                        const Positioned(
                                          right: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Center(
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.chevron_right,
                                                  size: 28,
                                                ),
                                                SizedBox(width: 8),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: IconButton(
                                            key: const Key(
                                                'favorite-button-heart'),
                                            onPressed: () async {
                                              if (deletedFavorites.contains(
                                                  favorite['item']['id'])) {
                                                createFavorite(
                                                    favorite['item']['id']);
                                              } else {
                                                deleteFavorite(
                                                        favorite['item']['id'])
                                                    .then((value) => {
                                                          if (value)
                                                            {
                                                              setState(() {
                                                                deletedFavorites
                                                                    .add(favorite[
                                                                            'item']
                                                                        ['id']);
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
    );
  }
}