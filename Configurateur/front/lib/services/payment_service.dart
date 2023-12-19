import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
//import 'package:flutter_stripe_web/flutter_stripe_web.dart';
import 'package:http/http.dart' as http;

class PaymentService {
  dynamic paymentIntent;

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
