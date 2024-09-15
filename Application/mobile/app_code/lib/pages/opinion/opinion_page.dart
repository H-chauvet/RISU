import 'package:flutter/material.dart';

import 'opinion_state.dart';

/// OpinionPage.
/// This class is the main class for the opinion page.
/// params:
/// [itemId] - the id of the item.
/// [testOpinions] - the list of opinions.
class OpinionPage extends StatefulWidget {
  final int itemId;
  final List<dynamic> testOpinions;

  const OpinionPage({
    super.key,
    required this.itemId,
    this.testOpinions = const [],
  });

  @override
  State<OpinionPage> createState() => OpinionPageState(itemId: itemId);
}
