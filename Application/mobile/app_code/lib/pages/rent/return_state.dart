import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:risu/components/alert_dialog.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/components/loader.dart';
import 'package:risu/components/outlined_button.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/article/details_page.dart';
import 'package:risu/utils/check_signin.dart';
import 'package:risu/utils/errors.dart';
import 'package:risu/utils/image_loader.dart';
import 'package:risu/utils/providers/theme.dart';
import 'package:url_launcher/url_launcher.dart';

import 'return_page.dart';

/// Return article page
/// This page is used to return an article
class ReturnArticleState extends State<ReturnArticlePage> {
  final LoaderManager _loaderManager = LoaderManager();
  dynamic rental = {
    'id': -1,
    'price': '',
    'createdAt': '',
    'duration': 0,
    'userId': '',
    'ended': '',
    'item': {
      'id': '',
      'name': '',
      'container': {
        'id': -1,
        'address': '',
      },
    },
  };

  /// Send invoice
  /// This function is used to send an invoice
  void sendInvoice() async {
    try {
      setState(() {
        _loaderManager.setIsLoading(true);
      });
      final response = await http.post(
        Uri.parse(
            'http://$serverIp:3000/api/mobile/rent/${widget.rentId}/invoice'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${userInformation?.token}',
        },
      );
      setState(() {
        _loaderManager.setIsLoading(false);
      });
      switch (response.statusCode) {
        case 201:
          await MyAlertDialog.showInfoAlertDialog(
            context: context,
            title: AppLocalizations.of(context)!.invoiceSent,
            message: AppLocalizations.of(context)!.invoiceSentMessage,
          );
          break;
        default:
          printServerResponse(context, response, 'sendInvoice',
              message: AppLocalizations.of(context)!
                  .errorOccurredDuringSendingInvoice);
      }
    } catch (err, stacktrace) {
      if (mounted) {
        setState(() {
          _loaderManager.setIsLoading(false);
        });
        printCatchError(context, err, stacktrace,
            message:
                AppLocalizations.of(context)!.errorOccurredDuringGettingRent);
        return;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.testRental == null) {
      getRent();
    } else {
      setState(() {
        rental = widget.testRental;
      });
    }
  }

  /// Get rent information
  /// Get rent information from the server
  void getRent() async {
    try {
      setState(() {
        _loaderManager.setIsLoading(true);
      });
      final token = userInformation?.token ?? 'defaultToken';
      final response = await http.get(
        Uri.parse('$baseUrl/api/mobile/rent/${widget.rentId}'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      );
      setState(() {
        _loaderManager.setIsLoading(false);
      });
      switch (response.statusCode) {
        case 200:
          setState(() {
            rental = jsonDecode(response.body)['rental'];
          });
          break;
        case 401:
          await tokenExpiredShowDialog(context);
          break;
        default:
          if (mounted) {
            printServerResponse(context, response, 'getRent',
                message: AppLocalizations.of(context)!
                    .errorOccurredDuringGettingRent);
          }
      }
    } catch (err, stacktrace) {
      if (mounted) {
        setState(() {
          _loaderManager.setIsLoading(false);
        });
        printCatchError(context, err, stacktrace,
            message:
                AppLocalizations.of(context)!.errorOccurredDuringGettingRent);
        return;
      }
      return;
    }
  }

  /// Return article
  /// This function is used to return an article
  void returnArticle() async {
    try {
      setState(() {
        _loaderManager.setIsLoading(true);
      });
      final token = userInformation?.token ?? 'defaultToken';
      final response = await http.post(
        Uri.parse('$baseUrl/api/mobile/rent/${rental['id']}/return'),
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
            rental['ended'] = true;
          });
          break;
        case 401:
          await tokenExpiredShowDialog(context);
          break;
        default:
          if (mounted) {
            printServerResponse(context, response, 'returnArticle',
                message: AppLocalizations.of(context)!
                    .errorOccurredDuringRentReturning);
          }
      }
    } catch (err, stacktrace) {
      if (mounted) {
        setState(() {
          _loaderManager.setIsLoading(false);
        });
        printCatchError(context, err, stacktrace,
            message:
                AppLocalizations.of(context)!.errorOccurredDuringRentReturning);
        return;
      }
      return;
    }
  }

  void _launchURL() async {
    dynamic container = rental["item"]["container"];
    Uri url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${container["latitude"]},${container["longitude"]}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: MyAppBar(
        curveColor: themeProvider.currentTheme.secondaryHeaderColor,
        showBackButton: false,
        action: rental["ended"] == false
            ? IconButton(
                key: const Key('return_article-button_get_directions'),
                onPressed: _launchURL,
                icon: Icon(
                  Icons.directions,
                  size: 28,
                  color: themeProvider
                      .currentTheme.bottomNavigationBarTheme.selectedItemColor,
                ),
              )
            : null,
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: themeProvider.currentTheme.colorScheme.surface,
      body: (_loaderManager.getIsLoading())
          ? Center(child: _loaderManager.getLoader())
          : Center(
              child: SingleChildScrollView(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        key: const Key('rent_return-title'),
                        AppLocalizations.of(context)!.article,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: themeProvider.currentTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      loadImageFromURL(rental['item']['imageUrl']),
                      const SizedBox(height: 8),
                      Card(
                        elevation: 2,
                        margin: const EdgeInsets.all(8),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: themeProvider
                                      .currentTheme.colorScheme.surface,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: Text(
                                  '${rental['item']['name']} | ${rental['item']['container']['address']}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: themeProvider.currentTheme
                                        .inputDecorationTheme.labelStyle!.color,
                                  ),
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Container(
                                  color: themeProvider
                                      .currentTheme.colorScheme.surface,
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
                                              color: themeProvider.currentTheme
                                                  .secondaryHeaderColor,
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .price,
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
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .duration,
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
                                                "${rental['price']}€",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: themeProvider
                                                        .currentTheme
                                                        .secondaryHeaderColor),
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
                                                AppLocalizations.of(context)!
                                                    .rentHours(
                                                        rental['duration']),
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: themeProvider
                                                        .currentTheme
                                                        .secondaryHeaderColor),
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
                      SizedBox(
                        width: double.infinity,
                        child: MyOutlinedButton(
                          text: AppLocalizations.of(context)!.receiveInvoice,
                          key: const Key('return_rent-button-receive_invoice'),
                          onPressed: () async {
                            sendInvoice();
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: MyOutlinedButton(
                          text: AppLocalizations.of(context)!.goToDetails,
                          key: const Key('return_rent-button-go-to-details'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ArticleDetailsPage(
                                  articleId: rental['item']['id'],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (rental['ended'] == false) ...[
                        SizedBox(
                          width: double.infinity,
                          child: MyOutlinedButton(
                            text: AppLocalizations.of(context)!.rentReturn,
                            key: const Key('rent_return-button-return_article'),
                            onPressed: () async {
                              bool returnRent =
                                  await MyAlertDialog.showChoiceAlertDialog(
                                context: context,
                                title: AppLocalizations.of(context)!
                                    .rentReturnAskConfirmation,
                                message: AppLocalizations.of(context)!
                                    .rentReturnAskConfirmationMessage,
                                onOkName: AppLocalizations.of(context)!.accept,
                                onCancelName:
                                    AppLocalizations.of(context)!.cancel,
                              );
                              if (returnRent == true) {
                                returnArticle();
                              }
                            },
                          ),
                        ),
                      ] else ...[
                        SizedBox(
                          width: double.infinity,
                          child: Container(
                            decoration: BoxDecoration(
                              color: themeProvider
                                  .currentTheme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text(
                              AppLocalizations.of(context)!
                                  .articleAlreadyReturned,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: themeProvider.currentTheme
                                    .inputDecorationTheme.labelStyle!.color,
                              ),
                            ),
                          ),
                        )
                      ]
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
