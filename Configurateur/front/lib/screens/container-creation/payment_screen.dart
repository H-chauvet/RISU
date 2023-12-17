import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/components/progress_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../../network/informations.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, this.amount});

  final int? amount;

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

  void goPrevious() {
    context.go('/');
  }

  void goNext() {
    context.go('/');
  }

  String adress = '';
  String city = '';
  String informations = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar('Paiement', context: context),
        bottomSheet: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProgressBar(
              length: 5,
              progress: 4,
              previous: 'Précédent',
              next: 'Terminer',
              previousFunc: goPrevious,
              nextFunc: goNext,
            ),
            const SizedBox(
              height: 50,
            )
          ],
        ),
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Center(
            child: FractionallySizedBox(
              widthFactor: 0.6,
              child: Column(
                children: [
                  const Text(
                    "Informations de livraison",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          key: const Key('adress'),
                          decoration: InputDecoration(
                            hintText: 'Entrez votre adresse',
                            labelText: 'Adresse',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          onChanged: (String? value) {
                            setState(
                              () {
                                adress = value!;
                              },
                            );
                          },
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez remplir ce champ';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: TextFormField(
                          key: const Key('city'),
                          decoration: InputDecoration(
                            hintText: 'Entrez la ville',
                            labelText: 'Ville',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          onChanged: (String? value) {
                            setState(
                              () {
                                city = value!;
                              },
                            );
                          },
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez remplir ce champ';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  const Text(
                    "Coordonnées bancaires",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  CardField(
                    controller: controller,
                  ),
                  const SizedBox(height: 100),
                  const Text(
                    "Des demandes supplémentaires à nous faire parvenir ?",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    key: const Key('informations'),
                    maxLines: 5,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    onChanged: (String? value) {
                      informations = value!;
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez remplir ce champ';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: (controller.complete && adress != '' && city != '')
                  ? makePayment
                  : null,
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0))),
              child: const Text('Payer'),
            ),
          ),
        ]));
  }

  Future<void> makePayment() async {
    const billingDetails = BillingDetails(
      email: 'risu.epitech@gmail.com',
      name: 'Risu Corp',
      address: Address(
          city: 'Nantes',
          country: 'FR',
          line1: '1 rue de la paix',
          line2: 'Appartement 1',
          postalCode: '44000',
          state: 'Loire Atlantique'), // Mocked data
    );

    final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: const PaymentMethodParams.card(
            paymentMethodData:
                PaymentMethodData(billingDetails: billingDetails)));

    final paymentIntentResult = await callPayEndpoint(
      true,
      paymentMethod.id,
      'eur',
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

  Future<Map<String, dynamic>> callPayEndpoint(
      bool useStripeSdk, String paymentMethodId, String currency) async {
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
        'amount': widget.amount,
      }),
    );
    return json.decode(response.body);
  }
}
