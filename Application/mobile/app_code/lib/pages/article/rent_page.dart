import 'package:flutter/material.dart';

import 'rent_state.dart';

class RentArticlePage extends StatefulWidget {
  final String name;
  final int price;
  final int containerId;
  final List<String> locations;

  const RentArticlePage({
    Key? key,
    required this.name,
    required this.price,
    required this.containerId,
    required this.locations,
  }) : super(key: key);

  @override
  State<RentArticlePage> createState() => RentArticlePageState();
}
