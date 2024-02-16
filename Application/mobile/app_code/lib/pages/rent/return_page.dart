import 'package:flutter/material.dart';

import 'return_state.dart';

class ReturnArticlePage extends StatefulWidget {
  final int rentId;

  const ReturnArticlePage({
    super.key,
    required this.rentId,
  });

  @override
  State<ReturnArticlePage> createState() => ReturnArticleState();
}
