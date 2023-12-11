import 'package:flutter/material.dart';
import 'package:front/components/custom_app_bar.dart';

class DeliveryInfoScreen extends StatefulWidget {
  const DeliveryInfoScreen({super.key});

  @override
  State<DeliveryInfoScreen> createState() => DeliveryInfoScreenState();
}

///
/// Login screen
///
/// page de connexion pour le configurateur
///
class DeliveryInfoScreenState extends State<DeliveryInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        'Livraison',
        context: context,
      ),
    );
  }
}
