import 'package:flutter/material.dart';

import 'article_filters_state.dart';

class ArticleFiltersPage extends StatefulWidget {
  final bool isAscending;
  final bool isAvailable;
  final String? selectedCategoryId;
  final String? sortBy;
  final List<dynamic> articleCategories;

  const ArticleFiltersPage({
    super.key,
    this.isAscending = true,
    this.isAvailable = true,
    this.selectedCategoryId = 'null',
    this.sortBy,
    required this.articleCategories,
  });

  @override
  State<ArticleFiltersPage> createState() => ArticleFiltersState();
}
