import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:front/components/alert_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/components/progress_bar.dart';
import 'package:front/network/informations.dart';
import 'package:front/services/http_service.dart';
import 'package:front/services/size_service.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/styles/globalStyle.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import 'payment_screen_style.dart';

/// PaymentScreen
///
/// Creation of the container
/// [lockers] : All the lockers of the container
/// [amount] : Price of the container
/// [containerMapping] : String that contains numbers representing where lockers is positioned in the container.
/// [container] : Informations about the container
/// [id] : User's Id
class PaymentScreen extends StatefulWidget {
  const PaymentScreen(
      {super.key,
      this.lockers,
      this.amount,
      this.containerMapping,
      this.id,
      this.container});

  final String? lockers;
  final int? amount;
  final String? containerMapping;
  final String? id;
  final String? container;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

/// _PaymentScreenState
///
class _PaymentScreenState extends State<PaymentScreen> {
  final controller = CardEditController();
  String jwtToken = '';
  String informations = '';

  /// [Function] : Check in storage service is the token is available
  void checkToken() async {
    String? token = await storageService.readStorage('token');
    if (token == '') {
      context.go('/login');
    } else {
      jwtToken = token!;
    }
  }

  @override
  void initState() {
    MyAlertTest.checkSignInStatus(context);
    checkToken();
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

  /// [Function] : Go to the previous page
  void goPrevious() {
    var data = {
      'amount': widget.amount,
      'containerMapping': widget.containerMapping,
      'lockers': widget.lockers,
      'id': widget.id,
      'container': widget.container,
    };
    context.go('/container-creation/maps', extra: jsonEncode(data));
  }

  /// [Function] : Go to the next page
  void goNext() async {
    if (controller.complete) {
      bool response = await makePayment();
      if (response == false) {
        Fluttertoast.showToast(
          msg: "Echec de la commande",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
        );
        return;
      }
    } else {
      return;
    }

    try {
      dynamic container = jsonDecode(widget.container!);
      HttpService().putRequest(
        'http://$serverIp:3000/api/container/update',
        <String, String>{
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': '*',
        },
        <String, String>{
          'id': widget.id!,
          'price': widget.amount.toString(),
          'containerMapping': widget.containerMapping!,
          'width': container['width'].toString(),
          'height': container['height'].toString(),
          'informations': informations,
        },
      ).then((value) {
        if (value.statusCode == 200) {
          context.go('/container-creation/confirmation');
        } else {
          Fluttertoast.showToast(
            msg: "Echec de la commande",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
          );
        }
      });
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Echec de la commande",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  /// [Widget] : Build the payment page
  @override
  Widget build(BuildContext context) {
    ScreenFormat screenFormat = SizeService().getScreenFormat(context);

    return Scaffold(
        appBar: CustomAppBar('Paiement', context: context),
        bottomSheet: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProgressBar(
              length: 6,
              progress: 5,
              previous: 'Précédent',
              next: 'Payer',
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
              widthFactor: screenFormat == ScreenFormat.desktop
                  ? desktopWidthFactor
                  : tabletWidthFactor,
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Text(
                    "Coordonnées bancaires",
                    style: TextStyle(
                        fontSize: screenFormat == ScreenFormat.desktop
                            ? desktopFontSize
                            : tabletFontSize,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  CardField(
                    controller: controller,
                  ),
                  const SizedBox(height: 100),
                  Text(
                    "Des demandes supplémentaires à nous faire parvenir ?",
                    style: TextStyle(
                        fontSize: screenFormat == ScreenFormat.desktop
                            ? desktopFontSize
                            : tabletFontSize,
                        fontWeight: FontWeight.bold),
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
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ]));
  }

  Future<bool> makePayment() async {
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

    late var paymentMethod;
    try {
      paymentMethod = await Stripe.instance.createPaymentMethod(
          params: const PaymentMethodParams.card(
              paymentMethodData:
                  PaymentMethodData(billingDetails: billingDetails)));
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }

    final paymentIntentResult = await callPayEndpoint(
      true,
      paymentMethod.id,
      'eur',
    );

    if (paymentIntentResult['error'] != null) {
      debugPrint("Error");
      return false;
    }

    if (paymentIntentResult['clientSecret'] != null &&
        paymentIntentResult['requiresAction'] == null) {
      debugPrint("Payment success");
      return true;
    }
    return false;
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
        'containerId': widget.id,
      }),
    );
    return json.decode(response.body);
  }
}
