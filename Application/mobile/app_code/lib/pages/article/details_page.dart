import 'package:flutter/material.dart';

import 'details_state.dart';

class ArticleDetailsPage extends StatefulWidget {
  final int articleId;
  final List<dynamic> similarArticlesData;
  final Map<String, dynamic> testArticleData;

  const ArticleDetailsPage({
    super.key,
    required this.articleId,
    this.similarArticlesData = const [],
    this.testArticleData = const {},
  });

  @override
  State<ArticleDetailsPage> createState() => ArticleDetailsState();
}
