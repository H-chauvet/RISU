import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:risu/components/alert_dialog.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/components/loader.dart';
import 'package:risu/components/outlined_button.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/article/article_list_data.dart';
import 'package:risu/pages/rent/confirm/confirm_rent_page.dart';
import 'package:risu/utils/check_signin.dart';
import 'package:risu/utils/errors.dart';
import 'package:risu/utils/providers/theme.dart';

import 'rent_page.dart';

class RentArticlePageState extends State<RentArticlePage> {
  dynamic paymentIntent;
  int _rentalHours = 1;
  late ArticleData _articleData;
  final LoaderManager _loaderManager = LoaderManager();

  @override
  void initState() {
    super.initState();
    _articleData = widget.articleData;
  }

  void _incrementHours() {
    setState(() {
      _rentalHours++;
    });
  }

  void _decrementHours() {
    if (_rentalHours > 1) {
      setState(() {
        _rentalHours--;
      });
    }
  }

  void rentArticle() async {
    final token = userInformation?.token ?? 'defaultToken';
    late http.Response response;
    try {
      setState(() {
        _loaderManager.setIsLoading(true);
      });
      response = await http.post(
        Uri.parse('http://$serverIp:8080/api/rent/article'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, String>{
          'itemId': _articleData.id,
          'duration': _rentalHours.toString(),
        }),
      );
      setState(() {
        _loaderManager.setIsLoading(false);
      });
      if (response.statusCode == 201) {
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ConfirmRentPage(
                  hours: _rentalHours,
                  data: _articleData,
                );
              },
            ),
            (route) => false,
          );
        }
      } else {
        if (context.mounted) {
          printServerResponse(context, response, 'rentArticle',
              message:
                  AppLocalizations.of(context)!.errorOccurredDuringRenting);
        }
      }
    } catch (err, stacktrace) {
      if (context.mounted) {
        setState(() {
          _loaderManager.setIsLoading(false);
        });
        printCatchError(context, err, stacktrace,
            message: AppLocalizations.of(context)!.connectionRefused);
        return;
      }
      return;
    }
  }

  Future<Map<String, dynamic>?> createPaymentIntent(
      String amount, String currency) async {
    try {
      setState(() {
        _loaderManager.setIsLoading(true);
      });
      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET_KEY']}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'amount': amount,
          'currency': currency,
        },
      );
      setState(() {
        _loaderManager.setIsLoading(false);
      });
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData;
      } else {
        if (context.mounted) {
          printServerResponse(context, response, 'createPaymentIntent',
              message: AppLocalizations.of(context)!
                  .errorOccurredDuringPaymentCreation);
        }
      }
    } catch (err, stacktrace) {
      if (context.mounted) {
        setState(() {
          _loaderManager.setIsLoading(false);
        });
        printCatchError(context, err, stacktrace,
            message: AppLocalizations.of(context)!
                .errorOccurredDuringPaymentCreation);
        return null;
      }
      return null;
    }
    return null;
  }

  Future<void> initPaymentSheet(String clientSecret) async {
    try {
      dynamic currentTheme = context.read<ThemeProvider>().currentTheme;
      await stripe.Stripe.instance.initPaymentSheet(
        paymentSheetParameters: stripe.SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          style: currentTheme == appTheme['clair']
              ? ThemeMode.light
              : ThemeMode.dark,
          merchantDisplayName: 'Ikay',
        ),
      );
    } catch (err, stacktrace) {
      if (context.mounted) {
        printCatchError(context, err, stacktrace,
            message:
                AppLocalizations.of(context)!.errorOccurredDuringSettingStripe);
        return;
      }
      return;
    }
  }

  Future<void> makePayment() async {
    try {
      final amount = _articleData.price *
          100 *
          _rentalHours; // for stripe, price is in cents
      final Map<String, dynamic>? paymentIntentData =
          await createPaymentIntent(amount.toString(), 'EUR');
      final clientSecret = paymentIntentData!['client_secret'];
      if (clientSecret != null) {
        await initPaymentSheet(clientSecret);
        await stripe.Stripe.instance.presentPaymentSheet().then((value) async {
          rentArticle();
          // paiement success
          await MyAlertDialog.showInfoAlertDialog(
            context: context,
            title: AppLocalizations.of(context)!.paymentDone,
            message: AppLocalizations.of(context)!.paymentSuccessful,
          );
        });
      } else {
        if (context.mounted) {
          await MyAlertDialog.showErrorAlertDialog(
            context: context,
            title: AppLocalizations.of(context)!.error,
            message: AppLocalizations.of(context)!.paymentClientSecretInvalid,
          );
          return;
        }
      }
    } catch (err, stacktrace) {
      if (context.mounted) {
        printCatchError(context, err, stacktrace,
            message: AppLocalizations.of(context)!.paymentHasFailed);
        return;
      }
      return;
    }
  }

  void confirmRent() async {
    await MyAlertDialog.showChoiceAlertDialog(
      context: context,
      title: AppLocalizations.of(context)!.rentConfirmation,
      message: AppLocalizations.of(context)!
          .rentAskConfirmationMessage(_rentalHours),
      onOkName: AppLocalizations.of(context)!.confirm,
      onCancelName: AppLocalizations.of(context)!.cancel,
    ).then((value) => {
          if (value)
            {
              makePayment(),
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        curveColor: context.select((ThemeProvider themeProvider) =>
            themeProvider.currentTheme.secondaryHeaderColor),
        showBackButton: false,
        showLogo: true,
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
                        AppLocalizations.of(context)!.rentArticle,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: context.select((ThemeProvider themeProvider) =>
                              themeProvider.currentTheme.primaryColor),
                        ),
                      ),
                      const SizedBox(height: 8),
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
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: Text(
                                  _articleData.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Container(
                                  color: Colors.white,
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
                                              color: const Color(0xFF4682B4),
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .pricePerHour,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              color: const Color(0xFF4682B4),
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .priceTotal,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
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
                                              color: const Color(0xFF4682B4)
                                                  .withOpacity(0.6),
                                              child: Text(
                                                "${_articleData.price}€",
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              color: const Color(0xFF4682B4)
                                                  .withOpacity(0.6),
                                              child: Text(
                                                "${_articleData.price * _rentalHours}€",
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
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
                              const SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          key: const Key(
                                              'decrement-hours-button'),
                                          icon: const Icon(
                                            Icons.remove,
                                            color: Colors.black,
                                          ),
                                          onPressed: _decrementHours,
                                        ),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .rentHours(_rentalHours),
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                        IconButton(
                                          key: const Key(
                                              'increment-hours-button'),
                                          icon: const Icon(
                                            Icons.add,
                                            color: Colors.black,
                                          ),
                                          onPressed: _incrementHours,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (_articleData.available)
                        SizedBox(
                          width: double.infinity,
                          child: MyOutlinedButton(
                            key: const Key('confirm-rent-button'),
                            text: AppLocalizations.of(context)!.rent,
                            onPressed: () async {
                              bool signIn = await checkSignin(context);
                              if (!signIn) {
                                return;
                              }
                              confirmRent();
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
