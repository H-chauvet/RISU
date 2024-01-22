import 'package:flutter/material.dart';
import 'package:risu/pages/article/article_list_data.dart';

import 'rent_state.dart';

class RentArticlePage extends StatefulWidget {
  final ArticleData articleData;

  const RentArticlePage({
    super.key,
    required this.articleData,
  });

  @override
  State<RentArticlePage> createState() => RentArticlePageState();
}
