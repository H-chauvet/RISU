import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:risu/components/alert_dialog.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/components/outlined_button.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/article/article_list_data.dart';
import 'package:risu/pages/rent/confirm/confirm_rent_page.dart';
import 'package:risu/utils/check_signin.dart';
import 'package:risu/utils/errors.dart';
import 'package:risu/utils/theme.dart';

import 'rent_page.dart';

class RentArticlePageState extends State<RentArticlePage> {
  dynamic paymentIntent;
  int _rentalHours = 1;
  late ArticleData _articleData;

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
    } catch (err, stacktrace) {
      printCatchError(context, err, stacktrace, message: "Connexion refused.");
    }
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
      printServerResponse(context, response, 'rentArticle',
          message: "Erreur lors de la location.");
    }
  }

  Future<Map<String, dynamic>?> createPaymentIntent(
      String amount, String currency) async {
    try {
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

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return responseData;
      } else {
        printServerResponse(context, response, 'createPaymentIntent',
            message: "Echec de la création du paiement.");
      }
    } catch (err, stacktrace) {
      printCatchError(context, err, stacktrace,
          message: "Echec de la création du paiement.");
    }
    return null;
  }

  Future<void> initPaymentSheet(String clientSecret) async {
    try {
      await stripe.Stripe.instance.initPaymentSheet(
        paymentSheetParameters: stripe.SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          style: ThemeMode.light,
          merchantDisplayName: 'Ikay',
        ),
      );
    } catch (err, stacktrace) {
      printCatchError(context, err, stacktrace, message: "Erreur Stripe.");
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
            title: 'Paiement effectué',
            message: 'Le paiement a bien été effectué',
          );
        });
      } else {
        await MyAlertDialog.showErrorAlertDialog(
          context: context,
          title: 'Le paiement a échoué',
          message: 'Client secret is missing',
        );
      }
    } catch (err, stacktrace) {
      printCatchError(context, err, stacktrace,
          message: "Le paiement a échoué.");
    }
  }

  void confirmRent() async {
    await MyAlertDialog.showChoiceAlertDialog(
      context: context,
      title: 'Confirmer la location',
      message: 'Êtes-vous sûr de vouloir louer cet article ?',
      onOkName: 'Confirmer',
      onCancelName: 'Annuler',
    ).then(
      (value) => {
        if (value)
          {
            makePayment(),
          }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        curveColor: context.select((ThemeProvider themeProvider) =>
            themeProvider.currentTheme.secondaryHeaderColor),
        showBackButton: false,
        showLogo: true,
        showBurgerMenu: true,
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: context.select((ThemeProvider themeProvider) =>
          themeProvider.currentTheme.colorScheme.background),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Location de l\'article',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: context.select((ThemeProvider themeProvider) =>
                        themeProvider.currentTheme.primaryColor),
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
                                        padding: const EdgeInsets.all(8.0),
                                        color: const Color(0xFF4682B4),
                                        child: const Text(
                                          'Prix par heure',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        color: const Color(0xFF4682B4),
                                        child: const Text(
                                          'Coût total',
                                          style: TextStyle(
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
                                        padding: const EdgeInsets.all(8.0),
                                        color: const Color(0xFF4682B4)
                                            .withOpacity(0.6),
                                        child: Text(
                                          '${_articleData.price} €',
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
                                        padding: const EdgeInsets.all(8.0),
                                        color: const Color(0xFF4682B4)
                                            .withOpacity(0.6),
                                        child: Text(
                                          '${_articleData.price * _rentalHours} €',
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    key: const Key('decrement-hours-button'),
                                    icon: const Icon(Icons.remove),
                                    onPressed: _decrementHours,
                                  ),
                                  Text(
                                      '$_rentalHours heure${_rentalHours > 1 ? 's' : ''}'),
                                  IconButton(
                                    key: const Key('increment-hours-button'),
                                    icon: const Icon(Icons.add),
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
                      text: 'Louer',
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
