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
import 'package:risu/utils/errors.dart';
import 'package:risu/utils/providers/theme.dart';

import 'return_page.dart';

class ReturnArticleState extends State<ReturnArticlePage> {
  final LoaderManager _loaderManager = LoaderManager();
  dynamic rent = {
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

  void sendInvoice() async {
    try {
      setState(() {
        _loaderManager.setIsLoading(true);
      });
      final response = await http.put(
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
      if (response.statusCode == 201) {
        if (context.mounted) {
          await MyAlertDialog.showInfoAlertDialog(
            context: context,
            title: AppLocalizations.of(context)!.invoiceSent,
            message: AppLocalizations.of(context)!.invoiceSentMessage,
          );
        }
      } else {
        if (context.mounted) {
          printServerResponse(context, response, 'sendInvoice',
              message: AppLocalizations.of(context)!
                  .errorOccurredDuringSendingInvoice);
        }
      }
    } catch (err, stacktrace) {
      if (context.mounted) {
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
    getRent();
  }

  void getRent() async {
    try {
      setState(() {
        _loaderManager.setIsLoading(true);
      });
      final token = userInformation?.token ?? 'defaultToken';
      final response = await http.get(
        Uri.parse('http://$serverIp:3000/api/mobile/rent/${widget.rentId}'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      );
      setState(() {
        _loaderManager.setIsLoading(false);
      });
      if (response.statusCode == 201) {
        setState(() {
          rent = jsonDecode(response.body)['rental'];
        });
      } else {
        if (context.mounted) {
          printServerResponse(context, response, 'getRent',
              message:
                  AppLocalizations.of(context)!.errorOccurredDuringGettingRent);
        }
      }
    } catch (err, stacktrace) {
      if (context.mounted) {
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

  void returnArticle() async {
    try {
      setState(() {
        _loaderManager.setIsLoading(true);
      });
      final token = userInformation?.token ?? 'defaultToken';
      final response = await http.post(
        Uri.parse('http://$serverIp:3000/api/mobile/rent/${rent['id']}/return'),
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
          rent['ended'] = true;
        });
      } else {
        if (context.mounted) {
          printServerResponse(context, response, 'returnArticle',
              message: AppLocalizations.of(context)!
                  .errorOccurredDuringRentReturning);
        }
      }
    } catch (err, stacktrace) {
      if (context.mounted) {
        setState(() {
          _loaderManager.setIsLoading(false);
        });
        printCatchError(context, err, stacktrace,
            message:
                AppLocalizations.of(context)!.errorOccurredDuringRentReturning);
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: MyAppBar(
        curveColor: themeProvider.currentTheme.secondaryHeaderColor,
        showBackButton: false,
        showLogo: true,
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
                    Text(
                      key: const Key('rent_return-title'),
                      AppLocalizations.of(context)!.article,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: themeProvider.currentTheme.secondaryHeaderColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // image
                    Container(
                      width: 256,
                      height: 192,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: const DecorationImage(
                          image: AssetImage('assets/volley.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
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
                                    .currentTheme.colorScheme.background,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: Text(
                                '${rent['item']['name']} | ${rent['item']['container']['address']}',
                                style: TextStyle(
                                  fontSize: 18,
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
                                    .currentTheme.colorScheme.background,
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
                                            color: themeProvider
                                                .currentTheme.primaryColor,
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .price,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: themeProvider
                                                    .currentTheme
                                                    .inputDecorationTheme
                                                    .labelStyle!
                                                    .color,
                                              ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Container(
                                            padding: const EdgeInsets.all(8.0),
                                            color: themeProvider
                                                .currentTheme.primaryColor,
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .duration,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: themeProvider
                                                    .currentTheme
                                                    .inputDecorationTheme
                                                    .labelStyle!
                                                    .color,
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
                                            padding: const EdgeInsets.all(8.0),
                                            color: themeProvider
                                                .currentTheme.primaryColor
                                                .withOpacity(0.6),
                                            child: Text(
                                              "${rent['price']}€",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: themeProvider
                                                    .currentTheme
                                                    .inputDecorationTheme
                                                    .labelStyle!
                                                    .color,
                                              ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Container(
                                            padding: const EdgeInsets.all(8.0),
                                            color: themeProvider
                                                .currentTheme.primaryColor
                                                .withOpacity(0.6),
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .rentHours(rent['duration']),
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: themeProvider
                                                    .currentTheme
                                                    .inputDecorationTheme
                                                    .labelStyle!
                                                    .color,
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
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: MyOutlinedButton(
                        text: AppLocalizations.of(context)!.receiveInvoice,
                        key: const Key('return-rent-button-receive_invoice'),
                        onPressed: () async {
                          sendInvoice();
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (rent['ended'] == false) ...[
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
                                .currentTheme.colorScheme.background,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: Text(
                            AppLocalizations.of(context)!
                                .articleAlreadyReturned,
                            style: TextStyle(
                              fontSize: 18,
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
    );
  }
}
