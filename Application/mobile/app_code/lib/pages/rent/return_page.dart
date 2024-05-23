import 'package:flutter/material.dart';

import 'return_state.dart';

class ReturnArticlePage extends StatefulWidget {
  final int rentId;
  final dynamic testRental;

  const ReturnArticlePage({
    super.key,
    required this.rentId,
    this.testRental,
  });

  @override
  State<ReturnArticlePage> createState() => ReturnArticleState();
}
