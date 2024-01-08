import 'package:flutter/material.dart';

import 'list_state.dart';

class ArticleListPage extends StatefulWidget {
  final String containerId;

  const ArticleListPage({Key? key, required this.containerId}) : super(key: key);

  @override
  State<ArticleListPage> createState() => ArticleListState();
}
