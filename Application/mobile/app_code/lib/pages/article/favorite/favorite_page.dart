import 'package:flutter/material.dart';

import 'favorite_state.dart';

/// FavoritePage.
/// params:
/// [testFavorites] - list of favorite articles.
/// [appbar] - boolean.
class FavoritePage extends StatefulWidget {
  final List<dynamic> testFavorites;
  final bool appbar;

  const FavoritePage({
    super.key,
    this.testFavorites = const [],
    required this.appbar,
  });

  @override
  State<FavoritePage> createState() => FavoriteSate();
}
