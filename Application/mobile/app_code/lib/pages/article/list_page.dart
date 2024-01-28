import 'package:flutter/material.dart';

import 'list_state.dart';

class ArticleListPage extends StatefulWidget {
  final String containerId;

  const ArticleListPage({
    super.key,
    required this.containerId,
  });

  @override
  State<ArticleListPage> createState() => ArticleListState();
}
