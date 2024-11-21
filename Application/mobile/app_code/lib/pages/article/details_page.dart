import 'package:flutter/material.dart';

import 'details_state.dart';

/// Article details page.
/// This page displays the details of an article.
/// params:
/// [articleId] - id of the article.
/// [similarArticlesData] - list of similar articles.
/// [testArticleData] - test data for the article.
/// returns:
/// [ArticleDetailsPage] - article details page.
class ArticleDetailsPage extends StatefulWidget {
  final int articleId;
  final List<dynamic> similarArticlesData;
  final Map<String, dynamic> testArticleData;
  final List<dynamic> testOpinionList;

  const ArticleDetailsPage({
    super.key,
    required this.articleId,
    this.similarArticlesData = const [],
    this.testArticleData = const {},
    this.testOpinionList = const [],
  });

  @override
  State<ArticleDetailsPage> createState() => ArticleDetailsState();
}
