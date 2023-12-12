import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

import '../../network/informations.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final controller = CardEditController();

  @override
  void initState() {
    controller.addListener(update);
    super.initState();
  }

  void update() => setState(() {});
  @override
  void dispose() {
    controller.removeListener(update);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      CardField(
        controller: controller,
      ),
      const SizedBox(height: 20),
      ElevatedButton(
        onPressed: controller.complete ? makePayment : null,
        child: const Text('Payer'),
      ),
    ]));
  }

  Future<void> makePayment() async {
    const billingDetails = BillingDetails(
      email: 'test.mocked@gmail.com',
      phone: '+33612345678',
      name: 'Test Mocked',
      address: Address(
          city: 'Nantes',
          country: 'FR',
          line1: '1 rue de la paix',
          line2: 'Appartement 1',
          postalCode: '44000',
          state: 'Loire Atlantique'),
    );

    final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: const PaymentMethodParams.card(
            paymentMethodData:
                PaymentMethodData(billingDetails: billingDetails)));

    final paymentIntentResult = await callPayEndpoint(
      true,
      paymentMethod.id,
      'eur',
      ['id-1'],
    );

    if (paymentIntentResult['error'] != null) {
      debugPrint("Error");
      return;
    }

    if (paymentIntentResult['clientSecret'] != null &&
        paymentIntentResult['requiresAction'] == null) {
      debugPrint("Payment success");
      return;
    }
  }

  Future<Map<String, dynamic>> callPayEndpoint(bool useStripeSdk,
      String paymentMethodId, String currency, List<String>? items) async {
    final url = Uri.parse('http://$serverIp:3000/api/payment/card-pay');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'useStripeSdk': useStripeSdk,
        'paymentMethodId': paymentMethodId,
        'currency': currency,
        'items': items
      }),
    );
    return json.decode(response.body);
  }
}
