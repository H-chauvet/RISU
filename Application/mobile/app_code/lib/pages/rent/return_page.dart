import 'package:flutter/material.dart';

import 'return_state.dart';

/// Return article page.
/// this page is used to return the article.
/// params:
/// [key] - key to identify the widget.
/// [rentId] - rental id.
/// [testRental] - rental data to display.
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
