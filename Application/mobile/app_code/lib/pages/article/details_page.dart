import 'package:flutter/material.dart';

import 'details_state.dart';

class ArticleDetailsPage extends StatefulWidget {
  final String articleId;

  const ArticleDetailsPage({ Key? key, required this.articleId }) : super(key: key);

  @override
  State<ArticleDetailsPage> createState() => ArticleDetailsState();
}
