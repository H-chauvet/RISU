import 'package:flutter/material.dart';

import 'list_state.dart';

class ArticleListPage extends StatefulWidget {
  final int containerId;
  final List<dynamic> testItemData;

  const ArticleListPage({
    super.key,
    required this.containerId,
    this.testItemData = const [],
  });

  @override
  State<ArticleListPage> createState() => ArticleListState();
}
