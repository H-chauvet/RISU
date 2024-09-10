import 'package:flutter/material.dart';
import 'package:risu/pages/article/article_list_data.dart';

import 'rent_state.dart';

/// Rent article page.
/// this page is used to display the article informations.
/// params:
/// [key] - key to identify the widget.
/// [articleData] - article data to display.
class RentArticlePage extends StatefulWidget {
  final ArticleData articleData;

  const RentArticlePage({
    super.key,
    required this.articleData,
  });

  @override
  State<RentArticlePage> createState() => RentArticlePageState();
}
