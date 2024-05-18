import 'package:flutter/material.dart';

import 'favorite_state.dart';

class FavoritePage extends StatefulWidget {
  final List<dynamic> favorites;

  const FavoritePage({
    super.key,
    this.favorites = const [],
  });

  @override
  State<FavoritePage> createState() => FavoriteSate();
}
