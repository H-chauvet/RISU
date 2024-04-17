import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/components/loader.dart';
import 'package:risu/components/outlined_button.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/article/list_page.dart';
import 'package:risu/utils/errors.dart';
import 'package:risu/utils/providers/theme.dart';

import 'details_page.dart';

class ContainerDetailsState extends State<ContainerDetailsPage> {
  int _containerId = -1;
  String _address = '';
  String _city = '';
  int _availableItems = 0;
  final LoaderManager _loaderManager = LoaderManager();

  Future<dynamic> getContainerData(
      BuildContext context, int containerId) async {
    late http.Response response;
    try {
      setState(() {
        _loaderManager.setIsLoading(true);
      });
      response = await http.get(
        Uri.parse('$baseUrl/api/mobile/container/$containerId'),
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
          printServerResponse(context, response, 'getContainerData',
              message:
                  AppLocalizations.of(context)!.errorOccurredDuringGettingData);
        }
        return {
          'address': '',
          'city': '',
          'count': {'available': 0}
        };
      }
    } catch (err, stacktrace) {
      if (context.mounted) {
        setState(() {
          _loaderManager.setIsLoading(false);
        });
        printCatchError(context, err, stacktrace,
            message: AppLocalizations.of(context)!.connectionRefused);
        return {
          'address': '',
          'city': '',
          'count': {'available': 0}
        };
      }
      return {
        'address': '',
        'city': '',
        '_count': {'available': 0}
      };
    }
  }

  @override
  void initState() {
    super.initState();
    _containerId = widget.containerId;
    getContainerData(context, _containerId).then((dynamic value) {
      setState(() {
        _address = value['address'].toString();
        _city = value['city'].toString();
        _availableItems = value['count']['available'];
      });
    });
  }

  int getContainerId() {
    return _containerId;
  }

  String getAddress() {
    return _address;
  }

  String getCity() {
    return _city;
  }

  int getAvailableItems() {
    return _availableItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        curveColor: context.select((ThemeProvider themeProvider) =>
            themeProvider.currentTheme.secondaryHeaderColor),
        showBackButton: false,
        textTitle: AppLocalizations.of(context)!.containerDetails,
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
                        "$_address, $_city",
                        key: const Key('container-details_title'),
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: context.select((ThemeProvider themeProvider) =>
                              themeProvider.currentTheme.primaryColor),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: 300,
                        height: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: const DecorationImage(
                              image: AssetImage('assets/container.png'),
                              fit: BoxFit.cover,
                            )),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: context.select(
                                    (ThemeProvider themeProvider) =>
                                        themeProvider
                                            .currentTheme.secondaryHeaderColor),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: Text(
                                AppLocalizations.of(context)!
                                    .howManyAvailableArticles(_availableItems),
                                key:
                                    const Key('container-details_article-list'),
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: context.select(
                                        (ThemeProvider themeProvider) =>
                                            themeProvider
                                                .currentTheme.primaryColor)),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: MyOutlinedButton(
                          text:
                              AppLocalizations.of(context)!.articlesDisplayList,
                          key: const Key('container-button_article-list-page'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ArticleListPage(
                                  containerId: _containerId,
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
