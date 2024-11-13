import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as datePicker;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:risu/components/alert_dialog.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/components/divider.dart';
import 'package:risu/components/loader.dart';
import 'package:risu/components/outlined_button.dart';
import 'package:risu/components/pop_scope_parent.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/article/article_list_data.dart';
import 'package:risu/pages/rent/confirm/confirm_rent_page.dart';
import 'package:risu/utils/check_signin.dart';
import 'package:risu/utils/errors.dart';
import 'package:risu/utils/image_loader.dart';
import 'package:risu/utils/providers/theme.dart';

import 'rent_page.dart';

/// RentArticlePage class
/// This class is a StatefulWidget that displays the page to rent an article.
class RentArticlePageState extends State<RentArticlePage> {
  dynamic paymentIntent;
  int _rentalHours = 1;
  late ArticleData _articleData;
  final LoaderManager _loaderManager = LoaderManager();
  DateTime? _startDate;

  @override
  void initState() {
    super.initState();
    _articleData = widget.articleData;
  }

  /// Increment the rental hours
  void _incrementHours() {
    setState(() {
      if (_rentalHours == 24) {
        _rentalHours = 1;
      } else {
        _rentalHours++;
      }
    });
  }

  /// Decrement the rental hours
  void _decrementHours() {
    setState(() {
      if (_rentalHours == 1) {
        _rentalHours = 24;
      } else {
        _rentalHours--;
      }
    });
  }

  /// Rent an article
  /// This function sends a POST request to the server to rent an article.
  void rentArticle() async {
    final token = userInformation?.token ?? 'defaultToken';
    late http.Response response;
    try {
      setState(() {
        _loaderManager.setIsLoading(true);
      });
      response = await http.post(
        Uri.parse('$baseUrl/api/mobile/rent/article'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          'itemId': _articleData.id,
          'duration': _rentalHours.toString(),
        }),
      );
      setState(() {
        _loaderManager.setIsLoading(false);
      });
      switch (response.statusCode) {
        case 201:
          if (mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return ConfirmRentPage(
                    hours: _rentalHours,
                    data: _articleData,
                    locationId: jsonDecode(response.body)['rentId'],
                  );
                },
              ),
              (route) => false,
            );
          }
          break;
        case 401:
          await tokenExpiredShowDialog(context);
          break;
        default:
          if (mounted) {
            printServerResponse(context, response, 'rentArticle',
                message:
                    AppLocalizations.of(context)!.errorOccurredDuringRenting);
          }
      }
    } catch (err, stacktrace) {
      if (mounted) {
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

  /// Create a payment intent
  /// This function sends a POST request to the server to create a payment intent.
  /// params:
  /// [amount] - the amount of the payment intent
  /// [currency] - the currency of the payment intent
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
      switch (response.statusCode) {
        case 200:
          final responseData = json.decode(response.body);
          return responseData;
        case 401:
          await tokenExpiredShowDialog(context);
          return null;
        default:
          if (mounted) {
            printServerResponse(context, response, 'createPaymentIntent',
                message: AppLocalizations.of(context)!
                    .errorOccurredDuringPaymentCreation);
          }
      }
    } catch (err, stacktrace) {
      if (mounted) {
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

  /// Initialize the payment sheet
  /// This function initializes the payment sheet.
  /// params:
  /// [clientSecret] - the client secret of the payment intent
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
      if (mounted) {
        printCatchError(context, err, stacktrace,
            message:
                AppLocalizations.of(context)!.errorOccurredDuringSettingStripe);
        return;
      }
      return;
    }
  }

  /// Make a payment
  /// This function makes a payment.
  /// It creates a payment intent, initializes the payment sheet and presents the payment sheet.
  Future<void> makePayment() async {
    try {
      final amount = _articleData.price *
          100 *
          _rentalHours; // for stripe, price is in cents
      final Map<String, dynamic>? paymentIntentData =
          await createPaymentIntent(amount.round().toString(), 'EUR');
      final clientSecret = paymentIntentData!['client_secret'];
      if (clientSecret != null) {
        await initPaymentSheet(clientSecret);
        await stripe.Stripe.instance.presentPaymentSheet().then((value) async {
          // paiement success
          await MyAlertDialog.showInfoAlertDialog(
            context: context,
            title: AppLocalizations.of(context)!.paymentDone,
            message: AppLocalizations.of(context)!.paymentSuccessful,
          );
          rentArticle();
        });
      } else {
        if (mounted) {
          await MyAlertDialog.showErrorAlertDialog(
            context: context,
            title: AppLocalizations.of(context)!.error,
            message: AppLocalizations.of(context)!.paymentClientSecretInvalid,
          );
          return;
        }
      }
    } catch (err, stacktrace) {
      if (mounted) {
        printCatchError(context, err, stacktrace,
            message: AppLocalizations.of(context)!.paymentHasFailed);
        return;
      }
      return;
    }
  }

  /// Confirm rent
  /// This function shows an alert dialog to confirm the rent.
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
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MyPopScope(
      child: Scaffold(
        appBar: MyAppBar(
          curveColor: themeProvider.currentTheme.secondaryHeaderColor,
          showBackButton: false,
          textTitle: AppLocalizations.of(context)!.rentArticle,
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: themeProvider.currentTheme.colorScheme.surface,
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
                        const SizedBox(height: 8),
                        loadImageFromURL(_articleData.imagesUrl?[0]),
                        const SizedBox(height: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                _articleData.name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      themeProvider.currentTheme.primaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            ClipRRect(
                              child: Container(
                                color: themeProvider
                                    .currentTheme
                                    .inputDecorationTheme
                                    .floatingLabelStyle!
                                    .color,
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
                                              AppLocalizations.of(context)!
                                                  .pricePerHour,
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
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .priceTotal,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: themeProvider
                                                    .currentTheme.primaryColor,
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
                                                .withOpacity(0.8),
                                            child: Text(
                                              "${_articleData.price}€",
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
                                              "${_articleData.price * _rentalHours}€",
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
                            const SizedBox(height: 16),
                            Container(
                              decoration: BoxDecoration(
                                color: themeProvider
                                    .currentTheme
                                    .inputDecorationTheme
                                    .floatingLabelStyle!
                                    .color,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      "Starting on",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: themeProvider
                                            .currentTheme.primaryColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  GestureDetector(
                                    onTap: () {
                                      datePicker.DatePicker.showDateTimePicker(
                                        context,
                                        minTime: DateTime.now(),
                                        maxTime: DateTime.now().add(
                                          const Duration(days: 30),
                                        ),
                                        currentTime:
                                            _startDate ?? DateTime.now(),
                                        onConfirm: (date) {
                                          setState(() {
                                            _startDate = date;
                                          });
                                        },
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        color: themeProvider
                                                    .currentTheme.brightness ==
                                                Brightness.light
                                            ? Colors.white
                                            : Colors.black12,
                                        boxShadow: [
                                          BoxShadow(
                                            color: themeProvider
                                                .currentTheme.primaryColor,
                                            blurRadius: 2,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_today,
                                            color: themeProvider
                                                .currentTheme.primaryColor,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              _startDate != null
                                                  ? DateFormat(
                                                      'kk:mm dd MMM yyyy',
                                                    ).format(_startDate!)
                                                  : 'Now',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: themeProvider
                                                    .currentTheme.primaryColor,
                                              ),
                                            ),
                                          ),
                                          if (_startDate != null)
                                            IgnorePointer(
                                              ignoring: false,
                                              child: GestureDetector(
                                                child: const Icon(
                                                  Icons.close,
                                                  color: Colors.red,
                                                ),
                                                onTap: () {
                                                  setState(() {
                                                    _startDate = null;
                                                  });
                                                },
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Center(
                                    child: Text(
                                      "for",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: themeProvider
                                            .currentTheme.primaryColor,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        key:
                                            const Key('decrement-hours-button'),
                                        icon: Icon(
                                          Icons.remove,
                                          color: themeProvider
                                              .currentTheme.primaryColor,
                                        ),
                                        onPressed: _decrementHours,
                                      ),
                                      Text(
                                        AppLocalizations.of(context)!
                                            .rentHours(_rentalHours),
                                        style: TextStyle(
                                          color: themeProvider
                                              .currentTheme.primaryColor,
                                        ),
                                      ),
                                      IconButton(
                                        key:
                                            const Key('increment-hours-button'),
                                        icon: Icon(
                                          Icons.add,
                                          color: themeProvider
                                              .currentTheme.primaryColor,
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
                        const MyDivider(),
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
      ),
    );
  }
}
