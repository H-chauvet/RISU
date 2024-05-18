import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
//import 'package:flutter_stripe_web/flutter_stripe_web.dart';
import 'package:http/http.dart' as http;

/// PaymentService
///
/// Service for the container's payment
class PaymentService {
  /// Paiement en cours ou dernier paiement effectué.
  dynamic paymentIntent;

  /// [Function] : Create payment intent with strip
  ///
  /// [amount] : amount transaction.
  /// [currency] : currency of the transaction
  ///
  /// reutnr the details of the payment
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  /// [Function] : Display the payment sheet
  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        paymentIntent = null;
      }).onError((error, stackTrace) {
        throw Exception(error);
      });
    } on StripeException catch (e) {
      debugPrint('Error is:---> $e');
    } catch (e) {
      debugPrint('$e');
    }
  }

  /// [Function] : Make the payment for the container
  Future<void> makePayment() async {
    try {
      paymentIntent = await createPaymentIntent('100', 'USD');

      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent!['client_secret'],
                  style: ThemeMode.light,
                  merchantDisplayName: 'Ikay'))
          .then((value) {});

      displayPaymentSheet();
    } catch (err) {
      throw Exception(err);
    }
  }
}
