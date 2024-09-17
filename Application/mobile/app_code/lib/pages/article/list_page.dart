import 'package:flutter/material.dart';

import 'list_state.dart';

/// Article list page
/// this page is used to display the list of articles
/// params:
/// [containerId] - container id
/// [testItemData] - test item data
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
