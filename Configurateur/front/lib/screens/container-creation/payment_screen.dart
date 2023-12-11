import 'package:flutter/material.dart';
import 'package:front/components/custom_app_bar.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => PaymentScreenState();
}

///
/// Login screen
///
/// page de connexion pour le configurateur
///
class PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        'Paiement',
        context: context,
      ),
    );
  }
}
