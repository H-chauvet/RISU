import 'package:flutter/material.dart';

import 'favorite_state.dart';

/// FavoritePage.
/// params:
/// [testFavorites] - list of favorite articles.
class FavoritePage extends StatefulWidget {
  final List<dynamic> testFavorites;

  const FavoritePage({
    super.key,
    this.testFavorites = const [],
  });

  @override
  State<FavoritePage> createState() => FavoriteSate();
}
