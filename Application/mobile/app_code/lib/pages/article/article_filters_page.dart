import 'package:flutter/material.dart';

import 'article_filters_state.dart';

/// ArticleFiltersPage.
/// params:
/// [isAscending] - sort order.
/// [isAvailable] - availability of articles.
/// [selectedCategoryId] - selected category.
/// [sortBy] - sort by.
/// [articleCategories] - list of article categories.
/// [min] - minimum price.
/// [max] - maximum price.
class ArticleFiltersPage extends StatefulWidget {
  final bool isAscending;
  final bool isAvailable;
  final String? selectedCategoryId;
  final String? sortBy;
  final List<dynamic> articleCategories;
  final double? min;
  final double? max;

  const ArticleFiltersPage({
    super.key,
    this.isAscending = true,
    this.isAvailable = true,
    this.selectedCategoryId = 'null',
    this.sortBy,
    this.min = 0,
    this.max = 1000000,
    required this.articleCategories,
  });

  @override
  State<ArticleFiltersPage> createState() => ArticleFiltersState();
}
