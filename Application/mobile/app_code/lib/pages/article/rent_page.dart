import 'package:flutter/material.dart';

import 'rent_state.dart';

class RentArticlePage extends StatefulWidget {
  final String name;
  final int price;
  final int containerId;
  final List<String> locations;

  const RentArticlePage({
    super.key,
    required this.name,
    required this.price,
    required this.containerId,
    required this.locations,
  });

  @override
  State<RentArticlePage> createState() => RentArticlePageState();
}
