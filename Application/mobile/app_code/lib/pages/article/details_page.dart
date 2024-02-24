import 'package:flutter/material.dart';

import 'details_state.dart';

class ArticleDetailsPage extends StatefulWidget {
  final int articleId;

  const ArticleDetailsPage({
    super.key,
    required this.articleId,
  });

  @override
  State<ArticleDetailsPage> createState() => ArticleDetailsState();
}
