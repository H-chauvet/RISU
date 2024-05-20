import 'package:flutter/material.dart';

import 'details_state.dart';

class ArticleDetailsPage extends StatefulWidget {
  final int articleId;
  final List<dynamic> similarArticlesData;

  const ArticleDetailsPage({
    super.key,
    required this.articleId,
    this.similarArticlesData = const [],
  });

  @override
  State<ArticleDetailsPage> createState() => ArticleDetailsState();
}
