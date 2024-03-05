import 'package:flutter/material.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:go_router/go_router.dart';

class ShapeScreen extends StatefulWidget {
  const ShapeScreen({super.key});

  @override
  State<ShapeScreen> createState() => ShapeScreenState();
}

class ShapeScreenState extends State<ShapeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          "Forme",
          context: context,
        ),
        body: const Center(
          child: Text('yooo'),
        ));
  }
}
