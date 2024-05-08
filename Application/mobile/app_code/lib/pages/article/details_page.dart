import 'package:flutter/material.dart';

import 'details_state.dart';

class ArticleDetailsPage extends StatefulWidget {
  final int articleId;
  final Map<String, dynamic> testArticleData;

  const ArticleDetailsPage({
    super.key,
    required this.articleId,
    this.testArticleData = const {},
  });

  @override
  State<ArticleDetailsPage> createState() => ArticleDetailsState();
}
